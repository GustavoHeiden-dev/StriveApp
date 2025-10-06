package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import Modelos.Progresso;
import Modelos.ProgressoExercicio;
import Utils.ConexaoDB;

public class ProgressoDAO {

    public boolean registrarPeso(int idUsuario, float pesoAtual) {
        String sql = "INSERT INTO Progresso (id_usuario, peso_atual, data_registro) VALUES (?, ?, ?)";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            ps.setFloat(2, pesoAtual);
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Progresso> listarSessoesConcluidas(int idUsuario) {
        List<Progresso> lista = new ArrayList<>();
        String sql = "SELECT ts.id_sessao, t.nome AS nome_treino, ts.data_fim, ts.duracao_minutos " +
                     "FROM TreinoSessao ts " +
                     "JOIN Treino t ON ts.id_treino = t.id_treino " +
                     "WHERE ts.id_usuario = ? AND ts.data_fim IS NOT NULL " + 
                     "ORDER BY ts.data_fim DESC";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Progresso psessao = new Progresso(); 
                    psessao.setIdSessao(rs.getInt("id_sessao"));
                    psessao.setNomeTreino(rs.getString("nome_treino"));
                    psessao.setDataFim(rs.getTimestamp("data_fim").toLocalDateTime()); 
                    psessao.setDuracaoMinutos(rs.getInt("duracao_minutos"));
                    lista.add(psessao);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<ProgressoExercicio> listarProgressoPeso(int idUsuario) {
        List<ProgressoExercicio> lista = new ArrayList<>();
        String sql = "SELECT e.nome, MAX(ue.peso_usado) AS peso_maximo " +
                     "FROM UsuarioExercicio ue " +
                     "JOIN Exercicio e ON ue.id_exercicio = e.id_exercicio " +
                     "WHERE ue.id_usuario = ? AND ue.peso_usado IS NOT NULL " +
                     "GROUP BY e.nome " +
                     "ORDER BY peso_maximo DESC";

        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProgressoExercicio pe = new ProgressoExercicio(
                        rs.getString("nome"),
                        rs.getFloat("peso_maximo")
                    );
                    lista.add(pe);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<Progresso> listarHistoricoPeso(int idUsuario) {
        List<Progresso> historico = new ArrayList<>();
        String sql = "SELECT peso_atual, data_registro FROM Progresso WHERE id_usuario = ? ORDER BY data_registro ASC";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Progresso p = new Progresso(); 
                    p.setPesoAtual(rs.getFloat("peso_atual"));
                    p.setDataRegistro(rs.getTimestamp("data_registro").toLocalDateTime()); 
                    historico.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historico;
    }
}