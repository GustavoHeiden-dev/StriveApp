<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro - Strive</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        .register-container {
            display: flex;
            height: 100vh;
        }
        .info-panel {
            flex: 1;
            background: url('https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=2070&auto=format&fit=crop') center center/cover;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 50px;
            color: white;
            position: relative;
        }
        .info-panel::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to top, rgba(0,0,0,0.8), rgba(0,0,0,0.1));
        }
        .info-panel h1, .info-panel p {
            position: relative;
            z-index: 2;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7);
        }
        .info-panel h1 {
            font-size: 3.5rem;
            margin: 0;
            font-weight: 700;
        }
        .info-panel p {
            font-size: 1.2rem;
            max-width: 400px;
        }
        .form-panel {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f4f7f6;
            overflow-y: auto;
            padding: 40px 0;
        }
        .form-container {
            width: 100%;
            max-width: 450px;
            padding: 20px;
        }
        .form-container h2 {
            font-size: 2.2rem;
            color: #333;
            margin-bottom: 10px;
        }
        .form-container p {
            color: #666;
            margin-bottom: 30px;
        }
        .input-label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 600;
        }
        .form-input, .form-select {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
            box-sizing: border-box;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #8e24aa;
            box-shadow: 0 0 5px rgba(142, 36, 170, 0.5);
        }
        .input-group {
            display: flex;
            gap: 20px;
        }
        .input-group > div {
            flex: 1;
        }
        .btn {
            width: 100%;
            padding: 15px;
            margin-top: 15px;
            background: linear-gradient(to right, #6a1b9a, #8e24aa);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.3s;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .login-link {
            margin-top: 20px;
            display: block;
            text-align: center;
            color: #555;
            text-decoration: none;
        }
        .login-link a {
            color: #8e24aa;
            font-weight: 600;
            text-decoration: none;
        }
        @media (max-width: 900px) {
            .info-panel {
                display: none;
            }
            .form-panel {
                flex-basis: 100%;
                padding: 20px 0;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="info-panel">
            <h1>STRIVE</h1>
            <p>Sua jornada para uma vida mais forte e saudável começa aqui.</p>
        </div>
        <div class="form-panel">
            <div class="form-container">
                <h2>Crie sua conta</h2>
                <p>Comece sua jornada fitness hoje mesmo. É rápido e fácil!</p>
                <form method="post" action="CadastroServlet">
                    <label for="nome" class="input-label">Nome Completo</label>
                    <input type="text" id="nome" name="nome" class="form-input" required>
                    <label for="email" class="input-label">Email</label>
                    <input type="email" id="email" name="email" class="form-input" required>
                    <label for="senha" class="input-label">Senha</label>
                    <input type="password" id="senha" name="senha" class="form-input" required>
                    <div class="input-group">
                        <div>
                            <label for="idade" class="input-label">Idade</label>
                            <input type="number" id="idade" name="idade" class="form-input" required>
                        </div>
                        <div>
                            <label for="pesoInicial" class="input-label">Peso (kg)</label>
                            <input type="number" step="0.1" id="pesoInicial" name="pesoInicial" class="form-input" required>
                        </div>
                        <div>
                            <label for="altura" class="input-label">Altura (m)</label>
                            <input type="number" step="0.01" id="altura" name="altura" class="form-input" required>
                        </div>
                    </div>
                    <label for="nivelInicial" class="input-label">Seu nível de experiência</label>
                    <select id="nivelInicial" name="nivelInicial" class="form-select" required>
                        <option value="" disabled selected>Selecione seu nível</option>
                        <option value="Iniciante">Iniciante</option>
                        <option value="Intermediario">Intermediário</option>
                        <option value="Avançado">Avançado</option>
                    </select>
                    <button type="submit" class="btn">Criar Conta</button>
                </form>
                <p class="login-link">
                    Já tem uma conta? <a href="login.jsp">Faça o login</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>
