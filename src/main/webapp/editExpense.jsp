<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
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
</head>

<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-warning text-dark text-center">
            <h4>Edit Expense</h4>
        </div>

        <div class="card-body">
            <form action="UpdateExpenseServlet" method="post">

                <input type="hidden" name="id" value="<%= id %>">

                <input type="text" name="title" class="form-control mb-3" value="<%= title %>" required>

                <input type="number" name="amount" class="form-control mb-3" value="<%= amount %>" required>

                <select name="category" class="form-control mb-3" required>
                    <option <%= category.equals("Travel") ? "selected" : "" %>>Travel</option>
                    <option <%= category.equals("Food") ? "selected" : "" %>>Food</option>
                    <option <%= category.equals("Office Supplies") ? "selected" : "" %>>Office Supplies</option>
                    <option <%= category.equals("Internet") ? "selected" : "" %>>Internet</option>
                    <option <%= category.equals("Training") ? "selected" : "" %>>Training</option>
                </select>

                <input type="date" name="expense_date" class="form-control mb-3" value="<%= expenseDate %>" required>

                <button type="submit" class="btn btn-warning w-100">Update Expense</button>
            </form>

            <a href="viewExpenses.jsp" class="btn btn-secondary w-100 mt-3">Back</a>
        </div>
    </div>
</div>

</body>
</html>	