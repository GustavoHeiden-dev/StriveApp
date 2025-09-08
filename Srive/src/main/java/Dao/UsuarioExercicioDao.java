package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import Utils.ConexaoDB;
import java.sql.Timestamp;



public class UsuarioExercicioDao {
	
	public void marcarConcluido(int idUsuario, int idExercicio, String repeticoesFeitas, Float pesoUsado) {
        String checkSql = "SELECT id_usuario_exercicio FROM UsuarioExercicio WHERE id_usuario = ? AND id_exercicio = ?";
        String insertSql = "INSERT INTO UsuarioExercicio (id_usuario, id_exercicio, repeticoes_feitas, peso_usado, concluido, data_execucao) VALUES (?, ?, ?, ?, ?, ?)";
        String updateSql = "UPDATE UsuarioExercicio SET repeticoes_feitas = ?, peso_usado = ?, concluido = ?, data_execucao = ? WHERE id_usuario_exercicio = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement checkStmt = con.prepareStatement(checkSql)) {
            checkStmt.setInt(1, idUsuario);
            checkStmt.setInt(2, idExercicio);
            ResultSet rs = checkStmt.executeQuery();
            Timestamp now = new Timestamp(System.currentTimeMillis());
            if (rs.next()) {
                int idUsrEx = rs.getInt(1);
                try (PreparedStatement updateStmt = con.prepareStatement(updateSql)) {
                    updateStmt.setString(1, repeticoesFeitas);
                    if (pesoUsado == null) updateStmt.setNull(2, java.sql.Types.FLOAT);
                    else updateStmt.setFloat(2, pesoUsado);
                    updateStmt.setBoolean(3, true);
                    updateStmt.setTimestamp(4, now);
                    updateStmt.setInt(5, idUsrEx);
                    updateStmt.executeUpdate();
                }
            } else {
                try (PreparedStatement insertStmt = con.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, idUsuario);
                    insertStmt.setInt(2, idExercicio);
                    insertStmt.setString(3, repeticoesFeitas);
                    if (pesoUsado == null) insertStmt.setNull(4, java.sql.Types.FLOAT);
                    else insertStmt.setFloat(4, pesoUsado);
                    insertStmt.setBoolean(5, true);
                    insertStmt.setTimestamp(6, now);
                    insertStmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
