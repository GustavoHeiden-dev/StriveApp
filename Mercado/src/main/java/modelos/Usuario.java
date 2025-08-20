package modelos;

public class Usuario {
    private String nome;
    private String cpf;
    private boolean admin;

    public Usuario(String nome, String cpf, boolean admin) {
        this.nome = nome;
        this.cpf = cpf;
        this.admin = admin;
    }

    public String getNome() { return nome; }
    public String getCpf() { return cpf; }
    public boolean isAdmin() { return admin; }
}
