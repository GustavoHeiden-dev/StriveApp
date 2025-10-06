package Servelet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.ExercicioDAO;
import Dao.TreinoDAO;
import Dao.TreinoSessaoDAO;
import Modelos.Exercicio;
import Modelos.Treino;
import Modelos.Usuario;

@WebServlet("/TreinoDetalheServlet")
public class TreinoDetalheServlet extends HttpServlet {
    private TreinoDAO treinoDao = new TreinoDAO();
    private TreinoSessaoDAO treinoSessaoDao = new TreinoSessaoDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idTreinoStr = request.getParameter("idTreino");
        if (idTreinoStr == null) {
            response.sendRedirect("TreinoServlet");
            return;
        }
        
        try {
            int idTreino = Integer.parseInt(idTreinoStr);

            Treino treino = treinoDao.buscarPorId(idTreino);
            
            if (treino != null) {
                int idSessao = treinoSessaoDao.iniciarSessao(usuario.getId(), idTreino);

                request.setAttribute("exercicios", treino.getExercicios());
                request.setAttribute("idTreino", treino.getId());
                request.setAttribute("idSessao", idSessao);
                
                request.getRequestDispatcher("treinoDetalhe.jsp").forward(request, response);
            } else {
                response.sendRedirect("TreinoServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("TreinoServlet");
        }
    }
}