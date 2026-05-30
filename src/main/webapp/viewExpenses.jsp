<%@ page import="java.sql.*" %>
<%@ page import="com.expense.db.DBConnection" %>

<%
if(session.getAttribute("name") == null){
    response.sendRedirect("login.jsp");
}

String role = (String) session.getAttribute("role");
String currentUser = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
<title>View Expenses</title>

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
    background: white;
    border-radius: 22px;
    padding: 26px 30px;
    box-shadow: 0 14px 35px rgba(15,23,42,0.06);
    margin-bottom: 28px;
}

.filter-card {
    background: white;
    border-radius: 20px;
    padding: 24px;
    box-shadow: 0 12px 30px rgba(15,23,42,0.06);
    margin-bottom: 25px;
}

.table-card {
    background: white;
    border-radius: 20px;
    padding: 24px;
    box-shadow: 0 12px 30px rgba(15,23,42,0.06);
}

.form-control {
    height: 48px;
    border-radius: 12px;
}

.table th {
    background: #0f172a;
    color: white;
}

.btn {
    border-radius: 10px;
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

        <% if(role.equals("Admin") || role.equals("Manager")) { %>
            <a href="Reports.jsp">
    <i class="bi bi-file-earmark-bar-graph me-2"></i>
    Reports
</a>
        <% } %>

        <a href="login.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
    </div>

    <div class="user-box">
        <b><%= session.getAttribute("name") %></b><br>
        <span class="badge bg-primary mt-2"><%= session.getAttribute("role") %></span>
    </div>
</div>

<div class="main">

    <div class="topbar d-flex justify-content-between align-items-center">
        <div>
            <h2 class="fw-bold mb-1">Expense Records</h2>
            <p class="text-muted mb-0">Search, filter and manage organization expenses</p>
        </div>

        <div class="badge bg-primary fs-6 p-3">
            Role: <%= role %>
        </div>
    </div>

    <div class="filter-card">
        <form method="get" action="viewExpenses.jsp" class="row g-3">

            <div class="col-md-5">
                <input type="text" name="search" class="form-control" placeholder="Search by expense title">
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
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-search me-1"></i> Search
                </button>
                <a href="viewExpenses.jsp" class="btn btn-secondary">
                    Reset
                </a>
            </div>

        </form>
    </div>

    <div class="table-card">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold mb-0">All Expenses</h4>

            <% if(role.equals("Admin") || role.equals("Manager")) { %>
                <a href="ExportCSVServlet" class="btn btn-success">
                    <i class="bi bi-download me-1"></i> Export CSV
                </a>
            <% } %>
        </div>

        <table class="table table-bordered table-hover align-middle">
            <tr>
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

                if(role.equals("Employee")){
                    sql += " AND added_by=?";
                }

                if(search != null && !search.trim().equals("")){
                    sql += " AND title LIKE ?";
                }

                if(category != null && !category.trim().equals("")){
                    sql += " AND category=?";
                }

                PreparedStatement ps = con.prepareStatement(sql);

                int index = 1;

                if(role.equals("Employee")){
                    ps.setString(index++, currentUser);
                }

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
                <td>
    <span class="fw-bold text-success">
        Rs. <%= rs.getDouble("amount") %>
    </span>
</td>
                <td><span class="badge bg-info text-dark"><%= rs.getString("category") %></span></td>
                <td><%= rs.getString("expense_date") %></td>
                <td>
    <span class="badge bg-primary">
        <%= rs.getString("added_by") %>
    </span>
</td>
                <td>
                    <% if(role.equals("Admin") || role.equals("Manager")) { %>
                        <a href="editExpense.jsp?id=<%= rs.getInt("id") %>"
   class="btn btn-warning btn-sm px-3 fw-bold">
    Edit
</a>
                    <% } %>

                    <% if(role.equals("Admin")) { %>
                        <a href="DeleteExpenseServlet?id=<%= rs.getInt("id") %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to delete this expense?');">
                           Delete
                        </a>
                    <% } %>

                    <% if(role.equals("Employee")) { %>
                        <span class="text-muted">View Only</span>
                    <% } %>
                </td>
            </tr>

            <%
                }
            } catch(Exception e) {
                e.printStackTrace();
            }
            %>

        </table>

        <a href="dashboard.jsp" class="btn btn-outline-secondary mt-3">
            <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
        </a>

    </div>

</div>

</body>
</html>