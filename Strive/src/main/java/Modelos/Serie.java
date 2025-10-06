package Modelos;

import java.time.LocalDateTime;

public class Serie {

    private int id;
    private int idUsuarioExercicio;
    private int repeticoes;
    private float peso;
    private LocalDateTime dataRegistro;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUsuarioExercicio() {
        return idUsuarioExercicio;
    }

    public void setIdUsuarioExercicio(int idUsuarioExercicio) {
        this.idUsuarioExercicio = idUsuarioExercicio;
    }

    public int getRepeticoes() {
        return repeticoes;
    }

    public void setRepeticoes(int repeticoes) {
        this.repeticoes = repeticoes;
    }

    public float getPeso() {
        return peso;
    }

    public void setPeso(float peso) {
        this.peso = peso;
    }

    public LocalDateTime getDataRegistro() {
        return dataRegistro;
    }

    public void setDataRegistro(LocalDateTime dataRegistro) {
        this.dataRegistro = dataRegistro;
    }
}