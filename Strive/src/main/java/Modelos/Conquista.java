package Modelos;

import java.sql.Timestamp;

public class Conquista {
    private int id_conquista;
    private String nome;
    private String descricao;
    private String icone;
    private int meta;
    private String tipo_meta;
    private boolean concluido;
    private double progresso;
    private Timestamp data_conclusao;
    
    // NOVO CAMPO: Para armazenar o valor atual do progresso (ex: 2 em 2/5)
    private int progressoAtual; 

    // Construtor (opcional, mas recomendado)
    public Conquista() {}

    // ------------------------------------------------------------------
    // Getters e Setters para ProgressoAtual
    // ------------------------------------------------------------------

    public int getProgressoAtual() {
        return progressoAtual;
    }

    public void setProgressoAtual(int progressoAtual) {
        this.progressoAtual = progressoAtual;
    }

    // ------------------------------------------------------------------
    // Outros Getters e Setters (já existentes)
    // ------------------------------------------------------------------
    
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

    public boolean isConcluido() {
        return concluido;
    }

    public void setConcluido(boolean concluido) {
        this.concluido = concluido;
    }

    public double getProgresso() {
        return progresso;
    }

    public void setProgresso(double progresso) {
        this.progresso = progresso;
    }

    public Timestamp getData_conclusao() {
        return data_conclusao;
    }

    public void setData_conclusao(Timestamp data_conclusao) {
        this.data_conclusao = data_conclusao;
    }
}