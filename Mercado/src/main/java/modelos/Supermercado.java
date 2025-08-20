package modelos;

import java.util.ArrayList;

public class Supermercado {
    private static ArrayList<Produto> produtos = new ArrayList<>();

    public static void adicionarProduto(Produto p) {
        produtos.add(p);
    }

    public static void removerProduto(int index) {
        if (index >= 0 && index < produtos.size()) {
            produtos.remove(index);
        }
    }

    public static ArrayList<Produto> getProdutos() {
        return produtos;
    }
}
