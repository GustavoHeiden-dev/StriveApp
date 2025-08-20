package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conecxao {
    private static final String URL = "jdbc:mysql://localhost:3306/supermercado";
    private static final String USUARIO = "root";
    private static final String SENHA = "admin";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Driver do MySQL 8+
            return DriverManager.getConnection(URL, USUARIO, SENHA);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC não encontrado", e);
        }
    }
}