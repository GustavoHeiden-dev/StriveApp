package Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import Modelos.Usuario;
import Utils.ConexaoDB;

public class UsuarioDAO {

    public boolean autenticar(String email, String senha) {
        try (Connection con = ConexaoDB.getConnection()) {
            String sql = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, senha);

            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true se encontrou o usuário
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void cadastrar(Usuario usuario) {
        try (Connection con = ConexaoDB.getConnection()) {
            String sql = "INSERT INTO usuarios (nome, email, senha, idade, peso_inicial, altura, nivel_inicial) "
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
