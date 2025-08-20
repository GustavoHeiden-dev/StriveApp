<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Supermercado</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #74ebd5, #ACB6E5);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.3);
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        input[type="checkbox"] {
            margin-top: 15px;
        }

        input[type="submit"] {
            width: 95%;
            padding: 10px;
            margin-top: 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        p.erro {
            color: red;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Identificação</h2>
        <form action="login" method="post">
            Nome: <br><input type="text" name="nome" required><br>
            CPF: <br><input type="text" name="cpf" required><br>
            Admin: <input type="checkbox" name="admin"><br>
            <input type="submit" value="Entrar">
        </form>
        <%
        if (request.getAttribute("erro") != null) {
        %>
            <p class="erro"><%=request.getAttribute("erro")%></p>
        <%
        }
        %>
    </div>
</body>
</html>
