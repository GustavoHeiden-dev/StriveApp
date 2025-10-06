package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import Modelos.Serie;
import Utils.ConexaoDB;

public class SerieDAO {

    public boolean salvar(Serie serie) {
        String sql = "INSERT INTO Serie (id_usuario_exercicio, repeticoes, peso) VALUES (?, ?, ?)";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, serie.getIdUsuarioExercicio());
            stmt.setInt(2, serie.getRepeticoes());
            stmt.setFloat(3, serie.getPeso());
            stmt.executeUpdate();
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Serie> listarPorUsuarioExercicio(int idUsuarioExercicio) {
        List<Serie> series = new ArrayList<>();
        String sql = "SELECT id_serie, repeticoes, peso, data_registro FROM Serie WHERE id_usuario_exercicio = ?";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuarioExercicio);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Serie serie = new Serie();
                    serie.setId(rs.getInt("id_serie"));
                    serie.setRepeticoes(rs.getInt("repeticoes"));
                    serie.setPeso(rs.getFloat("peso"));
                    
                    Timestamp ts = rs.getTimestamp("data_registro");
                    if (ts != null) {
                        serie.setDataRegistro(ts.toLocalDateTime());
                    }
                    
                    series.add(serie);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return series;
    }
}