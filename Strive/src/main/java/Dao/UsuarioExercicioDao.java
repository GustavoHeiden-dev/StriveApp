package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import Utils.ConexaoDB;
import Modelos.Usuario;

public class UsuarioExercicioDao {

    public boolean salvar(int idUsuario, int idExercicio, int idSessao, String repeticoesFeitas, Float pesoUsado) {
        String sql = "INSERT INTO UsuarioExercicio (id_usuario, id_exercicio, id_sessao, repeticoes_feitas, peso_usado, concluido, data_execucao) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idUsuario);
            ps.setInt(2, idExercicio);
            ps.setInt(3, idSessao);
            ps.setString(4, repeticoesFeitas);

            if (pesoUsado != null) {
                ps.setFloat(5, pesoUsado);
            } else {
                ps.setNull(5, java.sql.Types.FLOAT);
            }
            
            ps.setBoolean(6, true);
            ps.setTimestamp(7, Timestamp.valueOf(LocalDateTime.now()));
            
            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int obterOuCriar(int idUsuario, int idExercicio, int idSessao) {
        String sqlSelect = "SELECT id_usuario_exercicio FROM UsuarioExercicio WHERE id_usuario = ? AND id_exercicio = ? AND id_sessao = ?";
        String sqlInsert = "INSERT INTO UsuarioExercicio (id_usuario, id_exercicio, id_sessao, data_execucao) VALUES (?, ?, ?, NOW())";

        try (Connection con = ConexaoDB.getConnection()) {
            try (PreparedStatement psSelect = con.prepareStatement(sqlSelect)) {
                psSelect.setInt(1, idUsuario);
                psSelect.setInt(2, idExercicio);
                psSelect.setInt(3, idSessao);
                try (ResultSet rs = psSelect.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("id_usuario_exercicio");
                    }
                }
            }

            try (PreparedStatement psInsert = con.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setInt(1, idUsuario);
                psInsert.setInt(2, idExercicio);
                psInsert.setInt(3, idSessao);
                psInsert.executeUpdate();

                try (ResultSet rs = psInsert.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean reabrir(int idUsuario, int idExercicio, int idSessao) {
        // SQL: Atualiza o registro, definindo o campo 'concluido' como FALSE.
        // A condição WHERE garante que apenas o registro específico daquela sessão, 
        // usuário e exercício s 
        String sql = "UPDATE UsuarioExercicio SET concluido = FALSE " +
                     "WHERE id_usuario = ? AND id_exercicio = ? AND id_sessao = ?";

        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idExercicio);
            stmt.setInt(3, idSessao);

            int rowsAffected = stmt.executeUpdate();
            // Retorna true se pelo menos uma linha foi atualizada
            return rowsAffected > 0; 

        } catch (Exception e) {
            System.err.println("Erro ao reabrir/desmarcar exercício: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}