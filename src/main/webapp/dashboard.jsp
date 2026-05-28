<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
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

    <div class="card shadow">
        <div class="card-body text-center">
            <h2>Welcome, <%= session.getAttribute("name") %></h2>
            <h4>Your Role: <%= session.getAttribute("role") %></h4>

            <a href="login.jsp" class="btn btn-danger mt-3">Logout</a>
        </div>
    </div>

</div>

</body>
</html>