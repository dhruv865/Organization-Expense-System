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

@WebServlet("/ApprovalServlet")
public class ApprovalServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        try {
            Connection con = DBConnection.getConnection();

            String status = "";

            if(role.equals("Manager")) {
                if(action.equals("approve")) {
                    status = "Approved by Manager";
                } else {
                    status = "Declined by Manager";
                }
            }

            if(role.equals("Admin")) {
                if(action.equals("approve")) {
                    status = "Approved by Admin";
                } else {
                    status = "Declined by Admin";
                }
            }

            PreparedStatement ps = con.prepareStatement(
                "UPDATE expenses SET status=? WHERE id=?"
            );

            ps.setString(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

            response.sendRedirect("viewExpenses.jsp");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}