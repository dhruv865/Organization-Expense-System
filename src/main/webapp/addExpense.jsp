<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Add Expense</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-success text-white text-center">
            <h4>Add Expense</h4>
        </div>

        <div class="card-body">

            <%
            if(request.getParameter("success") != null){
            %>
                <div class="alert alert-success">Expense added successfully!</div>
            <%
            }
            if(request.getParameter("error") != null){
            %>
                <div class="alert alert-danger">Something went wrong!</div>
            <%
            }
            %>

            <form action="AddExpenseServlet" method="post">
                <input type="text" name="title" class="form-control mb-3" placeholder="Expense Title" required>

                <input type="number" name="amount" class="form-control mb-3" placeholder="Amount" required>

                <select name="category" class="form-control mb-3" required>
                    <option value="">Select Category</option>
                    <option>Travel</option>
                    <option>Food</option>
                    <option>Office Supplies</option>
                    <option>Internet</option>
                    <option>Training</option>
                </select>

                <input type="date" name="expense_date" class="form-control mb-3" required>

                <button type="submit" class="btn btn-success w-100">Save Expense</button>
            </form>

            <a href="dashboard.jsp" class="btn btn-secondary w-100 mt-3">Back to Dashboard</a>

        </div>
    </div>
</div>

</body>
</html>