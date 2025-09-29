package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import Modelos.Treino;
import Modelos.Usuario;
import Utils.ConexaoDB;

public class TreinoDAO {

    // --- SEUS MÉTODOS listarPorUsuario() e salvar() CONTINUAM AQUI (sem alterações) ---

    public List<Treino> listarPorUsuario(int idUsuario) {
        List<Treino> lista = new ArrayList<>();
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
    
    // --- MÉTODO MODIFICADO PARA CRIAR TREINOS A, B e C ---
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
        treinoA.setNivel(usuario.getNivelInicial());
        treinoB.setIdUsuario(usuario.getId());
        treinoB.setNivel(usuario.getNivelInicial());
        treinoC.setIdUsuario(usuario.getId());
        treinoC.setNivel(usuario.getNivelInicial());
        
        switch (nivel) {
            case "iniciante":
              
                treinoA.setNome(" A - Peito, Ombro, Tríceps");
                treinoA.setDescricao("Foco em exercícios básicos para fortalecimento superior.");
                idsExerciciosA = new String[]{"1", "7", "10"}; 

               
                treinoB.setNome(" B - Costas e Bíceps");
                treinoB.setDescricao("Foco em puxadas para fortalecimento das costas.");
                idsExerciciosB = new String[]{"4", "8"}; 
              
                treinoC.setNome(" C - Pernas");
                treinoC.setDescricao("Fortalecimento completo dos membros inferiores.");
                idsExerciciosC = new String[]{"13", "14", "16"}; 

                break;

            case "intermediario":
              
                treinoA.setNome(" A - Peito, Ombro, Tríceps");
                treinoA.setDescricao("Maior volume e intensidade para peitoral, ombros e tríceps.");
                idsExerciciosA = new String[]{"2", "6", "11", "18"}; 
             
                treinoB.setNome(" B - Costas e Bíceps");
                treinoB.setDescricao("Exercícios compostos para densidade e largura das costas.");
                idsExerciciosB = new String[]{"3", "5", "9"}; 
                treinoC.setNome(" C - Pernas");
                treinoC.setDescricao("Foco em exercícios livres para máxima hipertrofia.");
                idsExerciciosC = new String[]{"12", "15", "17"};

                break;
                
            case "avançado":
                
                treinoA.setNome(" A - Push");
                treinoA.setDescricao("Treino de força e hipertrofia para peito, ombro e tríceps.");
                idsExerciciosA = new String[]{"1", "2", "6", "11", "18"}; // Supino Reto, Supino Inclinado, Desenv. Militar, Tríceps Testa, Elevação Lateral

             
                treinoB.setNome(" B - Pull");
                treinoB.setDescricao("Treino completo de costas e bíceps com alta intensidade.");
                idsExerciciosB = new String[]{"5", "3", "20", "8", "9"}; // Barra Fixa, Remada Curvada, Remada Cavalinho, Rosca Direta, Rosca Martelo

                
                treinoC.setNome(" C - Pernas");
                treinoC.setDescricao("Volume e intensidade máximos para desenvolvimento completo das pernas.");
                idsExerciciosC = new String[]{"12", "13", "15", "17", "16"}; // Agachamento Livre, Leg Press, Stiff, Cadeira Flexora, Panturrilha
                
                break;

            default:
                return;
        }

        
        salvar(treinoA, idsExerciciosA);
        salvar(treinoB, idsExerciciosB);
        salvar(treinoC, idsExerciciosC);
    }
}