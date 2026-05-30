<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}

String role = (String) session.getAttribute("role");

if(role.equals("Employee")){
    response.sendRedirect("dashboard.jsp");
}

int id = Integer.parseInt(request.getParameter("id"));

String title = "";
double amount = 0;
String category = "";
String expenseDate = "";

try {
    Connection con = DBConnection.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT * FROM expenses WHERE id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        title = rs.getString("title");
        amount = rs.getDouble("amount");
        category = rs.getString("category");
        expenseDate = rs.getString("expense_date");
    }
} catch(Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Expense</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

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
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 28px;
}

.breadcrumb-text {
    color: #2563eb;
    font-weight: 600;
}

.form-card {
    background: white;
    border-radius: 22px;
    box-shadow: 0 18px 40px rgba(15,23,42,0.08);
    overflow: hidden;
}

.form-header {
    background: linear-gradient(135deg, #fff7ed, #fffbeb);
    padding: 28px 40px;
    display: flex;
    align-items: center;
    gap: 18px;
}

.icon-circle {
    width: 70px;
    height: 70px;
    background: #f59e0b;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
}

.form-body {
    padding: 40px;
}

.field-row {
    display: grid;
    grid-template-columns: 70px 180px 1fr;
    align-items: center;
    gap: 20px;
    margin-bottom: 28px;
}

.field-icon {
    width: 58px;
    height: 58px;
    background: #f8fafc;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #f59e0b;
    font-size: 24px;
}

.form-control {
    height: 58px;
    border-radius: 12px;
}

.notice {
    background: #fff7ed;
    border: 1px solid #fed7aa;
    border-radius: 16px;
    padding: 20px;
    color: #92400e;
    margin-bottom: 30px;
}

.btn-custom {
    height: 56px;
    border-radius: 12px;
    font-weight: 700;
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
        <a href="viewExpenses.jsp" class="active"><i class="bi bi-list-ul me-2"></i> View Expenses</a>
        <a href="login.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </div>

    <div class="user-box">
        <b><%= session.getAttribute("name") %></b><br>
        <span class="badge bg-primary mt-2"><%= session.getAttribute("role") %></span>
    </div>
</div>

<div class="main">

    <div class="topbar">
        <div>
            <h2 class="fw-bold">Edit Expense</h2>
            <div class="breadcrumb-text">Dashboard / Edit Expense</div>
        </div>

        <div class="text-muted">
            <i class="bi bi-pencil-square me-2"></i>
            Update Expense Entry
        </div>
    </div>

    <div class="form-card">

        <div class="form-header">
            <div class="icon-circle">
                <i class="bi bi-pencil-square"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-1">Update Expense Details</h4>
                <p class="mb-0 text-muted">Modify the selected expense information carefully</p>
            </div>
        </div>

        <div class="form-body">

            <form action="UpdateExpenseServlet" method="post">

                <input type="hidden" name="id" value="<%= id %>">

                <div class="field-row">
                    <div class="field-icon"><i class="bi bi-type"></i></div>
                    <label class="fw-bold">Expense Title <span class="text-danger">*</span></label>
                    <input type="text" name="title" class="form-control" value="<%= title %>" required>
                </div>

                <div class="field-row">
                    <div class="field-icon"><i class="bi bi-currency-rupee"></i></div>
                    <label class="fw-bold">Amount <span class="text-danger">*</span></label>
                    <input type="number" name="amount" class="form-control" value="<%= amount %>" required>
                </div>

                <div class="field-row">
                    <div class="field-icon"><i class="bi bi-grid"></i></div>
                    <label class="fw-bold">Category <span class="text-danger">*</span></label>
                    <select name="category" class="form-control" required>
                        <option <%= category.equals("Travel") ? "selected" : "" %>>Travel</option>
                        <option <%= category.equals("Food") ? "selected" : "" %>>Food</option>
                        <option <%= category.equals("Office Supplies") ? "selected" : "" %>>Office Supplies</option>
                        <option <%= category.equals("Internet") ? "selected" : "" %>>Internet</option>
                        <option <%= category.equals("Training") ? "selected" : "" %>>Training</option>
                    </select>
                </div>

                <div class="field-row">
                    <div class="field-icon"><i class="bi bi-calendar-date"></i></div>
                    <label class="fw-bold">Expense Date <span class="text-danger">*</span></label>
                    <input type="date" name="expense_date" class="form-control" value="<%= expenseDate %>" required>
                </div>

                <div class="notice">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Please review the updated details before saving changes.
                </div>

                <div class="row">
                    <div class="col-md-4">
                        <a href="viewExpenses.jsp" class="btn btn-outline-secondary w-100 btn-custom">
                            Back to Expenses
                        </a>
                    </div>

                    <div class="col-md-8">
                        <button type="submit" class="btn btn-warning w-100 btn-custom">
                            <i class="bi bi-check-circle me-2"></i> Update Expense
                        </button>
                    </div>
                </div>

            </form>

        </div>
    </div>

</div>

</body>
</html>