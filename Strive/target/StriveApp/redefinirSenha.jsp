<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String token = request.getParameter("token");
    if (token == null || token.isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <title>Redefinir Senha - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --primary-color: #6a0dad;
            --secondary-color: #8A2BE2;
            --dark-color: #1a1a1a;
            --light-color: #f8f7ff;
            --text-color: #333;
            --white-color: #fff;
            --error-color: #dc3545;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        .form-container {
            width: 100%;
            max-width: 450px;
            background: var(--white-color);
            padding: 3rem;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .form-container h2 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 10px;
            text-align: center;
        }
        .form-container .subtitle {
            color: #666;
            margin-bottom: 30px;
            text-align: center;
        }
        .input-wrapper { position: relative; margin-bottom: 20px; }
        .input-wrapper .icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }
        .form-input {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 8px rgba(106, 29, 173, 0.2);
        }
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: transform 0.2s, background-color 0.3s;
        }
        .btn-submit:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }
        .login-link {
            margin-top: 25px;
            display: block;
            text-align: center;
            color: #555;
        }
        .login-link a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }
        .message-box {
            padding: 15px 20px;
            border-radius: 10px;
            font-weight: 500;
            font-size: 0.95rem;
            margin-bottom: 20px;
            text-align: center;
        }
        .message-box.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Criar Nova Senha</h2>
        <p class="subtitle">Digite sua nova senha abaixo.</p>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message-box error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form method="post" action="RedefinirSenhaServlet" onsubmit="return validarSenha();">
            
            <input type="hidden" name="token" value="<%= token %>">
            
            <div class="input-wrapper">
                <i class="fa-solid fa-lock icon"></i>
                <input type="password" id="novaSenha" name="novaSenha" class="form-input" placeholder="Nova Senha" required>
            </div>
            <div class="input-wrapper">
                <i class="fa-solid fa-lock icon"></i>
                <input type="password" id="confirmarSenha" name="confirmarSenha" class="form-input" placeholder="Confirmar Nova Senha" required>
            </div>
            
            <button type="submit" class="btn-submit">Salvar Nova Senha</button>
        </form>

        <p class="login-link">
            <a href="login.jsp">Voltar para o Login</a>
        </p>
    </div>

    <script>
        function validarSenha() {
            var novaSenha = document.getElementById('novaSenha').value;
            var confirmarSenha = document.getElementById('confirmarSenha').value;

            if (novaSenha !== confirmarSenha) {
                alert("As senhas não coincidem. Por favor, digite novamente.");
                return false;
            }
            
            if (novaSenha.length < 6) {
                alert("A senha deve ter pelo menos 6 caracteres.");
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>