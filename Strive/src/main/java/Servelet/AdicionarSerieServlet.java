package Servelet;

import java.io.IOException;
import Dao.SerieDAO;
import Modelos.Serie;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdicionarSerieServlet")
public class AdicionarSerieServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String jsonResponse;
        
        try {
            int idUsuarioExercicio = Integer.parseInt(request.getParameter("idUsuarioExercicio"));
            int repeticoes = Integer.parseInt(request.getParameter("repeticoes"));
            float peso = Float.parseFloat(request.getParameter("peso"));

            if (repeticoes <= 0 || repeticoes > 500) {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Número de repetições inválido.\"}";
                response.getWriter().write(jsonResponse);
                return;
            }

            if (peso < 0 || peso > 1000) {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Valor de peso inválido.\"}";
                response.getWriter().write(jsonResponse);
                return;
            }

            Serie novaSerie = new Serie();
            novaSerie.setIdUsuarioExercicio(idUsuarioExercicio);
            novaSerie.setRepeticoes(repeticoes);
            novaSerie.setPeso(peso);

            SerieDAO serieDAO = new SerieDAO();
            boolean sucesso = serieDAO.salvar(novaSerie);

            if (sucesso) {
                jsonResponse = "{\"status\": \"success\", \"message\": \"Série adicionada com sucesso!\"}";
            } else {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Erro ao salvar a série no banco de dados.\"}";
            }

        } catch (NumberFormatException e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Dados inválidos. Verifique os números digitados.\"}";
            e.printStackTrace();
        } catch (Exception e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Ocorreu um erro inesperado.\"}";
            e.printStackTrace();
        }

        response.getWriter().write(jsonResponse);
    }
}