<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
String role = (String) session.getAttribute("role");
String currentUser = (String) session.getAttribute("name");

if(role == null){
    response.sendRedirect("login.jsp");
    return;
}

if(role.equals("Employee")){
    response.sendRedirect("dashboard.jsp");
    return;
}

String badgeColor = "primary";
if(role.equals("Admin")){
    badgeColor = "danger";
} else if(role.equals("Manager")){
    badgeColor = "success";
}

double totalExpense = 0;
int totalRecords = 0;
double highestExpense = 0;
String topCategory = "-";

String chartLabels = "";
String chartData = "";

try{
    Connection con = DBConnection.getConnection();

    ResultSet rs1 = con.createStatement().executeQuery("SELECT SUM(amount) FROM expenses");
    if(rs1.next()) totalExpense = rs1.getDouble(1);

    ResultSet rs2 = con.createStatement().executeQuery("SELECT COUNT(*) FROM expenses");
    if(rs2.next()) totalRecords = rs2.getInt(1);

    ResultSet rs3 = con.createStatement().executeQuery("SELECT MAX(amount) FROM expenses");
    if(rs3.next()) highestExpense = rs3.getDouble(1);

    ResultSet rs4 = con.createStatement().executeQuery(
        "SELECT category, SUM(amount) total FROM expenses GROUP BY category ORDER BY total DESC LIMIT 1"
    );
    if(rs4.next()) topCategory = rs4.getString("category");

    ResultSet rsChart = con.createStatement().executeQuery(
        "SELECT category, SUM(amount) total FROM expenses GROUP BY category"
    );

    while(rsChart.next()){
        chartLabels += "'" + rsChart.getString("category") + "',";
        chartData += rsChart.getDouble("total") + ",";
    }

}catch(Exception e){
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Reports</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body {
    margin: 0;
    background: #f5f8fc;
    font-family: Arial, sans-serif;
}

.sidebar {
    width: 270px;
    height: 100vh;
    position: fixed;
    background: linear-gradient(180deg, #06152e, #082c66);
    color: white;
    padding: 30px 24px;
}

.logo {
    font-size: 30px;
    font-weight: 800;
    margin-bottom: 10px;
}

.logo span {
    color: #3b82f6;
}

.sidebar small {
    color: #cbd5e1;
}

.sidebar a {
    display: block;
    color: #dbeafe;
    text-decoration: none;
    padding: 14px 18px;
    border-radius: 12px;
    margin: 12px 0;
    font-weight: 600;
}

.sidebar a:hover,
.sidebar .active {
    background: #2563eb;
    color: white;
}

.user-box {
    position: absolute;
    bottom: 35px;
    left: 24px;
    right: 24px;
    background: rgba(255,255,255,0.08);
    border-radius: 18px;
    padding: 18px;
}

.main {
    margin-left: 270px;
    padding: 32px;
}

.topbar {
    background: white;
    border-radius: 22px;
    padding: 28px 32px;
    box-shadow: 0 14px 35px rgba(15,23,42,0.06);
    margin-bottom: 28px;
}

.card-report {
    border: none;
    border-radius: 22px;
    color: white;
    padding: 28px;
    min-height: 150px;
    box-shadow: 0 18px 40px rgba(15,23,42,0.12);
}

.green { background: linear-gradient(135deg,#16a34a,#22c55e); }
.blue { background: linear-gradient(135deg,#2563eb,#38bdf8); }
.purple { background: linear-gradient(135deg,#7c3aed,#a855f7); }
.orange { background: linear-gradient(135deg,#ea580c,#fb923c); }

.report-card {
    background: white;
    border-radius: 22px;
    padding: 28px;
    box-shadow: 0 14px 35px rgba(15,23,42,0.06);
    margin-top: 28px;
}

.table th {
    background: #0f172a;
    color: white;
}

.footer-text {
    text-align: center;
    color: #64748b;
    margin-top: 30px;
}
</style>
</head>

<body>

<div class="sidebar">
    <div class="logo">Expense<span>Pro</span></div>
    <small>Expense Management System</small>

    <div class="mt-5">
        <a href="dashboard.jsp"><i class="bi bi-house me-2"></i> Dashboard</a>
        <a href="addExpense.jsp"><i class="bi bi-plus-circle me-2"></i> Add Expense</a>
        <a href="viewExpenses.jsp"><i class="bi bi-list-ul me-2"></i> View Expenses</a>
        <a href="Reports.jsp" class="active"><i class="bi bi-file-earmark-bar-graph me-2"></i> Reports</a>
        <a href="login.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </div>

    <div class="user-box">
        <b><%= currentUser %></b><br>
        <span class="badge bg-<%= badgeColor %> mt-2"><%= role %></span>
    </div>
</div>

<div class="main">

    <div class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1">Expense Reports</h2>
            <p class="text-muted mb-0">Analyze organization expenses and export reports</p>
        </div>

        <div class="badge bg-<%= badgeColor %> fs-6 p-3">
            Role: <%= role %>
        </div>
    </div>

    <div class="row">

        <div class="col-md-3">
            <div class="card-report green">
                <h5>Total Expense</h5>
                <h2>Rs. <%= totalExpense %></h2>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-report blue">
                <h5>Total Records</h5>
                <h2><%= totalRecords %></h2>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-report purple">
                <h5>Highest Expense</h5>
                <h2>Rs. <%= highestExpense %></h2>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-report orange">
                <h5>Top Category</h5>
                <h2><%= topCategory %></h2>
            </div>
        </div>

    </div>

    <div class="report-card">
        <h4 class="fw-bold mb-3">Category Summary</h4>

        <table class="table table-bordered table-hover">
            <tr>
                <th>Category</th>
                <th>Total Amount</th>
            </tr>

            <%
            try{
                Connection con = DBConnection.getConnection();
                ResultSet rs = con.createStatement().executeQuery(
                    "SELECT category, SUM(amount) total FROM expenses GROUP BY category"
                );

                while(rs.next()){
            %>

            <tr>
                <td>
                    <span class="badge bg-info text-dark">
                        <%= rs.getString("category") %>
                    </span>
                </td>
                <td>
                    <span class="fw-bold text-success">
                        Rs. <%= rs.getDouble("total") %>
                    </span>
                </td>
            </tr>

            <%
                }
            }catch(Exception e){
                e.printStackTrace();
            }
            %>
        </table>

        <a href="dashboard.jsp" class="btn btn-primary">
            <i class="bi bi-arrow-left me-1"></i> Back To Dashboard
        </a>

        <a href="ExportCSVServlet" class="btn btn-success">
            <i class="bi bi-download me-1"></i> Export Report
        </a>
    </div>

    <div class="report-card">
        <h4 class="fw-bold mb-3">Expense Distribution Chart</h4>
        <div style="max-width:600px; margin:auto;">
    <canvas id="reportChart"></canvas>
</div>
    </div>

    <div class="footer-text">
        © 2026 ExpensePro | Organization Expense Management System
    </div>

</div>

<script>
const ctx = document.getElementById('reportChart');

new Chart(ctx, {
    type: 'doughnut',
    data: {
        labels: [<%= chartLabels %>],
        datasets: [{
            label: 'Expense Amount',
            data: [<%= chartData %>],
            backgroundColor: [
                '#3b82f6',
                '#22c55e',
                '#f59e0b',
                '#ef4444',
                '#8b5cf6'
            ]
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    }
});
</script>

</body>
</html>