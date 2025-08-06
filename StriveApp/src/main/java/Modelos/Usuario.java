package Modelos;

public class Usuario {
    private int id;
    private String nome;
    private String email;
    private String senha;
    private int idade;
    private float pesoInicial;
    private float altura;
    private String nivelInicial;

    public Usuario() {}

    public Usuario(int id, String nome, String email, String senha, int idade, float pesoInicial, float altura, String nivelInicial) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.idade = idade;
        this.pesoInicial = pesoInicial;
        this.altura = altura;
        this.nivelInicial = nivelInicial;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getSenha() {
        return senha;
    }
    public void setSenha(String senha) {
        this.senha = senha;
    }
    public int getIdade() {
        return idade;
    }
    public void setIdade(int idade) {
        this.idade = idade;
    }
    public float getPesoInicial() {
        return pesoInicial;
    }
    public void setPesoInicial(float pesoInicial) {
        this.pesoInicial = pesoInicial;
    }
    public float getAltura() {
        return altura;
    }
    public void setAltura(float altura) {
        this.altura = altura;
    }
    public String getNivelInicial() {
        return nivelInicial;
    }
    public void setNivelInicial(String nivelInicial) {
        this.nivelInicial = nivelInicial;
    }
}
