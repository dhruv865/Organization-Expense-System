<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}

String role = (String) session.getAttribute("role");
String currentUser = (String) session.getAttribute("name");

String badgeColor = "primary";
if(role.equals("Admin")){
    badgeColor = "danger";
} else if(role.equals("Manager")){
    badgeColor = "success";
} else {
    badgeColor = "primary";
}

int totalRecords = 0;
double totalAmount = 0;
String chartLabels = "";
String chartData = "";

try {
    Connection con = DBConnection.getConnection();

    String countSql = "SELECT COUNT(*) FROM expenses";
    String amountSql = "SELECT SUM(amount) FROM expenses";
    String chartSql = "SELECT category, SUM(amount) FROM expenses GROUP BY category";

    if(role.equals("Employee")){
        countSql = "SELECT COUNT(*) FROM expenses WHERE added_by=?";
        amountSql = "SELECT SUM(amount) FROM expenses WHERE added_by=?";
        chartSql = "SELECT category, SUM(amount) FROM expenses WHERE added_by=? GROUP BY category";
    }

    PreparedStatement ps1 = con.prepareStatement(countSql);
    if(role.equals("Employee")){
        ps1.setString(1, currentUser);
    }
    ResultSet rs1 = ps1.executeQuery();
    if(rs1.next()){
        totalRecords = rs1.getInt(1);
    }

    PreparedStatement ps2 = con.prepareStatement(amountSql);
    if(role.equals("Employee")){
        ps2.setString(1, currentUser);
    }
    ResultSet rs2 = ps2.executeQuery();
    if(rs2.next()){
        totalAmount = rs2.getDouble(1);
    }

    PreparedStatement ps3 = con.prepareStatement(chartSql);
    if(role.equals("Employee")){
        ps3.setString(1, currentUser);
    }
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

.stat-card {
    border: none;
    border-radius: 22px;
    color: white;
    padding: 28px;
    min-height: 170px;
    box-shadow: 0 18px 40px rgba(15,23,42,0.12);
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
    border-radius: 22px;
    padding: 28px;
    box-shadow: 0 14px 35px rgba(15,23,42,0.06);
    margin-top: 28px;
}

.action-btn {
    height: 50px;
    border-radius: 12px;
    font-weight: 700;
    padding: 12px 22px;
    margin-right: 10px;
}

.icon-box {
    width: 48px;
    height: 48px;
    border-radius: 14px;
    background: rgba(255,255,255,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
}

.info-card {
    border: none;
    border-radius: 18px;
    box-shadow: 0 10px 25px rgba(15,23,42,0.06);
}
</style>
</head>

<body>

<div class="sidebar">
    <div class="logo">Expense<span>Pro</span></div>
    <small>Expense Management System</small>

    <div class="mt-5">
        <a href="dashboard.jsp" class="active"><i class="bi bi-house me-2"></i> Dashboard</a>
        <a href="addExpense.jsp"><i class="bi bi-plus-circle me-2"></i> Add Expense</a>
        <a href="viewExpenses.jsp"><i class="bi bi-list-ul me-2"></i> View Expenses</a>

        <% if(role.equals("Admin") || role.equals("Manager")) { %>
            <a href="viewExpenses.jsp"><i class="bi bi-file-earmark-bar-graph me-2"></i> Reports</a>
        <% } %>

        <a href="LogoutServlet"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </div>

    <div class="user-box">
        <b><%= currentUser %></b><br>
        <span class="badge bg-<%= badgeColor %> mt-2"><%= role %></span>
    </div>
</div>

<div class="main">

    <div class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1">Organization Expense Dashboard</h2>
            <p class="text-muted mb-0">
                Welcome, <b><%= currentUser %></b>. Monitor expenses, reports and analytics.
            </p>
        </div>

        <div class="badge bg-<%= badgeColor %> fs-6 p-3">
            Role: <%= role %>
        </div>
    </div>

    <div class="row">

        <div class="col-md-4">
            <div class="stat-card card-green">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5>Total Records</h5>
                        <h1><%= totalRecords %></h1>
                        <p class="mb-0">Expense entries stored</p>
                    </div>
                    <div class="icon-box">
                        <i class="bi bi-database"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card card-blue">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5>Total Amount</h5>
                        <h1>Rs. <%= totalAmount %></h1>
                        <p class="mb-0">Overall expense value</p>
                    </div>
                    <div class="icon-box">
                        <i class="bi bi-currency-rupee"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card card-purple">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5>Current User</h5>
                        <h3><%= currentUser %></h3>
                        <p class="mb-0">Account type: <%= role %></p>
                    </div>
                    <div class="icon-box">
                        <i class="bi bi-person-badge"></i>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div class="row mt-4">

        <div class="col-md-6">
            <div class="card info-card">
                <div class="card-body">
                    <h5><i class="bi bi-shield-check text-success me-2"></i>Role Access</h5>
                    <p class="text-muted mb-0">
                        <% if(role.equals("Admin")) { %>
                            You have full access to manage expenses, delete records and export reports.
                        <% } else if(role.equals("Manager")) { %>
                            You can view, edit and export expense records.
                        <% } else { %>
                            You can add expenses and view only your own expense records.
                        <% } %>
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card info-card">
                <div class="card-body">
                    <h5><i class="bi bi-calendar-event text-primary me-2"></i>Current Session</h5>
                    <p class="text-muted mb-0">
                        Logged in as <b><%= currentUser %></b> with <b><%= role %></b> privileges.
                    </p>
                </div>
            </div>
        </div>

    </div>

    <div class="mt-4">
        <a href="addExpense.jsp" class="btn btn-success action-btn">
            <i class="bi bi-plus-circle me-1"></i> Add Expense
        </a>

        <a href="viewExpenses.jsp" class="btn btn-primary action-btn">
            <i class="bi bi-list-ul me-1"></i> View Expenses
        </a>

        <% if(role.equals("Admin") || role.equals("Manager")) { %>
            <a href="ExportCSVServlet" class="btn btn-dark action-btn">
                <i class="bi bi-download me-1"></i> Export CSV
            </a>
        <% } %>
    </div>

    <div class="chart-card">
        <h4 class="fw-bold mb-2">Category-wise Expense Analysis</h4>
        <p class="text-muted">Visual breakdown of expenses by category</p>
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