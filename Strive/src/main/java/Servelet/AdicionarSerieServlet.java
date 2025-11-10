package Servelet;

import java.io.IOException;
import java.io.PrintWriter; // Importação necessária para o try-with-resources
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        String jsonResponse = ""; // Inicialização defensiva

        // O try-with-resources garante que o PrintWriter seja fechado/flush automaticamente
        try (PrintWriter out = response.getWriter()) { 

            // 1. VERIFICAÇÃO DE LOGIN
            if (usuario == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // Código 401
                jsonResponse = "{\"status\": \"error\", \"message\": \"Usuário não está logado.\"}";
                out.write(jsonResponse);
                return; // Interrompe o fluxo
            }

            String idExercicioStr = request.getParameter("idExercicio");
            String idSessaoStr = request.getParameter("idSessao");
            String repeticoesStr = request.getParameter("repeticoes");
            String pesoStr = request.getParameter("peso");

            // 2. VERIFICAÇÃO DE PARÂMETROS NULOS/VAZIOS
            if (idExercicioStr == null || idExercicioStr.trim().isEmpty() ||
                idSessaoStr == null || idSessaoStr.trim().isEmpty() ||
                repeticoesStr == null || repeticoesStr.trim().isEmpty() ||
                pesoStr == null || pesoStr.trim().isEmpty()) {

                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Código 400
                jsonResponse = "{\"status\":\"error\",\"message\":\"Parâmetros incompletos.\"}";
                out.write(jsonResponse);
                return;
            }

            // 3. PARSING E VALIDAÇÃO DE DADOS
            int idExercicio = Integer.parseInt(idExercicioStr.trim());
            int idSessao = Integer.parseInt(idSessaoStr.trim());
            int repeticoes = Integer.parseInt(repeticoesStr.trim());
            // Uso do replace para tratar vírgulas como ponto (Formato Brasileiro vs. Americano)
            float peso = Float.parseFloat(pesoStr.trim().replace(',', '.'));

            if (repeticoes <= 0 || repeticoes > 500) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse = "{\"status\": \"error\", \"message\": \"Número de repetições inválido.\"}";
                out.write(jsonResponse);
                return;
            }

            if (peso < 0 || peso > 1000) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse = "{\"status\": \"error\", \"message\": \"Valor de peso inválido.\"}";
                out.write(jsonResponse);
                return;
            }

            // 4. LÓGICA DE NEGÓCIO E DAO
            UsuarioExercicioDao usuarioExercicioDAO = new UsuarioExercicioDao();
            int idUsuarioExercicio = usuarioExercicioDAO.obterOuCriar(usuario.getId(), idExercicio, idSessao);

            if (idUsuarioExercicio > 0) {
                Serie novaSerie = new Serie();
                novaSerie.setIdUsuarioExercicio(idUsuarioExercicio);
                novaSerie.setRepeticoes(repeticoes);
                novaSerie.setPeso(peso);

                SerieDAO serieDAO = new SerieDAO();
                int idSerieGerado = serieDAO.salvarRetornandoId(novaSerie);

                if (idSerieGerado > 0) {
                    // SUCESSO: Retorna o ID
                    response.setStatus(HttpServletResponse.SC_OK); // Código 200
                    jsonResponse = "{\"status\": \"success\", \"message\": \"Série adicionada com sucesso!\", \"idSerie\": " + idSerieGerado + "}";
                } else {
                    // ERRO NO DAO (falha silenciosa no salvar)
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Código 500
                    jsonResponse = "{\"status\": \"error\", \"message\": \"Erro ao salvar a série no banco de dados.\"}";
                }
            } else {
                // ERRO NO obterOuCriar
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse = "{\"status\": \"error\", \"message\": \"Não foi possível criar o registro do exercício.\"}";
            }
            
            // 5. ESCREVE A RESPOSTA FINAL DE SUCESSO/FALHA NO DAO
            out.write(jsonResponse);

        } catch (NumberFormatException e) {
            // ERRO DE CONVERSÃO DE TEXTO PARA NÚMERO
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse = "{\"status\": \"error\", \"message\": \"Dados inválidos. Repetições e Peso devem ser números válidos.\"}";
            response.getWriter().write(jsonResponse); 
            e.printStackTrace();
        } catch (Exception e) {
            // ERRO GERAL (ex: SQL Exception do DAO)
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse = "{\"status\": \"error\", \"message\": \"Ocorreu um erro inesperado. Verifique a conexão com o banco de dados.\"}";
            // O try-with-resources fechou o Writer, então precisamos pegá-lo novamente no catch.
            response.getWriter().write(jsonResponse); 
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Redireciona o GET para o POST, mas o código acima já garante o retorno JSON.
        doPost(req, resp);
    }
}