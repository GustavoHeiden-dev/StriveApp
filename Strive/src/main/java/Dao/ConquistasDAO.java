package Dao;

import Modelos.Conquista;
import Utils.ConexaoDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ConquistasDAO {

    public List<Conquista> getConquistasPorUsuario(int id_usuario) {
        List<Conquista> emblemas = new ArrayList<>();
        String sql = "SELECT c.*, uc.data_conclusao FROM Conquista c " +
                     "JOIN UsuarioConquista uc ON c.id_conquista = uc.id_conquista " +
                     "WHERE uc.id_usuario = ? " +
                     "ORDER BY uc.data_conclusao DESC";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id_usuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Conquista c = new Conquista();
                    c.setId_conquista(rs.getInt("id_conquista"));
                    c.setNome(rs.getString("nome"));
                    c.setDescricao(rs.getString("descricao"));
                    c.setIcone(rs.getString("icone"));
                    c.setMeta(rs.getInt("meta"));
                    c.setTipo_meta(rs.getString("tipo_meta"));
                    c.setData_conclusao(rs.getTimestamp("data_conclusao"));
                    emblemas.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emblemas;
    }

    public List<Conquista> getTodasConquistas() {
        List<Conquista> conquistas = new ArrayList<>();
        String sql = "SELECT * FROM Conquista ORDER BY meta ASC";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Conquista c = new Conquista();
                c.setId_conquista(rs.getInt("id_conquista"));
                c.setNome(rs.getString("nome"));
                c.setDescricao(rs.getString("descricao"));
                c.setIcone(rs.getString("icone"));
                c.setMeta(rs.getInt("meta"));
                c.setTipo_meta(rs.getString("tipo_meta"));
                conquistas.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conquistas;
    }

    public void darConquistaParaUsuario(int id_usuario, int id_conquista) {
        String sql = "INSERT IGNORE INTO UsuarioConquista (id_usuario, id_conquista) VALUES (?, ?)";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id_usuario);
            ps.setInt(2, id_conquista);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}