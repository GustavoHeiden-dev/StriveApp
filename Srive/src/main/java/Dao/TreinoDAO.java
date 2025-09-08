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
	
    public List<Treino> listarTodos() {
        List<Treino> lista = new ArrayList<>();
        // Note: A coluna 'duracao' foi removida da query
        String sql = "SELECT id_treino, nome, descricao, nivel, id_usuario FROM Treino";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Treino t = new Treino();
                t.setId(rs.getInt("id_treino"));
                t.setNome(rs.getString("nome"));
                t.setDescricao(rs.getString("descricao"));
                t.setNivel(rs.getString("nivel"));
                t.setIdUsuario(rs.getObject("id_usuario") == null ? null : rs.getInt("id_usuario"));
                lista.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
	  
    // MÉTODO ATUALIZADO: Agora salva o treino e suas associações com exercícios
    public boolean salvar(Treino t, String[] exerciciosIds) {
        String sqlTreino = "INSERT INTO Treino (nome, descricao, nivel, id_usuario) VALUES (?, ?, ?, ?)";
        String sqlTreinoExercicio = "INSERT INTO TreinoExercicio (id_treino, id_exercicio) VALUES (?, ?)";
        
        Connection con = null;
        try {
            con = ConexaoDB.getConnection();
            // Desativa o autocommit para garantir uma transação segura
            con.setAutoCommit(false);
            
            // 1. Insere o Treino e obtém o ID gerado
            int idTreinoGerado = 0;
            try (PreparedStatement psTreino = con.prepareStatement(sqlTreino, Statement.RETURN_GENERATED_KEYS)) {
                psTreino.setString(1, t.getNome());
                psTreino.setString(2, t.getDescricao());
                psTreino.setString(3, t.getNivel());
                if (t.getIdUsuario() != null) {
                    psTreino.setInt(4, t.getIdUsuario());
                } else {
                    psTreino.setNull(4, java.sql.Types.INTEGER);
                }
                psTreino.executeUpdate();
                
                ResultSet rs = psTreino.getGeneratedKeys();
                if (rs.next()) {
                    idTreinoGerado = rs.getInt(1);
                }
            }
            
            // 2. Insere as associações na tabela TreinoExercicio
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
            
            con.commit(); // Se tudo deu certo, confirma as transações
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback(); // Em caso de erro, reverte tudo
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