<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <title>Recuperar Senha - Strive</title>
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
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Recuperar Senha</h2>
        <p class="subtitle">Digite seu e-mail para enviarmos um link de redefinição.</p>
        
        <form method="post" action="EsqueciSenhaServlet">
            <div class="input-wrapper">
                <i class="fa-solid fa-envelope icon"></i>
                <input type="email" id="email" name="email" class="form-input" placeholder="Seu email" required>
            </div>
            <button type="submit" class="btn-submit">Enviar Link</button>
        </form>

        <p class="login-link">
            Lembrou da senha? <a href="login.jsp">Voltar para o Login</a>
        </p>
    </div>
</body>
</html>