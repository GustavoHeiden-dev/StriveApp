package Servelet;

import java.io.IOException;

import Dao.UsuarioExercicioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/MarcarExercicioServlet")
public class MarcarExercicioServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        Modelos.Usuario user = (Modelos.Usuario) session.getAttribute("usuario");
        int idUsuario = user.getId();
        int idExercicio = Integer.parseInt(request.getParameter("idExercicio"));
        String repeticoesFeitas = request.getParameter("repeticoesFeitas");
        String pesoStr = request.getParameter("pesoUsado");
        Float pesoUsado = null;
        if (pesoStr != null && !pesoStr.trim().isEmpty()) {
            try { pesoUsado = Float.parseFloat(pesoStr); } catch (NumberFormatException ex) { pesoUsado = null; }
        }
        UsuarioExercicioDao dao = new UsuarioExercicioDao();
        dao.marcarConcluido(idUsuario, idExercicio, repeticoesFeitas, pesoUsado);

        // volta para a página do treino
        String idTreino = request.getParameter("idTreino");
        response.sendRedirect("TreinoDetalheServlet?idTreino=" + idTreino);
    }
}
