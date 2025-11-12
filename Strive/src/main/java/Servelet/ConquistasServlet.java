package Servelet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import Dao.ConquistasDAO;
import Dao.ProgressoDAO;
import Modelos.Conquista;
import Modelos.Progresso;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ConquistasServlet")
public class ConquistasServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id_usuario = usuario.getId();

            ProgressoDAO progressoDAO = new ProgressoDAO();
            ConquistasDAO conquistaDAO = new ConquistasDAO();

            List<Progresso> sessoesConcluidas = progressoDAO.listarSessoesConcluidas(id_usuario);
            int treinosConcluidos = sessoesConcluidas.size();

            List<Conquista> todasAsMetas = conquistaDAO.getTodasConquistas();

            Set<Integer> idConquistasGanhas = conquistaDAO.getConquistasPorUsuario(id_usuario)
                    .stream()
                    .map(Conquista::getId_conquista)
                    .collect(Collectors.toSet());

            List<Conquista> conquistasAtivas = new ArrayList<>();
            List<Conquista> conquistasConcluidas = new ArrayList<>();

            for (Conquista meta : todasAsMetas) {
                if (idConquistasGanhas.contains(meta.getId_conquista())) {
                    meta.setProgresso(100.0);
                    meta.setConcluido(true);
                    conquistasConcluidas.add(meta);
                } else {
                    double progresso = Math.min(100.0, ((double) treinosConcluidos / meta.getMeta_treinos()) * 100);
                    meta.setProgresso(progresso);
                    meta.setConcluido(false);
                    conquistasAtivas.add(meta);
                }
            }
            
            request.setAttribute("conquistasAtivas", conquistasAtivas);
            request.setAttribute("conquistasConcluidas", conquistasConcluidas);

            request.getRequestDispatcher("conquistas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
    
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}