package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Modelos.Exercicio;
import Utils.ConexaoDB;

public class ExercicioDAO {

    /**
     * MÉTODO CORRIGIDO: Lista todos os exercícios do banco de dados sem duplicatas.
     * A query foi ajustada para "SELECT *" para buscar todas as colunas necessárias.
     */
    public List<Exercicio> listarTodos() {
        List<Exercicio> lista = new ArrayList<>();
        // A query foi corrigida para selecionar todas as colunas.
        String sql = "SELECT * FROM Exercicio";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Exercicio ex = new Exercicio();
                ex.setId(rs.getInt("id_exercicio"));
                ex.setNome(rs.getString("nome"));
                ex.setGrupoMuscular(rs.getString("grupo_muscular"));
                ex.setRepeticoes(rs.getString("repeticoes"));
                // Verifica se o peso é nulo antes de tentar acessá-lo
                ex.setPeso(rs.getObject("peso") == null ? null : rs.getFloat("peso"));
                ex.setDescricao(rs.getString("descricao"));
                lista.add(ex);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Busca os exercícios de um treino específico usando a tabela de ligação.
     */
    public List<Exercicio> listarPorTreino(int idTreino) {
        List<Exercicio> lista = new ArrayList<>();
        String sql = "SELECT e.* FROM Exercicio e " +
                     "INNER JOIN TreinoExercicio te ON e.id_exercicio = te.id_exercicio " +
                     "WHERE te.id_treino = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idTreino);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Exercicio ex = new Exercicio();
                ex.setId(rs.getInt("id_exercicio"));
                ex.setNome(rs.getString("nome"));
                ex.setGrupoMuscular(rs.getString("grupo_muscular"));
                ex.setRepeticoes(rs.getString("repeticoes"));
                ex.setPeso(rs.getObject("peso") == null ? null : rs.getFloat("peso"));
                ex.setDescricao(rs.getString("descricao"));
                lista.add(ex);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}