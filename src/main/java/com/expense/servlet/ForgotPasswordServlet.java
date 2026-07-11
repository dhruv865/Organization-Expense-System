package com.expense.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.expense.db.DBConnection;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String name = request.getParameter("name");
        String newPassword = request.getParameter("newPassword");

        try {
            Connection con = DBConnection.getConnection();

            String checkSql = "SELECT * FROM users WHERE email=? AND name=?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            checkPs.setString(2, name);

            ResultSet rs = checkPs.executeQuery();

            if(rs.next()) {

                String updateSql = "UPDATE users SET password=? WHERE email=?";
                PreparedStatement updatePs = con.prepareStatement(updateSql);
                updatePs.setString(1, newPassword);
                updatePs.setString(2, email);

                updatePs.executeUpdate();

                response.sendRedirect("forgotPassword.jsp?success=1");

            } else {
                response.sendRedirect("forgotPassword.jsp?error=1");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=1");
        }
    }
}