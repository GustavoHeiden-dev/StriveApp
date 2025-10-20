package Servelet;

import java.io.IOException;
import java.util.UUID;
import Dao.UsuarioDAO;
import Modelos.Usuario;
import Utils.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EsqueciSenhaServlet")
public class EsqueciSenhaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.buscarPorEmail(email);

        if (usuario == null) {
            request.setAttribute("errorMessage", "Nenhuma conta encontrada com este e-mail.");
            request.getRequestDispatcher("esqueciSenha.jsp").forward(request, response);
            return;
        }

        try {
            String token = UUID.randomUUID().toString();
            boolean tokenSalvo = usuarioDAO.salvarToken(usuario.getId(), token);

            if (tokenSalvo) {
                EmailService emailService = new EmailService();
                boolean emailEnviado = emailService.enviarEmailRedefinicao(email, token);

                if (emailEnviado) {
                    request.setAttribute("successMessage", "Perfeito! Um link de redefinição foi enviado para o seu e-mail.");
                } else {
                    request.setAttribute("errorMessage", "Erro ao enviar o e-mail. Tente novamente mais tarde.");
                }
            } else {
                request.setAttribute("errorMessage", "Erro ao processar sua solicitação. Tente novamente.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Ocorreu um erro inesperado.");
        }
        
        request.getRequestDispatcher("esqueciSenha.jsp").forward(request, response);
    }
}