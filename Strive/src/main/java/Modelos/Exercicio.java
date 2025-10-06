package Modelos;

import java.util.ArrayList;
import java.util.List;

public class Exercicio {
    private int id;
    private String nome;
    private String grupoMuscular;
    private String repeticoes;
    private Float peso;
    private String descricao;
    private List<Serie> series;

    public Exercicio() {
        this.series = new ArrayList<>();
    }

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

    public String getGrupoMuscular() {
        return grupoMuscular;
    }

    public void setGrupoMuscular(String grupoMuscular) {
        this.grupoMuscular = grupoMuscular;
    }

    public String getRepeticoes() {
        return repeticoes;
    }

    public void setRepeticoes(String repeticoes) {
        this.repeticoes = repeticoes;
    }

    public Float getPeso() {
        return peso;
    }

    public void setPeso(Float peso) {
        this.peso = peso;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public List<Serie> getSeries() {
        return series;
    }

    public void setSeries(List<Serie> series) {
        this.series = series;
    }
}