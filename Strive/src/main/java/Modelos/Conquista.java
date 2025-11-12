package Modelos;

import java.util.Date;

public class Conquista {

    private int id_conquista;
    private String nome;
    private String descricao;
    private String icone;
    private int meta_treinos;
    private Date data_conclusao;

    // Campos adicionados para lógica de visualização
    private double progresso;
    private boolean concluido;

    public Conquista() {
    }

    public Conquista(int id_conquista, String nome, String descricao, String icone, int meta_treinos) {
        this.id_conquista = id_conquista;
        this.nome = nome;
        this.descricao = descricao;
        this.icone = icone;
        this.meta_treinos = meta_treinos;
    }

    // Getters e Setters
    public int getId_conquista() {
        return id_conquista;
    }

    public void setId_conquista(int id_conquista) {
        this.id_conquista = id_conquista;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getIcone() {
        return icone;
    }

    public void setIcone(String icone) {
        this.icone = icone;
    }

    public int getMeta_treinos() {
        return meta_treinos;
    }

    public void setMeta_treinos(int meta_treinos) {
        this.meta_treinos = meta_treinos;
    }

    public Date getData_conclusao() {
        return data_conclusao;
    }

    public void setData_conclusao(Date data_conclusao) {
        this.data_conclusao = data_conclusao;
    }
    
    // Getters e Setters para os novos campos

    public double getProgresso() {
        return progresso;
    }

    public void setProgresso(double progresso) {
        this.progresso = progresso;
    }

    public boolean isConcluido() {
        return concluido;
    }

    public void setConcluido(boolean concluido) {
        this.concluido = concluido;
    }
}