package Servelet;

import java.io.IOException;

import Dao.UsuarioDAO;
import Modelos.Usuario; 
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
        try {
            String email = request.getParameter("email");
            String senha = request.getParameter("password");

            UsuarioDAO usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.autenticar(email, senha);

            if (usuario != null) {
                // Login bem-sucedido
                HttpSession session = request.getSession();
                session.setAttribute("usuario", usuario); 
                response.sendRedirect("home.jsp");
            } else {
                // Login falhou → usuário/senha incorretos
                request.setAttribute("errorMessage", "Email ou senha inválidos!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Ocorreu um erro ao tentar logar: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
