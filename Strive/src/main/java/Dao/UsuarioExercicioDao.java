package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import Utils.ConexaoDB;

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
}