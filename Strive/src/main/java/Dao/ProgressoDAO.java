package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import Modelos.ContagemMensal;
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
        List<ProgressoExercicio> recordes = new ArrayList<>();
        // Substitua 'SUA_CONEXAO' pela sua lógica real de conexão com o banco
        String sql = "SELECT E.nome, MAX(UE.peso_usado) " +
                     "FROM UsuarioExercicio UE " +
                     "JOIN Exercicio E ON UE.id_exercicio = E.id_exercicio " +
                     "WHERE UE.id_usuario = ? AND UE.peso_usado IS NOT NULL " +
                     "GROUP BY E.nome " +
                     "ORDER BY MAX(UE.peso_usado) DESC";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String nome = rs.getString("nome"); // Nome do Exercício
                    float peso = rs.getFloat(2); // MAX(UE.peso_usado)

                    recordes.add(new ProgressoExercicio(nome, peso));
                }
            }
        } catch (SQLException e) {
            // Logar o erro
            e.printStackTrace();
        }
        return recordes;
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
    public List<ContagemMensal> listarTreinosPorMes(int idUsuario) {
        List<ContagemMensal> contagens = new ArrayList<>();
        String sql = "SELECT YEAR(data_fim) AS ano, MONTH(data_fim) AS mes, COUNT(id_sessao) AS total_treinos FROM TreinoSessao WHERE id_usuario = ? AND data_fim IS NOT NULL GROUP BY YEAR(data_fim), MONTH(data_fim) ORDER BY ano ASC, mes ASC";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int ano = rs.getInt("ano");
                    int mes = rs.getInt("mes");
                    int totalTreinos = rs.getInt("total_treinos");
                    
                    ContagemMensal contagem = new ContagemMensal(ano, mes, totalTreinos);
                    contagens.add(contagem);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contagens;
    }
}