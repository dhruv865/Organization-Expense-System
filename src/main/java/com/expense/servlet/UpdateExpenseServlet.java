package com.expense.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.expense.db.DBConnection;

@WebServlet("/UpdateExpenseServlet")
public class UpdateExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String category = request.getParameter("category");
        String expenseDate = request.getParameter("expense_date");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE expenses SET title=?, amount=?, category=?, expense_date=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setDouble(2, amount);
            ps.setString(3, category);
            ps.setString(4, expenseDate);
            ps.setInt(5, id);

            ps.executeUpdate();

            response.sendRedirect("viewExpenses.jsp");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
