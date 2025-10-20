package Servelet;

import java.io.IOException;
import Dao.UsuarioDAO;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RedefinirSenhaServlet")
public class RedefinirSenhaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String novaSenha = request.getParameter("novaSenha");
        String confirmarSenha = request.getParameter("confirmarSenha");

        if (!novaSenha.equals(confirmarSenha)) {
            request.setAttribute("errorMessage", "As senhas não coincidem.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("redefinirSenha.jsp").forward(request, response);
            return;
        }

        if (novaSenha.length() < 6) {
            request.setAttribute("errorMessage", "A senha deve ter pelo menos 6 caracteres.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("redefinirSenha.jsp").forward(request, response);
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.buscarPorToken(token);

        if (usuario == null) {
            request.setAttribute("errorMessage", "Token inválido ou expirado. Tente novamente.");
            request.getRequestDispatcher("esqueciSenha.jsp").forward(request, response);
            return;
        }

        try {
            boolean sucesso = usuarioDAO.redefinirSenha(usuario.getId(), novaSenha);

            if (sucesso) {
                request.setAttribute("successMessage", "Senha redefinida com sucesso! Você já pode fazer o login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Erro ao atualizar a senha. Tente novamente.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("redefinirSenha.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erro inesperado.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("redefinirSenha.jsp").forward(request, response);
        }
    }
}