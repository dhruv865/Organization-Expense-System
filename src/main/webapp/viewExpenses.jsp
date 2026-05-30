<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}
%>

<!DOCTYPE html>
<html>
<head>
<title>View Expenses</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">

    <h2 class="text-center mb-4">All Expenses</h2>

    <form method="get" action="viewExpenses.jsp" class="row mb-4">

        <div class="col-md-5">
            <input type="text" name="search" class="form-control" placeholder="Search by title">
        </div>

        <div class="col-md-4">
            <select name="category" class="form-control">
                <option value="">All Categories</option>
                <option value="Travel">Travel</option>
                <option value="Food">Food</option>
                <option value="Office Supplies">Office Supplies</option>
                <option value="Internet">Internet</option>
                <option value="Training">Training</option>
            </select>
        </div>

        <div class="col-md-3">
            <button type="submit" class="btn btn-primary">Search</button>
            <a href="viewExpenses.jsp" class="btn btn-secondary">Reset</a>
        </div>

    </form>

    <table class="table table-bordered table-striped">
        <tr class="table-dark">
            <th>ID</th>
            <th>Title</th>
            <th>Amount</th>
            <th>Category</th>
            <th>Date</th>
            <th>Added By</th>
            <th>Action</th>
        </tr>

        <%
        String search = request.getParameter("search");
        String category = request.getParameter("category");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM expenses WHERE 1=1";

            if(search != null && !search.trim().equals("")){
                sql += " AND title LIKE ?";
            }

            if(category != null && !category.trim().equals("")){
                sql += " AND category=?";
            }

            PreparedStatement ps = con.prepareStatement(sql);

            int index = 1;

            if(search != null && !search.trim().equals("")){
                ps.setString(index++, "%" + search + "%");
            }

            if(category != null && !category.trim().equals("")){
                ps.setString(index++, category);
            }

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
        %>

        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getDouble("amount") %></td>
            <td><%= rs.getString("category") %></td>
            <td><%= rs.getString("expense_date") %></td>
            <td><%= rs.getString("added_by") %></td>
            <td>
                <a href="editExpense.jsp?id=<%= rs.getInt("id") %>" class="btn btn-warning btn-sm">Edit</a>

                <a href="DeleteExpenseServlet?id=<%= rs.getInt("id") %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Are you sure you want to delete this expense?');">
                   Delete
                </a>
            </td>
        </tr>

        <%
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        %>

    </table>
<a href="ExportCSVServlet" class="btn btn-success mb-3">Export CSV</a>
<br>
    <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
</div>

</body>
</html>