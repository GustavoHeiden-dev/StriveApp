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
            
            // É importante garantir que a conversão ocorra antes de usar os valores
            int novaIdade = Integer.parseInt(request.getParameter("idade"));
            float novoPesoInicial = Float.parseFloat(request.getParameter("pesoInicial"));
            float novaAltura = Float.parseFloat(request.getParameter("altura"));
            String novoNivelInicial = request.getParameter("nivelInicial");

            
            // 1. Atualiza os campos que não são a senha (eles mantêm a senha antiga do objeto 'usuario')
            usuario.setNome(novoNome);
            usuario.setEmail(novoEmail);
            usuario.setIdade(novaIdade);
            usuario.setPesoInicial(novoPesoInicial);
            usuario.setAltura(novaAltura);
            usuario.setNivelInicial(novoNivelInicial);
            
            // 2. Atualiza a senha SOMENTE se o parâmetro 'novaSenha' não for  nem vazio.
            if (novaSenha != null && !novaSenha.trim().isEmpty()) {
                usuario.setSenha(novaSenha);
            } 
            // Se 'novaSenha' estiver vazia, a senha atual do objeto 'usuario' (que veio da sessão) é mantida.

            // 3. Salva todas as alterações no banco de dados
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            usuarioDAO.editar(usuario);

            // 4. Atualiza o objeto na sessão para que os novos dados sejam refletidos imediatamente
            session.setAttribute("usuario", usuario);
            
            // 5. Redireciona com mensagem de sucesso
            response.sendRedirect("editarperfil.jsp?success=true");
        } else {
            // Se não houver usuário na sessão, redireciona para o login
            response.sendRedirect("login.jsp"); 
        }
    }
}