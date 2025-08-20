<%@ page import="java.util.List,Dao.DaoProdutos,modelos.Produto" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cadastro de Produtos - Supermercado</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(to right, #74ebd5, #ACB6E5);
        margin: 0;
        padding: 0;
    }

    .container {
        width: 90%;
        max-width: 900px;
        margin: 40px auto;
        background-color: #fff;
        padding: 25px 35px;
        border-radius: 10px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.3);
    }

    h2, h3 {
        text-align: center;
        color: #333;
    }

    form {
        text-align: center;
        margin-bottom: 25px;
    }

    input[type="text"] {
        padding: 8px;
        margin: 5px;
        border-radius: 5px;
        border: 1px solid #ccc;
        width: 20%;
        min-width: 100px;
    }

    input[type="submit"] {
        background-color: #4CAF50;
        color: white;
        border: none;
        padding: 8px 15px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        margin-left: 5px;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    th, td {
        padding: 12px;
        border: 1px solid #ccc;
        text-align: center;
    }

    th {
        background-color: #4CAF50;
        color: white;
    }

    tr:nth-child(even) {
        background-color: #f2f2f2;
    }

    .logout {
        display: block;
        text-align: center;
        font-weight: bold;
        text-decoration: none;
        color: #333;
        margin-top: 15px;
    }

    .logout:hover {
        color: #4CAF50;
    }

    form.inline {
        display: inline;
    }
</style>
</head>
<body>
    <div class="container">
        <h2>Cadastro de Produtos</h2>
        <form action="produto" method="post">
            Nome: <input type="text" name="nome" required>
            Preço: <input type="text" name="preco" required>
            Quantidade: <input type="text" name="quantidade" required>
            <input type="hidden" name="acao" value="adicionar">
            <input type="submit" value="Adicionar">
        </form>

        <h3>Produtos Cadastrados</h3>
        <table>
            <tr>
                <th>Nome</th>
                <th>Preço</th>
                <th>Quantidade</th>
                <th>Ação</th>
            </tr>
            <%
                DaoProdutos dao = new DaoProdutos();
                List<Produto> produtos = dao.listarProdutos();
                for (Produto p : produtos) {
            %>
            <tr>
                <td><%= p.getNome() %></td>
                <td>R$<%= p.getPreco() %></td>
                <td><%= p.getQuantidade() %></td>
                <td>
                    <form class="inline" action="produto" method="post">
                        <input type="hidden" name="acao" value="remover">
                        <input type="hidden" name="id" value="<%= p.getId() %>">
                        <input type="submit" value="Remover">
                    </form>
                </td>
            </tr>
            <%
                }
            %>
        </table>

        <a class="logout" href="Login.jsp">Logout</a>
    </div>
</body>
</html>
