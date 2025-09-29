package Servelet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import Modelos.Usuario;
import Dao.UsuarioDAO;

@WebServlet("/CadastroServlet")
public class CadastroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");
            int idade = Integer.parseInt(request.getParameter("idade"));
            float pesoInicial = Float.parseFloat(request.getParameter("pesoInicial"));
            float altura = Float.parseFloat(request.getParameter("altura"));
            String nivelInicial = request.getParameter("nivelInicial");

            Usuario usuario = new Usuario();
            usuario.setNome(nome);
            usuario.setEmail(email);
            usuario.setSenha(senha);
            usuario.setIdade(idade);
            usuario.setPesoInicial(pesoInicial);
            usuario.setAltura(altura);
            usuario.setNivelInicial(nivelInicial);

            UsuarioDAO usuarioDAO = new UsuarioDAO();
            usuarioDAO.cadastrar(usuario);

            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage()); 
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}