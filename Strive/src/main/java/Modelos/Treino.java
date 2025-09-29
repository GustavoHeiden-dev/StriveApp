package Modelos;

import java.util.List;

public class Treino {
    private int id;
    private String nome;
    private String descricao;
    private int duracao;
    private String nivel;
    private Integer idUsuario;

    // nova lista de exercícios
    private List<Exercicio> exercicios;

    public Treino() {}

    // getters / setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public int getDuracao() { return duracao; }
    public void setDuracao(int duracao) { this.duracao = duracao; }

    public String getNivel() { return nivel; }
    public void setNivel(String nivel) { this.nivel = nivel; }

    public Integer getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Integer idUsuario) { this.idUsuario = idUsuario; }

    public List<Exercicio> getExercicios() { return exercicios; }
    public void setExercicios(List<Exercicio> exercicios) { this.exercicios = exercicios; }
}
