<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #6a0dad;
            --secondary-color: #8A2BE2;
            --dark-color: #1a1a1a;
            --light-color: #f8f7ff;
            --text-color: #333;
            --white-color: #fff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-color);
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Painel da Esquerda (Imagem) */
        .image-panel {
            flex: 1;
    		background: url('imagens/imagemFundoCad.jpg') center center/cover;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 50px;
            color: var(--white-color); 
            
        }

        .image-panel h1 {
            font-size: 3.5rem;
            margin: 0;
            font-weight: 700;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7);
        }

        .image-panel p {
            font-size: 1.2rem;
            max-width: 400px;
            font-weight: 300;
        }

     
        .form-panel {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            overflow-y: auto;
        }

        .form-container {
            width: 100%;
            max-width: 450px;
        }

        .form-container h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 10px;
        }

        .form-container .subtitle {
            color: #666;
            margin-bottom: 30px;
        }

        .input-wrapper {
            position: relative;
            margin-bottom: 20px;
        }

        .input-wrapper .icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }

        .form-input, .form-select {
            width: 100%;
            padding: 14px 14px 14px 45px; 
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 8px rgba(106, 29, 173, 0.2);
        }

        .input-group {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            margin-top: 15px;
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

       
        @media (max-width: 900px) {
            .container {
                flex-direction: column;
            }

            .image-panel {
                flex: none;
                height: 25vh;
                justify-content: center;
                text-align: center;
                padding: 20px;
            }
            .image-panel h1 { font-size: 2.5rem; }
            .image-panel p { display: none; }

            .form-panel {
                padding: 30px 20px;
            }
            
            .form-container h2 { font-size: 2rem; }
        }

       
        .error-box {
            display: flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, #ff4e50, #f9d423);
            color: #fff;
            padding: 15px 20px;
            border-radius: 10px;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            margin-bottom: 20px;
            animation: fadeIn 0.5s ease, pulse 2s infinite;
        }

        .error-box i {
            font-size: 1.5rem;
            color: #fff;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 78, 80, 0.6); }
            70% { box-shadow: 0 0 0 12px rgba(255, 78, 80, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 78, 80, 0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="image-panel">
            <div>
                <h1>STRIVE</h1>
                <p>Sua jornada para uma vida mais forte e saudável começa aqui.</p>
            </div>
        </div>
        <div class="form-panel">
            <div class="form-container">
                <h2>Crie sua conta</h2>
                <p class="subtitle">Comece sua jornada fitness hoje. É rápido e fácil!</p>

                <%-- Mensagem de erro dinâmica --%>
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <div class="error-box">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span><%= errorMessage %></span>
                    </div>
                <%
                    }
                %>

                <form method="post" action="CadastroServlet">
                    <div class="input-wrapper">
                        <i class="fa-solid fa-user icon"></i>
                        <input type="text" id="nome" name="nome" class="form-input" placeholder="Nome Completo" required>
                    </div>

                    <div class="input-wrapper">
                        <i class="fa-solid fa-envelope icon"></i>
                        <input type="email" id="email" name="email" class="form-input" placeholder="Seu email" required>
                    </div>

                    <div class="input-wrapper">
                         <i class="fa-solid fa-lock icon"></i>
                        <input type="password" id="senha" name="senha" class="form-input" placeholder="Crie uma senha forte" required>
                    </div>

                    <div class="input-group">
                        <input type="number" id="idade" name="idade" class="form-input" placeholder="Idade" required style="padding-left: 14px;">
                        <input type="number" step="0.1" id="pesoInicial" name="pesoInicial" class="form-input" placeholder="Peso (kg)" required style="padding-left: 14px;">
                        <input type="number" step="0.01" id="altura" name="altura" class="form-input" placeholder="Altura (m)" required style="padding-left: 14px;">
                    </div>

                    <select id="nivelInicial" name="nivelInicial" class="form-select" required style="margin-top: 20px; padding-left: 14px;">
                        <option value="" disabled selected>Selecione seu nível de experiência</option>
                        <option value="Iniciante">Iniciante</option>
                        <option value="Intermediario">Intermediário</option>
                        <option value="Avançado">Avançado</option>
                    </select>

                    <button type="submit" class="btn-submit">Criar Conta</button>
                </form>

                <p class="login-link">
                    Já tem uma conta? <a href="login.jsp">Faça o login</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
