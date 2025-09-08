package Servelet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.ExercicioDAO;
import Modelos.Exercicio;

@WebServlet("/TreinoDetalheServlet")
public class TreinoDetalheServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String idTreinoStr = request.getParameter("idTreino");
        if (idTreinoStr == null) {
            response.sendRedirect("TreinoServlet"); // Redireciona para a lista de treinos
            return;
        }
        int idTreino = Integer.parseInt(idTreinoStr);
        ExercicioDAO dao = new ExercicioDAO();
        List<Exercicio> exercicios = dao.listarPorTreino(idTreino);
        request.setAttribute("exercicios", exercicios);
        request.setAttribute("idTreino", idTreino);
        
        // --- LINHA ALTERADA AQUI ---
        // Antes: "treino.jsp", Agora: "treinoDetalhe.jsp"
        request.getRequestDispatcher("treinoDetalhe.jsp").forward(request, response);
    }
}