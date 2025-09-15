package Servelet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.ExercicioDAO;
import Dao.TreinoSessaoDAO;
import Modelos.Exercicio;
import Modelos.Usuario;

@WebServlet("/TreinoDetalheServlet")
public class TreinoDetalheServlet extends HttpServlet {
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
        
        int idTreino = Integer.parseInt(idTreinoStr);

        // 1. Inicia uma nova sessão de treino e pega o ID.
        TreinoSessaoDAO sessaoDao = new TreinoSessaoDAO();
        int idSessao = sessaoDao.iniciarSessao(usuario.getId(), idTreino);

        // 2. Busca os exercícios do treino.
        ExercicioDAO exercicioDao = new ExercicioDAO();
        List<Exercicio> exercicios = exercicioDao.listarPorTreino(idTreino);
        
        // 3. Envia todos os dados necessários para o JSP.
        request.setAttribute("exercicios", exercicios);
        request.setAttribute("idTreino", idTreino);
        request.setAttribute("idSessao", idSessao); // Esta linha é a correção crucial.
        
        request.getRequestDispatcher("treinoDetalhe.jsp").forward(request, response);
    }
}