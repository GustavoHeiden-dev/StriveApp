package Modelos;

public class ProgressoExercicio {

    private String nomeExercicio;
    private float pesoMaximo;

    public ProgressoExercicio(String nomeExercicio, float pesoMaximo) {
        this.nomeExercicio = nomeExercicio;
        this.pesoMaximo = pesoMaximo;
    }

    public String getNomeExercicio() {
        return nomeExercicio;
    }

    public void setNomeExercicio(String nomeExercicio) {
        this.nomeExercicio = nomeExercicio;
    }

    public float getPesoMaximo() {
        return pesoMaximo;
    }

    public void setPesoMaximo(float pesoMaximo) {
        this.pesoMaximo = pesoMaximo;
    }
}