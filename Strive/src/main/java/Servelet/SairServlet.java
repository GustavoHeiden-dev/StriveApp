package Servelet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SairServlet")
public class SairServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // 1. Obtém a sessão atual. 'false' impede que uma nova sessão seja criada se não houver uma.
        HttpSession session = request.getSession(false); 

        if (session != null) {
            // 2. Invalida a sessão, deslogando o usuário.
            session.invalidate();
        }

        // 3. Redireciona o usuário para a página padrão.
        response.sendRedirect("HomePadrao.jsp"); 
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        // Redireciona para o doGet, caso o link seja acessado via POST (ex: de um formulário)
        doGet(request, response);
    }
}