package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import Modelos.Treino;
import Utils.ConexaoDB;

public class TreinoDAO {

    /**
     * MÉTODO CORRIGIDO: Busca apenas os treinos de um usuário específico.
     */
    public List<Treino> listarPorUsuario(int idUsuario) {
        List<Treino> lista = new ArrayList<>();
        // A cláusula WHERE id_usuario = ? é a chave para a correção.
        String sql = "SELECT id_treino, nome, descricao, nivel, id_usuario FROM Treino WHERE id_usuario = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Treino t = new Treino();
                    t.setId(rs.getInt("id_treino"));
                    t.setNome(rs.getString("nome"));
                    t.setDescricao(rs.getString("descricao"));
                    t.setNivel(rs.getString("nivel"));
                    t.setIdUsuario(rs.getInt("id_usuario"));
                    lista.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
	  
    /**
     * Salva o treino e suas associações com exercícios.
     */
    public boolean salvar(Treino treino, String[] exerciciosIds) {
        String sqlTreino = "INSERT INTO Treino (nome, descricao, nivel, id_usuario) VALUES (?, ?, ?, ?)";
        String sqlTreinoExercicio = "INSERT INTO TreinoExercicio (id_treino, id_exercicio) VALUES (?, ?)";
        Connection con = null;

        try {
            con = ConexaoDB.getConnection();
            con.setAutoCommit(false);

            int idTreinoGerado = 0;
            try (PreparedStatement psTreino = con.prepareStatement(sqlTreino, Statement.RETURN_GENERATED_KEYS)) {
                psTreino.setString(1, treino.getNome());
                psTreino.setString(2, treino.getDescricao());
                psTreino.setString(3, treino.getNivel());
                psTreino.setInt(4, treino.getIdUsuario());
                psTreino.executeUpdate();

                try (ResultSet rs = psTreino.getGeneratedKeys()) {
                    if (rs.next()) {
                        idTreinoGerado = rs.getInt(1);
                    }
                }
            }
            
            if (idTreinoGerado > 0 && exerciciosIds != null) {
                try (PreparedStatement psTreinoExercicio = con.prepareStatement(sqlTreinoExercicio)) {
                    for (String idExercicio : exerciciosIds) {
                        psTreinoExercicio.setInt(1, idTreinoGerado);
                        psTreinoExercicio.setInt(2, Integer.parseInt(idExercicio));
                        psTreinoExercicio.addBatch();
                    }
                    psTreinoExercicio.executeBatch();
                }
            }
            
            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
}