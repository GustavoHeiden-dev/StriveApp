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

//... (imports)

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

 protected void doPost(HttpServletRequest request, HttpServletResponse response)
     throws ServletException, IOException {

     String email = request.getParameter("email");
     String senha = request.getParameter("password");

     UsuarioDAO usuarioDAO = new UsuarioDAO();

     Usuario usuario = usuarioDAO.autenticar(email, senha);

     if (usuario != null) {
         HttpSession session = request.getSession();
         session.setAttribute("usuario", usuario); // Armazena o objeto do usuário na sessão
         response.sendRedirect("home.jsp");
     } else {
         request.setAttribute("erro", "Email ou senha inválidos");
         request.getRequestDispatcher("home.jsp").forward(request, response);
     }
 }
}