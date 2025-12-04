package Servelet;

import java.io.IOException;
import java.util.List;
import Dao.ExercicioDAO;
import Dao.TreinoDAO;
import Modelos.Exercicio;
import Modelos.Treino;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/TreinoServlet")
public class TreinoServlet extends HttpServlet {
    private TreinoDAO treinoDao = new TreinoDAO();
    private ExercicioDAO exercicioDao = new ExercicioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
       
        List<Treino> treinosDoUsuario = treinoDao.listarPorUsuario(usuario.getId());
        req.setAttribute("treinos", treinosDoUsuario);
        
        List<Exercicio> todosExercicios = exercicioDao.listarTodos();
        req.setAttribute("todosExercicios", todosExercicios);

        req.getRequestDispatcher("treinos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String acao = req.getParameter("acao");
        String nomeTreino = req.getParameter("nome");
        String[] exerciciosIds = req.getParameterValues("exercicios");

        if ("criar".equals(acao)) {
            Treino t = new Treino();
            t.setNome(nomeTreino);
            t.setIdUsuario(usuario.getId());
            treinoDao.salvar(t, exerciciosIds);

        } else if ("atualizar".equals(acao)) {
            int idTreino = Integer.parseInt(req.getParameter("idTreino"));
            treinoDao.atualizar(idTreino, nomeTreino, exerciciosIds);
            
        } else if ("deletar".equals(acao)) {
            // Lógica de exclusão
            String idTreinoStr = req.getParameter("idTreino");
            if (idTreinoStr != null && !idTreinoStr.isEmpty()) {
                int idTreino = Integer.parseInt(idTreinoStr);
                treinoDao.deletar(idTreino);
            }
        }
        
        resp.sendRedirect("TreinoServlet");
    }
}