package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import Utils.ConexaoDB;

public class TreinoSessaoDAO {

    public int iniciarSessao(int idUsuario, int idTreino) {
        String sql = "INSERT INTO TreinoSessao (id_usuario, id_treino, data_inicio) VALUES (?, ?, ?)";
        int idSessaoGerado = 0;
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idTreino);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    idSessaoGerado = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return idSessaoGerado;
    }

    public void finalizarSessao(int idSessao) {
        String sql = "UPDATE TreinoSessao SET data_fim = ?, duracao_minutos = TIMESTAMPDIFF(MINUTE, data_inicio, ?) WHERE id_sessao = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            LocalDateTime agora = LocalDateTime.now();
            ps.setTimestamp(1, Timestamp.valueOf(agora));
            ps.setTimestamp(2, Timestamp.valueOf(agora));
            ps.setInt(3, idSessao);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int contarSessoesConcluidas(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM TreinoSessao WHERE id_usuario = ? AND data_fim IS NOT NULL";
        int total = 0;
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}