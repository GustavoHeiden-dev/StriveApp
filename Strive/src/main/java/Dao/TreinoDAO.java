package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import Modelos.Exercicio;
import Modelos.Treino;
import Modelos.Usuario;
import Utils.ConexaoDB;

public class TreinoDAO {

    public List<Treino> listarPorUsuario(int idUsuario) {
        List<Treino> lista = new ArrayList<>();
        String sql = "SELECT id_treino, nome FROM Treino WHERE id_usuario = ?";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Treino t = new Treino();
                    t.setId(rs.getInt("id_treino"));
                    t.setNome(rs.getString("nome"));
                    t.setIdUsuario(idUsuario);
                    
                    ExercicioDAO exercicioDAO = new ExercicioDAO();
                    t.setExercicios(exercicioDAO.listarPorTreino(t.getId()));
                    
                    lista.add(t);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
      
    public boolean salvar(Treino treino, String[] exerciciosIds) {
        String sqlTreino = "INSERT INTO Treino (nome, id_usuario) VALUES (?, ?)";
        String sqlTreinoExercicio = "INSERT INTO TreinoExercicio (id_treino, id_exercicio) VALUES (?, ?)";
        Connection con = null;

        try {
            con = ConexaoDB.getConnection();
            con.setAutoCommit(false);

            int idTreinoGerado = 0;
            try (PreparedStatement psTreino = con.prepareStatement(sqlTreino, Statement.RETURN_GENERATED_KEYS)) {
                psTreino.setString(1, treino.getNome());
                psTreino.setInt(2, treino.getIdUsuario());
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
    
    public void criarTreinoPadraoParaUsuario(Usuario usuario) {
        if (usuario == null || usuario.getNivelInicial() == null) {
            return;
        }

        Treino treinoA = new Treino();
        Treino treinoB = new Treino();
        Treino treinoC = new Treino();
        String[] idsExerciciosA, idsExerciciosB, idsExerciciosC;

        String nivel = usuario.getNivelInicial().toLowerCase();
        
        treinoA.setIdUsuario(usuario.getId());
        treinoB.setIdUsuario(usuario.getId());
        treinoC.setIdUsuario(usuario.getId());
        
        switch (nivel) {
            case "iniciante":
                treinoA.setNome(" A - Peito, Ombro, Tríceps");
                idsExerciciosA = new String[]{"1", "7", "10"}; 
                treinoB.setNome(" B - Costas e Bíceps");
                idsExerciciosB = new String[]{"4", "8"}; 
                treinoC.setNome(" C - Pernas");
                idsExerciciosC = new String[]{"13", "14", "16"}; 
                break;
            case "intermediario":
                treinoA.setNome(" A - Peito, Ombro, Tríceps");
                idsExerciciosA = new String[]{"2", "6", "11", "18"}; 
                treinoB.setNome(" B - Costas e Bíceps");
                idsExerciciosB = new String[]{"3", "5", "9"}; 
                treinoC.setNome(" C - Pernas");
                idsExerciciosC = new String[]{"12", "15", "17"};
                break;
            case "avançado":
                treinoA.setNome(" A - Push");
                idsExerciciosA = new String[]{"1", "2", "6", "11", "18"};
                treinoB.setNome(" B - Pull");
                idsExerciciosB = new String[]{"5", "3", "20", "8", "9"};
                treinoC.setNome(" C - Pernas");
                idsExerciciosC = new String[]{"12", "13", "15", "17", "16"};
                break;
            default:
                return;
        }
        
        salvar(treinoA, idsExerciciosA);
        salvar(treinoB, idsExerciciosB);
        salvar(treinoC, idsExerciciosC);
    }

    public void atualizar(int idTreino, String nome, String[] exerciciosIds) {
        String sqlUpdateTreino = "UPDATE Treino SET nome = ? WHERE id_treino = ?";
        String sqlDeleteExercicios = "DELETE FROM TreinoExercicio WHERE id_treino = ?";
        String sqlInsertExercicios = "INSERT INTO TreinoExercicio (id_treino, id_exercicio) VALUES (?, ?)";

        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateTreino)) {
                psUpdate.setString(1, nome);
                psUpdate.setInt(2, idTreino);
                psUpdate.executeUpdate();
            }

            try (PreparedStatement psDelete = conn.prepareStatement(sqlDeleteExercicios)) {
                psDelete.setInt(1, idTreino);
                psDelete.executeUpdate();
            }

            if (exerciciosIds != null && exerciciosIds.length > 0) {
                try (PreparedStatement psInsert = conn.prepareStatement(sqlInsertExercicios)) {
                    for (String idExercicio : exerciciosIds) {
                        psInsert.setInt(1, idTreino);
                        psInsert.setInt(2, Integer.parseInt(idExercicio));
                        psInsert.addBatch();
                    }
                    psInsert.executeBatch();
                }
            }
            conn.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Treino buscarPorId(int idTreino) {
        Treino treino = null;
        String sql = "SELECT id_treino, nome, id_usuario FROM Treino WHERE id_treino = ?";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setInt(1, idTreino);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    treino = new Treino();
                    treino.setId(rs.getInt("id_treino"));
                    treino.setNome(rs.getString("nome"));
                    treino.setIdUsuario(rs.getInt("id_usuario"));
                    
                    ExercicioDAO exercicioDAO = new ExercicioDAO();
                    treino.setExercicios(exercicioDAO.listarPorTreino(idTreino));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return treino;
    }
}