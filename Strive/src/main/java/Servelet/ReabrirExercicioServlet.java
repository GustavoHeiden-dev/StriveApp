package Servelet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.UsuarioExercicioDao;
import Modelos.Usuario;

@WebServlet("/ReabrirExercicioServlet")
public class ReabrirExercicioServlet extends HttpServlet {
    
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
            // Pega os IDs para identificar a conclusão a ser desmarcada
            int idExercicio = Integer.parseInt(request.getParameter("idExercicio"));
            int idSessao = Integer.parseInt(request.getParameter("idSessao"));
            
            UsuarioExercicioDao dao = new UsuarioExercicioDao();
            
            // ⚠️ CHAMA O NOVO MÉTODO NO DAO
            boolean sucesso = dao.reabrir(usuario.getId(), idExercicio, idSessao);

            // Envia a resposta em formato JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (sucesso) {
                response.getWriter().write("{\"status\": \"success\"}");
            } else {
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Falha ao reabrir o exercício no banco de dados.\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Dados inválidos fornecidos.\"}");
        }
    }
}