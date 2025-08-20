<%@ page import="modelos.Usuario,modelos.Produto,java.util.ArrayList"%>
<%@ page session="true"%>
<%
Usuario usuario = (Usuario) session.getAttribute("usuario");
ArrayList<Produto> carrinho = (ArrayList<Produto>) session.getAttribute("carrinho");
double total = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Nota Fiscal - Supermercado</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

    body {
        font-family: 'Roboto', sans-serif;
        background: linear-gradient(to right, #ffecd2, #fcb69f);
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        animation: backgroundAnim 10s ease infinite alternate;
    }

    @keyframes backgroundAnim {
        0% {background: linear-gradient(to right, #ffecd2, #fcb69f);}
        50% {background: linear-gradient(to right, #f6d365, #fda085);}
        100% {background: linear-gradient(to right, #ffecd2, #fcb69f);}
    }

    .nota-container {
        background: #fff;
        padding: 30px 40px;
        border-radius: 15px;
        box-shadow: 0 15px 30px rgba(0,0,0,0.3);
        width: 90%;
        max-width: 600px;
        text-align: center;
        animation: fadeIn 1s ease-out;
        position: relative;
    }

    @keyframes fadeIn {
        from {opacity: 0; transform: translateY(-20px);}
        to {opacity: 1; transform: translateY(0);}
    }

    h2 {
        color: #ff6f61;
        margin-bottom: 10px;
        font-size: 28px;
        position: relative;
    }

    h2::after {
        content: '';
        width: 60px;
        height: 4px;
        background-color: #ff6f61;
        display: block;
        margin: 10px auto 0;
        border-radius: 2px;
    }

    p {
        font-size: 18px;
        color: #555;
        margin: 8px 0;
    }

    hr {
        border: none;
        border-top: 2px dashed #ff6f61;
        margin: 20px 0;
    }

    ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    ul li {
        background: #ffe4e1;
        margin: 10px 0;
        padding: 10px 15px;
        border-radius: 10px;
        font-weight: bold;
        color: #333;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    ul li:hover {
        transform: translateX(5px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }

    .total {
        font-size: 22px;
        color: #ff6f61;
        font-weight: bold;
        margin-top: 20px;
        animation: pulse 1.5s infinite;
    }

    @keyframes pulse {
        0% {transform: scale(1);}
        50% {transform: scale(1.05);}
        100% {transform: scale(1);}
    }

    a.back {
        display: inline-block;
        margin-top: 25px;
        text-decoration: none;
        color: white;
        background-color: #ff6f61;
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: bold;
        transition: background 0.3s, transform 0.3s;
    }

    a.back:hover {
        background-color: #ff4b3e;
        transform: scale(1.05);
    }
</style>
</head>
<body>
    <div class="nota-container">
        <h2>Nota Fiscal</h2>
        <p><strong>Cliente:</strong> <%=usuario.getNome()%></p>
        <p><strong>CPF:</strong> <%=usuario.getCpf()%></p>
        <hr>
        <ul>
            <%
            for (Produto p : carrinho) {
                total += p.getPreco();
            %>
            <li>
                <span><%=p.getNome()%></span>
                <span>R$<%=String.format("%.2f", p.getPreco())%></span>
            </li>
            <%
            }
            %>
        </ul>
        <hr>
        <p class="total">Total: R$<%=String.format("%.2f", total)%></p>
        <a class="back" href="Compra.jsp">Voltar às Compras</a>
    </div>
</body>
</html>
