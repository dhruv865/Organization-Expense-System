<!DOCTYPE html>
<html>
<head>
<title>Login</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">

            <div class="card shadow">
                <div class="card-header text-center bg-primary text-white">
                    <h4>Expense System Login</h4>
                </div>

                <div class="card-body">
                    <form action="LoginServlet" method="post">

                        <input type="email" name="email" class="form-control mb-3" placeholder="Email" required>

                        <input type="password" name="password" class="form-control mb-3" placeholder="Password" required>

                        <button type="submit" class="btn btn-primary w-100">Login</button>

                    </form>

                    <p class="text-danger text-center mt-3">
                        <%= request.getParameter("error") != null ? "Invalid email or password" : "" %>
                    </p>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>