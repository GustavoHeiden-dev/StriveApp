package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import Modelos.Usuario;
import Utils.ConexaoDB;

public class UsuarioDAO {

	public Usuario autenticar(String email, String senha) {
	    Usuario usuario = null;
	    try (Connection con = ConexaoDB.getConnection()) {
	        String sql = "SELECT * FROM Usuario WHERE email = ? AND senha = ?";
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


    public void cadastrar(Usuario usuario) {
        try (Connection con = ConexaoDB.getConnection()) {
            String sql = "INSERT INTO Usuario (nome, email, senha, idade, pesoInicial , altura, nivelInicial) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getSenha());
            stmt.setInt(4, usuario.getIdade());
            stmt.setFloat(5, usuario.getPesoInicial());
            stmt.setFloat(6, usuario.getAltura());
            stmt.setString(7, usuario.getNivelInicial());

            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
