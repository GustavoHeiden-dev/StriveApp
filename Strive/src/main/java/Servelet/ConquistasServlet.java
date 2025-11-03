package Servelet;

import java.io.IOException;
import Dao.TreinoSessaoDAO;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ConquistasServlet")
public class ConquistasServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        TreinoSessaoDAO sessaoDAO = new TreinoSessaoDAO();
        int treinosConcluidos = sessaoDAO.contarSessoesConcluidas(usuario.getId());

        request.setAttribute("treinosConcluidos", treinosConcluidos);

        request.getRequestDispatcher("conquistas.jsp").forward(request, response);
    }
}