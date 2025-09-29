package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement; // ---> IMPORT ADICIONADO

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

    // --- MÉTODO CADASTRAR MODIFICADO ---
	public void cadastrar(Usuario usuario) throws Exception {
		String sql = "INSERT INTO Usuario (nome, email, senha, idade, pesoInicial , altura, nivelInicial) "
				   + "VALUES (?, ?, MD5(?), ?, ?, ?, ?)";
		
		try (Connection con = ConexaoDB.getConnection()) {
			// Suas validações existentes
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

			// Modificamos a criação do PreparedStatement para nos retornar o ID gerado
			try (PreparedStatement stmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
				stmt.setString(1, usuario.getNome());
				stmt.setString(2, usuario.getEmail());
				stmt.setString(3, usuario.getSenha());
				stmt.setInt(4, usuario.getIdade());
				stmt.setFloat(5, usuario.getPesoInicial());
				stmt.setFloat(6, usuario.getAltura());
				stmt.setString(7, usuario.getNivelInicial());

				int affectedRows = stmt.executeUpdate();

				// Se o usuário foi inserido, obtemos o ID e criamos o treino padrão
				if (affectedRows > 0) {
					try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
						if (generatedKeys.next()) {
							// Define o ID recém-criado no objeto usuario
							usuario.setId(generatedKeys.getInt(1));
							
							// AGORA, CHAMAMOS O DAO PARA CRIAR O TREINO PADRÃO
							TreinoDAO treinoDao = new TreinoDAO();
							treinoDao.criarTreinoPadraoParaUsuario(usuario);
						}
					}
				}
			}
		} catch (Exception e) {
			// Re-lança a exceção para que o Servlet possa tratá-la
			throw e;
		}
	}
    // --- FIM DO MÉTODO MODIFICADO ---
        
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
}