package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import Modelos.ContagemMensal;
import Modelos.DetalheExercicioSerie; // NOVO: Importa o novo modelo
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
    
    // NOVO MÉTODO 1: Busca os dados básicos de uma sessão pelo ID
    public Progresso buscarSessaoPorId(int idSessao) {
        String sql = "SELECT ts.id_sessao, t.nome AS nome_treino, ts.data_fim, ts.duracao_minutos " +
                     "FROM TreinoSessao ts " +
                     "JOIN Treino t ON ts.id_treino = t.id_treino " +
                     "WHERE ts.id_sessao = ?";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idSessao);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Progresso psessao = new Progresso(); 
                    psessao.setIdSessao(rs.getInt("id_sessao"));
                    psessao.setNomeTreino(rs.getString("nome_treino"));
                    psessao.setDataFim(rs.getTimestamp("data_fim").toLocalDateTime()); 
                    psessao.setDuracaoMinutos(rs.getInt("duracao_minutos"));
                    return psessao;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // NOVO MÉTODO 2: Lista todos os exercícios, repetições e pesos de todas as séries de uma sessão
    public List<DetalheExercicioSerie> listarDetalhesSessao(int idSessao) {
        List<DetalheExercicioSerie> detalhes = new ArrayList<>();
        String sql = "SELECT E.nome AS nomeExercicio, S.repeticoes, S.peso " +
                     "FROM Serie S " +
                     "JOIN UsuarioExercicio UE ON S.id_usuario_exercicio = UE.id_usuario_exercicio " +
                     "JOIN Exercicio E ON UE.id_exercicio = E.id_exercicio " +
                     "WHERE UE.id_sessao = ? " +
                     "ORDER BY UE.id_usuario_exercicio ASC, S.data_registro ASC"; // Ordena para agrupar as séries de um mesmo exercício

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idSessao);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DetalheExercicioSerie detalhe = new DetalheExercicioSerie(
                        rs.getString("nomeExercicio"),
                        rs.getInt("repeticoes"),
                        rs.getFloat("peso")
                    );
                    detalhes.add(detalhe);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detalhes;
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
        String sql = "SELECT E.nome AS nomeExercicio, MAX(S.peso) AS pesoMaximo " +
                     "FROM Serie S " +
                     "JOIN UsuarioExercicio UE ON S.id_usuario_exercicio = UE.id_usuario_exercicio " +
                     "JOIN Exercicio E ON UE.id_exercicio = E.id_exercicio " +
                     "WHERE UE.id_usuario = ? " + 
                     "GROUP BY E.nome " + 
                     "ORDER BY pesoMaximo DESC";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String nome = rs.getString("nomeExercicio");
                    float peso = rs.getFloat("pesoMaximo"); 
                    recordes.add(new ProgressoExercicio(nome, peso));
                }
            }
        } catch (SQLException e) {
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

    public int getTotalTreinosConcluidos(int idUsuario) {
        String sql = "SELECT COUNT(id_sessao) FROM TreinoSessao WHERE id_usuario = ? AND data_fim IS NOT NULL";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalDiasUnicosDeTreino(int idUsuario) {
        String sql = "SELECT COUNT(DISTINCT DATE(data_fim)) FROM TreinoSessao WHERE id_usuario = ? AND data_fim IS NOT NULL";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}