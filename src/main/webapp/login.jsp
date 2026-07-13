<!DOCTYPE html>
<html>
<head>
<title>ExpensePro Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    margin: 0;
    min-height: 100vh;
    background: linear-gradient(135deg, #0f172a, #1d4ed8);
    font-family: Arial, sans-serif;
}

.login-wrapper {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

.login-card {
    width: 430px;
    background: #ffffff;
    border-radius: 22px;
    padding: 35px;
    box-shadow: 0 25px 60px rgba(0,0,0,0.25);
}

.brand {
    text-align: center;
    margin-bottom: 25px;
}

.brand h2 {
    font-weight: 800;
    color: #0f172a;
}

.brand p {
    color: #64748b;
    margin-bottom: 0;
}

.form-control {
    height: 48px;
    border-radius: 12px;
}

.login-btn {
    height: 48px;
    border-radius: 12px;
    font-weight: 600;
    background: linear-gradient(135deg, #2563eb, #38bdf8);
    border: none;
}
<div class="text-center mt-3">
    <a href="forgotPassword.jsp">Forgot Password?</a>
</div>

.info-box {
    background: #eff6ff;
    border-radius: 14px;
    padding: 12px;
    font-size: 14px;
    color: #1e3a8a;
    margin-top: 18px;
}

.error {
    color: red;
    text-align: center;
    margin-top: 15px;
}
</style>
</head>

<body>

<div class="login-wrapper">
    <div class="login-card">

        <div class="brand">
            <h2>ExpensePro</h2>
            <p>Organization Expense Management System</p>
        </div>
<%
String error = request.getParameter("error");

if ("invalid".equals(error)) {
%>
    <div class="alert alert-danger">
        Invalid email address or password.
    </div>
<%
} else if ("empty".equals(error)) {
%>
    <div class="alert alert-warning">
        Please enter both email and password.
    </div>
<%
} else if ("database".equals(error)) {
%>
    <div class="alert alert-danger">
        Unable to connect to the database. Please try again.
    </div>
<%
}
%>
        <form action="LoginServlet" method="post">
            <input type="email" name="email" class="form-control mb-3" placeholder="Email Address" required>

            <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

            <button type="submit" class="btn btn-primary w-100 login-btn">
                Login to Dashboard
            </button>
            <div class="row g-2 mt-2">
    <div class="col-4">
        <button type="button"
                class="btn btn-outline-danger w-100 btn-sm"
                onclick="fillDemo('admin@expensepro.com','admin123')">
            Admin Demo
        </button>
    </div>

    <div class="col-4">
        <button type="button"
                class="btn btn-outline-success w-100 btn-sm"
                onclick="fillDemo('manager@expensepro.com','manager123')">
            Manager Demo
        </button>
    </div>

    <div class="col-4">
        <button type="button"
                class="btn btn-outline-primary w-100 btn-sm"
                onclick="fillDemo('employee@expensepro.com','employee123')">
            Employee Demo
        </button>
    </div>
</div>
        </form>

        <%
        if(request.getParameter("error") != null){
        %>
            <div class="error">Invalid email or password</div>
        <%
        }
        %>

        <div class="info-box">
            Role-based access enabled for Admin, Manager, and Employee.
        </div>
<div class="info-box mt-3">
    <strong>Demo Credentials</strong><br><br>

    <strong>Admin</strong><br>
    Email: admin@expensepro.com<br>
    Password: admin123<br><br>

    <strong>Manager</strong><br>
    Email: manager@expensepro.com<br>
    Password: manager123<br><br>

    <strong>Employee</strong><br>
    Email: employee@expensepro.com<br>
    Password: employee123
</div>
    </div>
</div>
<script>
function fillDemo(email, password) {
    document.querySelector('input[name="email"]').value = email;
    document.querySelector('input[name="password"]').value = password;
}
</script>
</body>
</html>