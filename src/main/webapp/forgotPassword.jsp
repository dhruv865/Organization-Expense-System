<!DOCTYPE html>
<html>
<head>
<title>Forgot Password</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">

            <div class="card shadow">
                <div class="card-header bg-primary text-white text-center">
                    <h4>Forgot Password</h4>
                </div>

                <div class="card-body">
                    <form action="ForgotPasswordServlet" method="post">

                        <input type="email" name="email" class="form-control mb-3"
                               placeholder="Enter Registered Email" required>

                        <input type="text" name="name" class="form-control mb-3"
                               placeholder="Enter Registered Name" required>

                        <input type="password" name="newPassword" class="form-control mb-3"
                               placeholder="Enter New Password" required>

                        <button type="submit" class="btn btn-primary w-100">
                            Reset Password
                        </button>
                    </form>

                    <%
                    if(request.getParameter("success") != null){
                    %>
                        <div class="alert alert-success mt-3">Password reset successfully!</div>
                    <%
                    }
                    if(request.getParameter("error") != null){
                    %>
                        <div class="alert alert-danger mt-3">Invalid email or name!</div>
                    <%
                    }
                    %>

                    <a href="login.jsp" class="btn btn-secondary w-100 mt-3">
                        Back to Login
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>