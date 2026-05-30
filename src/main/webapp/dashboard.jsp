<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}
%>

<%
int totalRecords = 0;
double totalAmount = 0;
String chartLabels = "";
String chartData = "";

try {
    Connection con = DBConnection.getConnection();

    PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM expenses");
    ResultSet rs1 = ps1.executeQuery();

    if(rs1.next()){
        totalRecords = rs1.getInt(1);
    }

    PreparedStatement ps2 = con.prepareStatement("SELECT SUM(amount) FROM expenses");
    ResultSet rs2 = ps2.executeQuery();

    if(rs2.next()){
        totalAmount = rs2.getDouble(1);
    }
    PreparedStatement ps3 = con.prepareStatement(
    	    "SELECT category, SUM(amount) FROM expenses GROUP BY category"
    	);

    	ResultSet rs3 = ps3.executeQuery();

    	while(rs3.next()){
    	    chartLabels += "'" + rs3.getString(1) + "',";
    	    chartData += rs3.getDouble(2) + ",";
    	}

} catch(Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body class="bg-light">

<div class="container mt-5">

    <h2 class="text-center mb-4">Organization Expense Dashboard</h2>

    <div class="alert alert-primary text-center">
        Welcome, <b><%= session.getAttribute("name") %></b> |
        Role: <b><%= session.getAttribute("role") %></b>
    </div>

    <div class="row text-center">

        <div class="col-md-4">
            <div class="card shadow bg-success text-white">
                <div class="card-body">
                    <h4>Total Records</h4>
                    <h2><%= totalRecords %></h2>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow bg-warning text-dark">
                <div class="card-body">
                    <h4>Total Amount</h4>
                    <h2>Rs. <%= totalAmount %></h2>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card shadow bg-info text-white">
                <div class="card-body">
                    <h4>Current User</h4>
                    <h2><%= session.getAttribute("role") %></h2>
                </div>
            </div>
        </div>

    </div>

    <div class="text-center mt-4">
        <a href="addExpense.jsp" class="btn btn-success">Add Expense</a>
        <a href="viewExpenses.jsp" class="btn btn-primary">View Expenses</a>
        <a href="login.jsp" class="btn btn-danger">Logout</a>
    </div>

</div>
<div class="card shadow mt-5">
    <div class="card-header bg-dark text-white text-center">
        <h4>Category-wise Expense Chart</h4>
    </div>
    <div class="card-body">
        <canvas id="expenseChart"></canvas>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
const ctx = document.getElementById('expenseChart');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [<%= chartLabels %>],
        datasets: [{
            label: 'Expense Amount',
            data: [<%= chartData %>],
            borderWidth: 1
        }]
    }
});
</script>
</body>
</html>