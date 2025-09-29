 package Servelet;

import java.io.IOException;

import Dao.UsuarioDAO;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {

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
            usuario.setSenha(novaSenha); 
            usuario.setIdade(novaIdade);
            usuario.setPesoInicial(novoPesoInicial);
            usuario.setAltura(novaAltura);
            usuario.setNivelInicial(novoNivelInicial);

            UsuarioDAO usuarioDAO = new UsuarioDAO();
            usuarioDAO.editar(usuario);

       
            session.setAttribute("usuario", usuario);
            
       
            response.sendRedirect("editarperfil.jsp?success=true");
        } else {
            response.sendRedirect("login.jsp"); 
        }
    }
}