package Utils;


import java.sql.Connection;
import java.sql.SQLException;
import Utils.ConexaoDB;

public class TestaConexao {
    public static void main(String[] args) {
        try (Connection conexao = ConexaoDB.getConnection()) {
            if (conexao != null && !conexao.isClosed()) {
                System.out.println("Conexão com o banco de dados estabelecida com sucesso!");
            } else {
                System.out.println("Falha ao conectar ao banco de dados.");
            }
        } catch (SQLException e) {
            System.out.println("Erro ao conectar ao banco de dados:");
            e.printStackTrace();
        }
    }
}
