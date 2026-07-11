package com.expense.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.expense.db.DBConnection;

@WebServlet("/AddExpenseServlet")
@MultipartConfig
public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String category = request.getParameter("category");
        String expenseDate = request.getParameter("expense_date");

        HttpSession session = request.getSession();
        String addedBy = (String) session.getAttribute("name");

        Part filePart = request.getPart("bill_image");
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        filePart.write(uploadPath + File.separator + fileName);

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO expenses(title, amount, category, expense_date, added_by, bill_image, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, title);
            ps.setDouble(2, amount);
            ps.setString(3, category);
            ps.setString(4, expenseDate);
            ps.setString(5, addedBy);
            ps.setString(6, fileName);
            ps.setString(7, "Pending");

            ps.executeUpdate();

            response.sendRedirect("viewExpenses.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addExpense.jsp?error=1");
        }
    }
}
