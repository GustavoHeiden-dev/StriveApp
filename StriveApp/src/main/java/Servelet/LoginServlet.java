package Servelet;

import java.io.IOException;

import Dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");
        String senha = request.getParameter("password");

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        if (usuarioDAO.autenticar(email, senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", email); // você pode buscar o nome também, se quiser
            response.sendRedirect("home.jsp"); // redireciona após login
        } else {
            request.setAttribute("erro", "Email ou senha inválidos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
