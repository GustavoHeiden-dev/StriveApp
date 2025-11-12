package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import Modelos.Usuario;
import Utils.ConexaoDB;

public class UsuarioDAO {

	public Usuario autenticar(String email, String senha) {
	    Usuario usuario = null;
	    try (Connection con = ConexaoDB.getConnection()) {
	        String sql = "SELECT * FROM Usuario WHERE email = ? AND senha = MD5(?)";
	        PreparedStatement stmt = con.prepareStatement(sql);
	        stmt.setString(1, email);
	        stmt.setString(2, senha);

	        ResultSet rs = stmt.executeQuery();
	        if (rs.next()) {
	            usuario = new Usuario();
	            usuario.setId(rs.getInt("id_usuario"));
	            usuario.setNome(rs.getString("nome"));
	            usuario.setEmail(rs.getString("email"));
	            usuario.setSenha(rs.getString("senha"));
	            usuario.setIdade(rs.getInt("idade"));
	            usuario.setPesoInicial(rs.getFloat("pesoInicial"));
	            usuario.setAltura(rs.getFloat("altura"));
	            usuario.setNivelInicial(rs.getString("nivelInicial"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return usuario;
	}

	public void cadastrar(Usuario usuario) throws Exception {
		String sql = "INSERT INTO Usuario (nome, email, senha, idade, pesoInicial , altura, nivelInicial) "
				    + "VALUES (?, ?, MD5(?), ?, ?, ?, ?)";
		
		try (Connection con = ConexaoDB.getConnection()) {
			String checkEmailSql = "SELECT COUNT(*) FROM Usuario WHERE email = ?";
			try (PreparedStatement checkStmt = con.prepareStatement(checkEmailSql)) {
				checkStmt.setString(1, usuario.getEmail());
				ResultSet checkRs = checkStmt.executeQuery();
				checkRs.next();
				if (checkRs.getInt(1) > 0) {
					throw new Exception("Já existe um usuário cadastrado com esse email.");
				}
			}
			if(usuario.getAltura() > 2.50 || usuario.getAltura() < 0){
				 throw new Exception("Altura inválida.");
			}
			else if (usuario.getIdade() > 100 || usuario.getIdade() < 0) {
				 throw new Exception("Idade inválida.");
			}
			else if (usuario.getPesoInicial() <= 20  || usuario.getPesoInicial() >  400 ) {
				throw new Exception("Peso inválido.");
			}

			try (PreparedStatement stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
				stmt.setString(1, usuario.getNome());
				stmt.setString(2, usuario.getEmail());
				stmt.setString(3, usuario.getSenha());
				stmt.setInt(4, usuario.getIdade());
				stmt.setFloat(5, usuario.getPesoInicial());
				stmt.setFloat(6, usuario.getAltura());
				stmt.setString(7, usuario.getNivelInicial());

				int affectedRows = stmt.executeUpdate();

				if (affectedRows > 0) {
					try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
						if (generatedKeys.next()) {
							usuario.setId(generatedKeys.getInt(1));
							
							TreinoDAO treinoDao = new TreinoDAO();
							treinoDao.criarTreinoPadraoParaUsuario(usuario);
						}
					}
				}
			}
		} catch (Exception e) {
			throw e;
		}
	}
	    
	public void editar(Usuario usuario) {
		try (Connection con = ConexaoDB.getConnection()) {
			String sql = "UPDATE Usuario SET nome = ?, email = ?, senha = MD5(?), idade = ?, pesoInicial = ?, altura = ?, nivelInicial = ? WHERE id_usuario = ?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setString(1, usuario.getNome());
			stmt.setString(2, usuario.getEmail());
			stmt.setString(3, usuario.getSenha());
			stmt.setInt(4, usuario.getIdade());
			stmt.setFloat(5, usuario.getPesoInicial());
			stmt.setFloat(6, usuario.getAltura());
			stmt.setString(7, usuario.getNivelInicial());
			stmt.setInt(8, usuario.getId());

			stmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Usuario getUsuarioPorId(int id) {
		Usuario usuario = null;
		try (Connection con = ConexaoDB.getConnection()) {
			String sql = "SELECT * FROM Usuario WHERE id_usuario = ?";
			PreparedStatement stmt = con.prepareStatement(sql);
			stmt.setInt(1, id);

			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				usuario = new Usuario();
				usuario.setId(rs.getInt("id_usuario"));
				usuario.setNome(rs.getString("nome"));
				usuario.setEmail(rs.getString("email"));
				usuario.setSenha(rs.getString("senha"));
				usuario.setIdade(rs.getInt("idade"));
				usuario.setPesoInicial(rs.getFloat("pesoInicial"));
				usuario.setAltura(rs.getFloat("altura"));
				usuario.setNivelInicial(rs.getString("nivelInicial"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return usuario;
	}

    public Usuario buscarPorEmail(String email) {
        Usuario usuario = null;
        String sql = "SELECT * FROM Usuario WHERE email = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, email);
    
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                usuario = new Usuario();
                usuario.setId(rs.getInt("id_usuario"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setIdade(rs.getInt("idade"));
                usuario.setPesoInicial(rs.getFloat("pesoInicial"));
                usuario.setAltura(rs.getFloat("altura"));
                usuario.setNivelInicial(rs.getString("nivelInicial"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }

    public boolean salvarToken(int idUsuario, String token) {
        String sql = "UPDATE Usuario SET token_resetar_senha = ? WHERE id_usuario = ?";
        
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setString(1, token);
            stmt.setInt(2, idUsuario);
            
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Usuario buscarPorToken(String token) {
        Usuario usuario = null;
        String sql = "SELECT * FROM Usuario WHERE token_resetar_senha = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id_usuario"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setNome(rs.getString("nome"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return usuario;
    }

    public boolean redefinirSenha(int idUsuario, String novaSenha) {
        String sql = "UPDATE Usuario SET senha = MD5(?), token_resetar_senha = NULL WHERE id_usuario = ?";
        try (Connection con = ConexaoDB.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, novaSenha);
            stmt.setInt(2, idUsuario);
            int linhasAfetadas = stmt.executeUpdate();
            return linhasAfetadas > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
}