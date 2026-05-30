package com.expense.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.expense.db.DBConnection;

@WebServlet("/ExportCSVServlet")
public class ExportCSVServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=expenses_report.csv");

        PrintWriter out = response.getWriter();

        out.println("ID,Title,Amount,Category,Date,Added By");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement("SELECT * FROM expenses");
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                out.println(
                    rs.getInt("id") + "," +
                    rs.getString("title") + "," +
                    rs.getDouble("amount") + "," +
                    rs.getString("category") + "," +
                    rs.getString("expense_date") + "," +
                    rs.getString("added_by")
                );
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        out.flush();
        out.close();
    }
}
