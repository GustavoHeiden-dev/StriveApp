package Modelos;

public class DetalheExercicioSerie {
    private String nomeExercicio;
    private int repeticoes;
    private float peso;

    // Construtor
    public DetalheExercicioSerie(String nomeExercicio, int repeticoes, float peso) {
        this.nomeExercicio = nomeExercicio;
        this.repeticoes = repeticoes;
        this.peso = peso;
    }

    // Getters
    public String getNomeExercicio() {
        return nomeExercicio;
    }

    public int getRepeticoes() {
        return repeticoes;
    }

    public float getPeso() {
        return peso;
    }
    
    // Setters (Opcionais, mas boas práticas)
    public void setNomeExercicio(String nomeExercicio) {
        this.nomeExercicio = nomeExercicio;
    }

    public void setRepeticoes(int repeticoes) {
        this.repeticoes = repeticoes;
    }

    public void setPeso(float peso) {
        this.peso = peso;
    }
}