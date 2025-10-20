package Servelet;

import java.io.IOException;
import Dao.SerieDAO;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RemoverSerieServlet")
public class RemoverSerieServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // 1. Verificar Autenticação
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String jsonResponse;

        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse = "{\"status\": \"error\", \"message\": \"Usuário não está logado.\"}";
            response.getWriter().write(jsonResponse);
            return;
        }

        try {
            // 2. Obter o ID da Série
            String idSerieStr = request.getParameter("idSerie");
            
            if (idSerieStr == null || idSerieStr.trim().isEmpty()) {
                jsonResponse = "{\"status\":\"error\",\"message\":\"ID da série ausente.\"}";
                response.getWriter().write(jsonResponse);
                return;
            }

            int idSerie = Integer.parseInt(idSerieStr.trim());
            
            // 3. Chamar o DAO para remover
            SerieDAO serieDAO = new SerieDAO();
            boolean sucesso = serieDAO.removerPorId(idSerie); 

            // 4. Retornar resposta JSON
            jsonResponse = sucesso
                    ? "{\"status\": \"success\", \"message\": \"Série removida com sucesso!\"}"
                    : "{\"status\": \"error\", \"message\": \"Erro ao remover a série no banco de dados.\"}";

        } catch (NumberFormatException e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"ID da série inválido.\"}";
            e.printStackTrace();
        } catch (Exception e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Ocorreu um erro inesperado ao remover a série.\"}";
            e.printStackTrace();
        }

        response.getWriter().write(jsonResponse);
    }
    
    // Não precisa de doGet, já que a remoção é feita via POST/AJAX
}