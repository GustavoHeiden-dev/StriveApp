package Servelet;

import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import Dao.TreinoSessaoDAO;
import Dao.ConquistasDAO;
import Dao.ProgressoDAO;

import Modelos.Usuario;
import Modelos.Conquista;

@WebServlet("/FinalizarTreinoServlet")
public class FinalizarTreinoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int idSessao = Integer.parseInt(request.getParameter("idSessao"));

            TreinoSessaoDAO sessaoDAO = new TreinoSessaoDAO();
            sessaoDAO.finalizarSessao(idSessao);

            int id_usuario = usuario.getId();

            ProgressoDAO progressoDAO = new ProgressoDAO();
            ConquistasDAO conquistaDAO = new ConquistasDAO();

            int totalTreinosConcluidos = progressoDAO.getTotalTreinosConcluidos(id_usuario);
            int totalDiasUnicos = progressoDAO.getTotalDiasUnicosDeTreino(id_usuario);

            List<Conquista> todasAsMetas = conquistaDAO.getTodasConquistas();

            Set<Integer> idConquistasAtuais = conquistaDAO.getConquistasPorUsuario(id_usuario)
                    .stream()
                    .map(Conquista::getId_conquista)
                    .collect(Collectors.toSet());

            boolean novaConquistaGanha = false;

            for (Conquista meta : todasAsMetas) {
                boolean jaPossui = idConquistasAtuais.contains(meta.getId_conquista());

                if (!jaPossui) {
                    boolean metaAtingida = false;
                    String tipoMeta = meta.getTipo_meta();

                    if ("TOTAL_TREINOS".equals(tipoMeta)) {
                        if (totalTreinosConcluidos >= meta.getMeta()) {
                            metaAtingida = true;
                        }
                    } else if ("DIAS_UNICOS".equals(tipoMeta)) {
                        if (totalDiasUnicos >= meta.getMeta()) {
                            metaAtingida = true;
                        }
                    }

                    if (metaAtingida) {
                        conquistaDAO.darConquistaParaUsuario(id_usuario, meta.getId_conquista());
                        novaConquistaGanha = true;
                    }
                }
            }

            if (novaConquistaGanha) {
                session.setAttribute("novaConquista", "true");
            }

            session.setAttribute("treinoFinalizado", "true");
            response.sendRedirect("TreinoServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("TreinoServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}