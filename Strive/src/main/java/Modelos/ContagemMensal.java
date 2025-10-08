package Modelos;

public class ContagemMensal {
    private int ano;
    private int mes;
    private int totalTreinos;

    public ContagemMensal(int ano, int mes, int totalTreinos) {
        this.ano = ano;
        this.mes = mes;
        this.totalTreinos = totalTreinos;
    }

    public int getAno() {
        return ano;
    }

    public int getMes() {
        return mes;
    }

    public int getTotalTreinos() {
        return totalTreinos;
    }
}