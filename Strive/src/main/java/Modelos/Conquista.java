package Modelos;

import java.util.Date;

public class Conquista {

    private int id_conquista;
    private String nome;
    private String descricao;
    private String icone;
    private int meta;
    private String tipo_meta;
    private Date data_conclusao;

    private double progresso;
    private boolean concluido;

    public Conquista() {
    }

    public Conquista(int id_conquista, String nome, String descricao, String icone, int meta, String tipo_meta) {
        this.id_conquista = id_conquista;
        this.nome = nome;
        this.descricao = descricao;
        this.icone = icone;
        this.meta = meta;
        this.tipo_meta = tipo_meta;
    }

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

    public int getMeta() {
        return meta;
    }

    public void setMeta(int meta) {
        this.meta = meta;
    }
    
    public String getTipo_meta() {
        return tipo_meta;
    }

    public void setTipo_meta(String tipo_meta) {
        this.tipo_meta = tipo_meta;
    }

    public Date getData_conclusao() {
        return data_conclusao;
    }

    public void setData_conclusao(Date data_conclusao) {
        this.data_conclusao = data_conclusao;
    }
    
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