package Servelet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.TreinoSessaoDAO;

@WebServlet("/FinalizarTreinoServlet")
public class FinalizarTreinoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
            
        try {
            int idSessao = Integer.parseInt(request.getParameter("idSessao"));
            TreinoSessaoDAO dao = new TreinoSessaoDAO();
            dao.finalizarSessao(idSessao);
            
            response.sendRedirect("TreinoServlet");

        } catch (NumberFormatException e) {
            response.sendRedirect("TreinoServlet");
        }
    }
}