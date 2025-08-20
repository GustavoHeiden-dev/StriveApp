package Servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelos.Usuario;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String cpf = request.getParameter("cpf");
        boolean admin = "on".equals(request.getParameter("admin"));

        if (nome.isEmpty() || cpf.isEmpty()) {
            request.setAttribute("erro", "Preencha todos os campos!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        Usuario usuario = new Usuario(nome, cpf, admin);
        HttpSession session = request.getSession();
        session.setAttribute("usuario", usuario);

        if (admin) {
            response.sendRedirect("CadastroProduto.jsp");
        } else {
            response.sendRedirect("Compra.jsp");
        }
    }
}
