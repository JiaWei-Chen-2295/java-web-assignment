package fun.javierchen.ch16customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/customer")
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String studentId = req.getParameter("studentId");
        String name = req.getParameter("name");
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String address = req.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "请输入姓名");
            req.getRequestDispatcher("inputCustomer.jsp").forward(req, resp);
            return;
        }

        Customer customer = new Customer(
                studentId, name, gender, phone, email, address
        );

        req.setAttribute("customer", customer);
        req.getRequestDispatcher("displayCustomer.jsp").forward(req, resp);
    }
}
