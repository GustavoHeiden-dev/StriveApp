package Servelet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.UsuarioExercicioDao;
import Modelos.Usuario;

@WebServlet("/MarcarExercicioServlet")
public class MarcarExercicioServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // Validação de segurança
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Usuário não autenticado.\"}");
            return;
        }

        try {
            // Pega os dados enviados pelo JavaScript
            int idExercicio = Integer.parseInt(request.getParameter("idExercicio"));
            int idSessao = Integer.parseInt(request.getParameter("idSessao"));
            String repeticoesFeitas = request.getParameter("repeticoesFeitas");
            String pesoUsadoStr = request.getParameter("pesoUsado");
            
            Float pesoUsado = null;
            // Converte o peso para Float, se tiver sido preenchido
            if (pesoUsadoStr != null && !pesoUsadoStr.trim().isEmpty()) {
                pesoUsado = Float.parseFloat(pesoUsadoStr);
            }

            // Usa o DAO para salvar no banco
            UsuarioExercicioDao dao = new UsuarioExercicioDao();
            boolean sucesso = dao.salvar(usuario.getId(), idExercicio, idSessao, repeticoesFeitas, pesoUsado);

            // Envia a resposta em formato JSON para o JavaScript
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (sucesso) {
                response.getWriter().write("{\"status\": \"success\"}");
            } else {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Falha ao salvar no banco de dados.\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Dados inválidos fornecidos.\"}");
        }
    }
}