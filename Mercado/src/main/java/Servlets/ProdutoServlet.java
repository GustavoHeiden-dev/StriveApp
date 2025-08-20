package Servlets;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelos.Usuario;

import Dao.DaoProdutos;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelos.*;

@WebServlet("/produto")
public class ProdutoServlet extends HttpServlet {
    private DaoProdutos produtoDAO = new DaoProdutos();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acao = request.getParameter("acao");

        try {
            if ("adicionar".equals(acao)) {
                String nome = request.getParameter("nome");
                double preco = Double.parseDouble(request.getParameter("preco"));
                int quantidade = Integer.parseInt(request.getParameter("quantidade"));
                Produto p = new Produto(nome, preco, quantidade);
                produtoDAO.adicionarProduto(p);
            } else if ("remover".equals(acao)) {
                int id = Integer.parseInt(request.getParameter("id"));
                produtoDAO.removerProduto(id);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("CadastroProduto.jsp");
    }
}
