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

        // CORREÇÃO: Chama o método que filtra por usuário
        List<Treino> treinosDoUsuario = treinoDao.listarPorUsuario(usuario.getId());
        req.setAttribute("treinos", treinosDoUsuario);
        
        List<Exercicio> todosExercicios = exercicioDao.listarTodos();
        req.setAttribute("todosExercicios", todosExercicios);

        req.getRequestDispatcher("treinos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");
        if ("criar".equals(acao)) {
            HttpSession session = req.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            if (usuario == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            Treino t = new Treino();
            t.setNome(req.getParameter("nome"));
            t.setDescricao(req.getParameter("descricao"));
            t.setNivel(req.getParameter("nivel"));
            // Garante que o treino seja salvo com o ID do usuário logado
            t.setIdUsuario(usuario.getId());

            String[] exerciciosIds = req.getParameterValues("exercicios");

            treinoDao.salvar(t, exerciciosIds);
        }
        
        // Redireciona para o doGet para recarregar a página com os dados atualizados
        resp.sendRedirect("TreinoServlet");
    }
}