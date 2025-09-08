package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import Modelos.Exercicio;
import Utils.ConexaoDB;

public class ExercicioDAO {
	
    // NOVO MÉTODO: Lista todos os exercícios para o formulário de criação de treino
    public List<Exercicio> listarTodos() {
        List<Exercicio> lista = new ArrayList<>();
        String sql = "SELECT * FROM Exercicio ORDER BY grupo_muscular, nome";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
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

    // MÉTODO ATUALIZADO: Busca os exercícios de um treino usando a tabela de ligação
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
                // A coluna id_treino não existe mais no objeto Exercicio, então removemos a linha
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