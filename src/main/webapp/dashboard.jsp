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

    PreparedStatement ps3 = con.prepareStatement("SELECT category, SUM(amount) FROM expenses GROUP BY category");
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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    background: #f4f7fb;
    font-family: Arial, sans-serif;
}

.sidebar {
    width: 250px;
    height: 100vh;
    position: fixed;
    background: #0f172a;
    color: white;
    padding: 25px 20px;
}

.sidebar h3 {
    font-weight: bold;
    margin-bottom: 35px;
}

.sidebar a {
    display: block;
    color: #cbd5e1;
    text-decoration: none;
    margin: 18px 0;
    font-size: 16px;
}

.sidebar a:hover {
    color: white;
}

.main-content {
    margin-left: 270px;
    padding: 30px;
}

.topbar {
    background: white;
    border-radius: 16px;
    padding: 20px 25px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
    margin-bottom: 30px;
}

.stat-card {
    border: none;
    border-radius: 18px;
    color: white;
    padding: 25px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.12);
}

.card-green {
    background: linear-gradient(135deg, #16a34a, #22c55e);
}

.card-blue {
    background: linear-gradient(135deg, #2563eb, #38bdf8);
}

.card-purple {
    background: linear-gradient(135deg, #7c3aed, #a855f7);
}

.chart-card {
    background: white;
    border-radius: 18px;
    padding: 25px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
    margin-top: 30px;
}

.action-btn {
    border-radius: 12px;
    padding: 12px 20px;
    margin-right: 10px;
}
</style>
</head>

<body>

<div class="sidebar">
    <h3>ExpensePro</h3>

    <a href="dashboard.jsp">Dashboard</a>
    <a href="addExpense.jsp">Add Expense</a>
    <a href="viewExpenses.jsp">View Expenses</a>
    <a href="viewExpenses.jsp">Reports</a>
    <a href="login.jsp">Logout</a>
</div>

<div class="main-content">

    <div class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h2>Organization Expense Dashboard</h2>
            <p class="text-muted mb-0">
                Welcome, <b><%= session.getAttribute("name") %></b>
            </p>
        </div>

        <div class="badge bg-primary fs-6 p-3">
            Role: <%= session.getAttribute("role") %>
        </div>
    </div>

    <div class="row">

        <div class="col-md-4">
            <div class="stat-card card-green">
                <h5>Total Records</h5>
                <h1><%= totalRecords %></h1>
                <p class="mb-0">Expense entries stored</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card card-blue">
                <h5>Total Amount</h5>
                <h1>Rs. <%= totalAmount %></h1>
                <p class="mb-0">Overall expense value</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card card-purple">
                <h5>Current User</h5>
                <h1><%= session.getAttribute("role") %></h1>
                <p class="mb-0">Logged-in account type</p>
            </div>
        </div>

    </div>

    <div class="mt-4">
        <a href="addExpense.jsp" class="btn btn-success action-btn">+ Add Expense</a>
        <a href="viewExpenses.jsp" class="btn btn-primary action-btn">View Expenses</a>
        <a href="ExportCSVServlet" class="btn btn-dark action-btn">Export CSV</a>
    </div>

    <div class="chart-card">
        <h4 class="mb-4">Category-wise Expense Analysis</h4>
        <canvas id="expenseChart"></canvas>
    </div>

</div>

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