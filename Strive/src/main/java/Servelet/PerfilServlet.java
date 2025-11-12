package Servelet;

import java.io.IOException;
import java.util.List;

import Dao.UsuarioDAO;
import Dao.ConquistasDAO;
import Modelos.Usuario;
import Modelos.Conquista;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {

    @Override
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
            ConquistasDAO conquistaDAO = new ConquistasDAO();
            List<Conquista> listaEmblemas = conquistaDAO.getConquistasPorUsuario(id_usuario);

            request.setAttribute("listaEmblemas", listaEmblemas);
            request.getRequestDispatcher("editarperfil.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario != null) {
            
            String novoNome = request.getParameter("nome");
            String novoEmail = request.getParameter("email");
            String novaSenha = request.getParameter("senha"); 
            
            int novaIdade = Integer.parseInt(request.getParameter("idade"));
            float novoPesoInicial = Float.parseFloat(request.getParameter("pesoInicial"));
            float novaAltura = Float.parseFloat(request.getParameter("altura"));
            String novoNivelInicial = request.getParameter("nivelInicial");

            
            usuario.setNome(novoNome);
            usuario.setEmail(novoEmail);
            usuario.setIdade(novaIdade);
            usuario.setPesoInicial(novoPesoInicial);
            usuario.setAltura(novaAltura);
            usuario.setNivelInicial(novoNivelInicial);
            
            if (novaSenha != null && !novaSenha.trim().isEmpty()) {
                usuario.setSenha(novaSenha);
            } 

            UsuarioDAO usuarioDAO = new UsuarioDAO();
            usuarioDAO.editar(usuario);

            session.setAttribute("usuario", usuario);
            
            response.sendRedirect("PerfilServlet?success=true");
        } else {
            response.sendRedirect("login.jsp"); 
        }
    }
}