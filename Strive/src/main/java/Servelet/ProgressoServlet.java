package Servelet;

import java.io.IOException;
import java.util.List;
import Dao.ProgressoDAO;
import Modelos.ContagemMensal;
import Modelos.DetalheExercicioSerie; // NOVO
import Modelos.Progresso;
import Modelos.ProgressoExercicio;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProgressoServlet")
public class ProgressoServlet extends HttpServlet {
    private ProgressoDAO progressoDao = new ProgressoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int idUsuario = usuario.getId();
        String action = request.getParameter("action"); // NOVO: Captura o parâmetro de ação

        // === NOVO: Lógica para carregar detalhes de um treino (via AJAX/modal) ===
        if ("detalhes".equals(action)) {
            try {
                int idSessao = Integer.parseInt(request.getParameter("idSessao"));
                
                // Busca as informações básicas da sessão
                Progresso sessaoDetalhada = progressoDao.buscarSessaoPorId(idSessao); 
                // Busca a lista de exercícios e séries detalhadas
                List<DetalheExercicioSerie> detalhesExercicios = progressoDao.listarDetalhesSessao(idSessao); 

                request.setAttribute("sessaoDetalhada", sessaoDetalhada);
                request.setAttribute("detalhesExercicios", detalhesExercicios);
                
                // Encaminha para o fragmento JSP que irá renderizar o corpo do modal
                request.getRequestDispatcher("treinoDetalhesFragment.jsp").forward(request, response);
                return;
                
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("ID de sessão inválido.");
                return;
            } catch (Exception e) {
                 e.printStackTrace();
                 response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                 response.getWriter().write("<p style='color: red;'>Erro interno ao buscar detalhes da sessão.</p>");
                 return;
            }
        }
        // =========================================================================

        // Lógica existente para a página principal de progresso
        List<Progresso> sessoesConcluidas = progressoDao.listarSessoesConcluidas(idUsuario);
        List<ProgressoExercicio> progressoPeso = progressoDao.listarProgressoPeso(idUsuario);
        List<Progresso> historicoPeso = progressoDao.listarHistoricoPeso(idUsuario);
        
        List<ContagemMensal> treinosPorMes = progressoDao.listarTreinosPorMes(idUsuario); 
        
        request.setAttribute("sessoesConcluidas", sessoesConcluidas);
        request.setAttribute("progressoPeso", progressoPeso);
        request.setAttribute("historicoPeso", historicoPeso);
        request.setAttribute("treinosPorMes", treinosPorMes); 

        request.getRequestDispatcher("progresso.jsp").forward(request, response);
    }
}