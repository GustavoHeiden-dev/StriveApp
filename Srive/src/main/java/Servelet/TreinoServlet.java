package Servelet;

import java.io.IOException;
import java.util.List;
import Dao.ExercicioDAO; // Importar ExercicioDAO
import Dao.TreinoDAO;
import Modelos.Exercicio; // Importar Exercicio
import Modelos.Treino;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/TreinoServlet")
public class TreinoServlet extends HttpServlet {
    private TreinoDAO treinoDao = new TreinoDAO();
    private ExercicioDAO exercicioDao = new ExercicioDAO(); // Instanciar ExercicioDAO

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Treino> treinos = treinoDao.listarTodos();
        req.setAttribute("treinos", treinos);
        
        // Busca a lista de TODOS os exercícios para popular o formulário
        List<Exercicio> todosExercicios = exercicioDao.listarTodos();
        req.setAttribute("todosExercicios", todosExercicios);

        // Renomeie seu arquivo para "treinos.jsp"
        req.getRequestDispatcher("treinos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");
        if ("criar".equals(acao)) {
            Usuario usuario = (Usuario) req.getSession().getAttribute("usuario");

            Treino t = new Treino();
            t.setNome(req.getParameter("nome"));
            t.setDescricao(req.getParameter("descricao"));
            t.setNivel(req.getParameter("nivel"));
            if(usuario != null) {
                t.setIdUsuario(usuario.getId());
            }

            // Pega a lista de IDs dos exercícios selecionados no formulário
            String[] exerciciosIds = req.getParameterValues("exercicios");

            treinoDao.salvar(t, exerciciosIds);
        }
        resp.sendRedirect("TreinoServlet");
    }
}