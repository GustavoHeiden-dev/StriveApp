package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement; // Importar Statement
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import Modelos.Serie;
import Utils.ConexaoDB;

public class SerieDAO {

    /**
     * Salva uma nova série no banco de dados e retorna o ID gerado.
     * @param serie Objeto Serie com os dados a serem salvos.
     * @return O ID (int) da série recém-inserida ou 0 em caso de falha.
     */
    public int salvarRetornandoId(Serie serie) {
        String sql = "INSERT INTO Serie (id_usuario_exercicio, repeticoes, peso) VALUES (?, ?, ?)";
        int idGerado = 0;
        
        // Uso de Statement.RETURN_GENERATED_KEYS para obter o ID gerado
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, serie.getIdUsuarioExercicio());
            stmt.setInt(2, serie.getRepeticoes());
            stmt.setFloat(3, serie.getPeso());
            
            int linhasAfetadas = stmt.executeUpdate();
            
            if (linhasAfetadas > 0) {
                // Recupera o ID gerado
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGerado = rs.getInt(1); // O primeiro campo é o ID gerado
                    }
                }
            }
            return idGerado;

        } catch (Exception e) {
            e.printStackTrace();
            return 0; // Retorna 0 em caso de erro
        }
    }

    /**
     * Remove uma série do banco de dados pelo seu ID.
     * @param idSerie O ID da série a ser removida.
     * @return true se a remoção foi bem-sucedida, false caso contrário.
     */
    public boolean removerPorId(int idSerie) {
        String sql = "DELETE FROM Serie WHERE id_serie = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, idSerie);
            
            // Verifica se alguma linha foi afetada (se a série foi realmente excluída)
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;

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