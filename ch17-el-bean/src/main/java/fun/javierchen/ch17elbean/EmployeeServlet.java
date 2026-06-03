package fun.javierchen.ch17elbean;

import fun.javierchen.ch17elbean.model.Address;
import fun.javierchen.ch17elbean.model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/employee")
public class EmployeeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Address address = new Address("湖南省", "长沙市", "岳麓区麓山南路1号");
        Employee employee = new Employee("2024001", "陈佳伟", address);

        req.setAttribute("employee", employee);
        req.getRequestDispatcher("Java-Bean.jsp").forward(req, resp);
    }
}
