<%@ page
    import="modelos.Produto, java.util.ArrayList, java.util.List, Dao.DaoProdutos"%>
<%@ page session="true"%>
<%
ArrayList<Produto> carrinho = (ArrayList<Produto>) session.getAttribute("carrinho");
if (carrinho == null) {
    carrinho = new ArrayList<>();
    session.setAttribute("carrinho", carrinho);
}

// Instancia o DAO para pegar os produtos do banco
DaoProdutos dao = new DaoProdutos();
List<Produto> produtos = dao.listarProdutos();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Compra - Supermercado</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background: linear-gradient(to right, #74ebd5, #ACB6E5);
        margin: 0;
        padding: 0;
    }

    .container {
        width: 90%;
        max-width: 1000px;
        margin: 40px auto;
        background-color: #fff;
        padding: 20px 30px;
        border-radius: 10px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.3);
    }

    h2 {
        text-align: center;
        color: #333;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 25px;
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

    input[type="submit"] {
        background-color: #4CAF50;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    ul {
        list-style-type: none;
        padding: 0;
    }

    ul li {
        margin: 8px 0;
        padding: 8px;
        background-color: #f9f9f9;
        border-radius: 5px;
    }

    p.total {
        font-weight: bold;
        font-size: 18px;
        text-align: right;
    }

    .logout {
        display: block;
        text-align: center;
        margin-top: 20px;
        text-decoration: none;
        color: #333;
        font-weight: bold;
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
    <h2>Produtos Disponíveis</h2>
    <table>
        <tr>
            <th>Nome</th>
            <th>Preço</th>
            <th>Quantidade</th>
            <th>Ação</th>
        </tr>
        <%
        int i = 0;
        for (Produto p : produtos) {  // Agora pega os produtos do banco
        %>
        <tr>
            <td><%=p.getNome()%></td>
            <td>R$<%=String.format("%.2f", p.getPreco())%></td>
            <td><%=p.getQuantidade()%></td>
            <td>
                <form class="inline" action="compra" method="post">
                    <input type="hidden" name="acao" value="adicionar">
                    <input type="hidden" name="id" value="<%=p.getId()%>">
                    <input type="submit" value="Adicionar ao Carrinho">
                </form>
            </td>
        </tr>
        <%
            i++;
        }
        %>
    </table>

    <h2>Carrinho</h2>
    <ul>
        <%
        double total = 0;
        i = 0;
        for (Produto p : carrinho) {
            total += p.getPreco();
        %>
        <li>
            <%=p.getNome()%> - R$<%=String.format("%.2f", p.getPreco())%>
            <form class="inline" action="compra" method="post">
                <input type="hidden" name="acao" value="remover">
                <input type="hidden" name="id" value="<%=p.getId()%>">
                <input type="submit" value="Remover">
            </form>
        </li>
        <%
            i++;
        }
        %>
    </ul>

    <p class="total">Total: R$<%=String.format("%.2f", total)%></p>

    <form action="compra" method="post" style="text-align: center;">
        <input type="hidden" name="acao" value="notaFiscal">
        <input type="submit" value="Emitir Nota Fiscal">
    </form>

    <a class="logout" href="Login.jsp">Logout</a>
</div>
</body>
</html>
