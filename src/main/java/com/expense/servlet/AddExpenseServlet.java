package com.expense.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.expense.db.DBConnection;

@WebServlet("/AddExpenseServlet")
public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String category = request.getParameter("category");
        String expenseDate = request.getParameter("expense_date");

        HttpSession session = request.getSession();
        String addedBy = (String) session.getAttribute("name");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO expenses(title, amount, category, expense_date, added_by) VALUES (?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setDouble(2, amount);
            ps.setString(3, category);
            ps.setString(4, expenseDate);
            ps.setString(5, addedBy);

            ps.executeUpdate();

            response.sendRedirect("addExpense.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addExpense.jsp?error=1");
        }
    }
}
