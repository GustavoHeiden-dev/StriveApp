package Servlets;

import Dao.DaoProdutos;
import modelos.Produto;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelos.Usuario;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/compra")
public class CompraServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        ArrayList<Produto> carrinho = (ArrayList<Produto>) session.getAttribute("carrinho");
        if (carrinho == null) {
            carrinho = new ArrayList<>();
            session.setAttribute("carrinho", carrinho);
        }

        String acao = request.getParameter("acao");
        DaoProdutos dao = new DaoProdutos();

        if ("adicionar".equals(acao)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Produto p = dao.buscarProdutoPorId(id); // método que busca o produto no banco
            if (p != null) {
                carrinho.add(p);
            }
        } else if ("remover".equals(acao)) {
            int id = Integer.parseInt(request.getParameter("id"));
            carrinho.removeIf(prod -> prod.getId() == id);
        } else if ("notaFiscal".equals(acao)) {
            response.sendRedirect("notaFiscal.jsp");
            return;
        }

        response.sendRedirect("Compra.jsp"); // volta para a página de compra
    }
}
