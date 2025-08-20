package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import modelos.Produto;
import utils.Conecxao;

public class DaoProdutos{

    public void adicionarProduto(Produto p) throws SQLException {
        String sql = "INSERT INTO produto (nome, preco, quantidade) VALUES (?, ?, ?)";
        try (Connection conn = Conecxao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getNome());
            stmt.setDouble(2, p.getPreco());
            stmt.setInt(3, p.getQuantidade());
            stmt.executeUpdate();
        }
    }

    public List<Produto> listarProdutos() throws SQLException {
        List<Produto> produtos = new ArrayList<>();
        String sql = "SELECT * FROM produto";
        try (Connection conn = Conecxao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Produto p = new Produto(
                    rs.getInt("id"),
                    rs.getString("nome"),
                    rs.getDouble("preco"),
                    rs.getInt("quantidade")
                );
                produtos.add(p);
            }
        }
        return produtos;
    }

    public void removerProduto(int id) throws SQLException {
        String sql = "DELETE FROM produto WHERE id = ?";
        try (Connection conn = Conecxao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
    
    public Produto buscarProdutoPorId(int id) {
        Produto produto = null;
        String sql = "SELECT * FROM produto WHERE id = ?";

        try (Connection conn = Conecxao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    produto = new Produto();
                    produto.setId(rs.getInt("id"));
                    produto.setNome(rs.getString("nome"));
                    produto.setPreco(rs.getDouble("preco"));
                    produto.setQuantidade(rs.getInt("quantidade"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return produto;
    }
}
