package Servelet;

import java.io.IOException;
import Dao.SerieDAO;
import Dao.UsuarioExercicioDao;
import Modelos.Serie;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdicionarSerieServlet")
public class AdicionarSerieServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
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
            String idExercicioStr = request.getParameter("idExercicio");
            String idSessaoStr = request.getParameter("idSessao");
            String repeticoesStr = request.getParameter("repeticoes");
            String pesoStr = request.getParameter("peso");

            if (idExercicioStr == null || idExercicioStr.trim().isEmpty() ||
                idSessaoStr == null || idSessaoStr.trim().isEmpty() ||
                repeticoesStr == null || repeticoesStr.trim().isEmpty() ||
                pesoStr == null || pesoStr.trim().isEmpty()) {

                jsonResponse = "{\"status\":\"error\",\"message\":\"Parâmetros incompletos.\"}";
                response.getWriter().write(jsonResponse);
                return;
            }

            int idExercicio = Integer.parseInt(idExercicioStr.trim());
            int idSessao = Integer.parseInt(idSessaoStr.trim());
            int repeticoes = Integer.parseInt(repeticoesStr.trim());
            // Uso de replace para garantir que vírgulas sejam tratadas como pontos em Java (se necessário)
            float peso = Float.parseFloat(pesoStr.trim().replace(',', '.'));

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

            UsuarioExercicioDao usuarioExercicioDAO = new UsuarioExercicioDao();
            int idUsuarioExercicio = usuarioExercicioDAO.obterOuCriar(usuario.getId(), idExercicio, idSessao);

            if (idUsuarioExercicio > 0) {
                Serie novaSerie = new Serie();
                novaSerie.setIdUsuarioExercicio(idUsuarioExercicio);
                novaSerie.setRepeticoes(repeticoes);
                novaSerie.setPeso(peso);

                SerieDAO serieDAO = new SerieDAO();
                
                // MUDANÇA PRINCIPAL: Captura o ID da série. 
                // É CRUCIAL que serieDAO.salvar() retorne o ID da série inserida.
                int idSerieGerado = serieDAO.salvarRetornandoId(novaSerie); // Assumindo novo método ou ajuste no salvar()

                if (idSerieGerado > 0) {
                    // RETORNA O ID da série no JSON
                    jsonResponse = "{\"status\": \"success\", \"message\": \"Série adicionada com sucesso!\", \"idSerie\": " + idSerieGerado + "}";
                } else {
                    jsonResponse = "{\"status\": \"error\", \"message\": \"Erro ao salvar a série no banco de dados.\"}";
                }
            } else {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Não foi possível criar o registro do exercício.\"}";
            }

        } catch (NumberFormatException e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Dados inválidos. Verifique os números digitados (e use ponto em vez de vírgula para o peso, se o erro persistir).\"}";
            e.printStackTrace();
        } catch (Exception e) {
            jsonResponse = "{\"status\": \"error\", \"message\": \"Ocorreu um erro inesperado: " + e.getMessage().replace("\"", "'") + "\"}";
            e.printStackTrace();
        }

        response.getWriter().write(jsonResponse);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}