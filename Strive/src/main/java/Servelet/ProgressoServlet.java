package Servelet;

import java.io.IOException;
import java.util.List;
import Dao.ProgressoDAO;
import Modelos.ContagemMensal;
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