<%@ page import="Modelos.Usuario" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String primeiroNome = usuario.getNome().split(" ")[0];
%>
<!DOCTYPE html>
<html>
<head>
    <title>Perfil - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* (Your existing CSS styles) */
        :root {
            --soft-purple-1: #9575cd;
            --soft-purple-2: #673ab7;
            --primary-purple: #6a1b9a;
            --light-purple: #8e24aa;
            --white-bg: #ffffff;
            --gray-text: #6c757d;
            --dark-text: #343a40;
            --success-green: #28a745;
        }
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f7f6;
        }
        header {
            background: linear-gradient(135deg, var(--soft-purple-1), var(--soft-purple-2));
            color: white;
            padding: 1rem;
            text-align: center;
        }
        main {
            padding: 1.5rem;
            max-width: 900px;
            margin: auto;
        }
        .card {
            background: var(--white-bg);
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
	        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }
        .card h2 {
            margin-top: 0;
            color: var(--primary-purple);
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        label {
            font-weight: 600;
            color: var(--dark-text);
        }
        input, select {
            padding: 0.75rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-family: 'Poppins', sans-serif;
        }
        button {
            background-color: var(--primary-purple);
            color: white;
            padding: 1rem;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: var(--light-purple);
        }
        .success-message {
            background-color: var(--success-green);
            color: white;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            text-align: center;
        }
        nav {
            display: flex;
            justify-content: space-around;
            padding: 0.8rem;
            background-color: var(--white-bg);
            border-top: 1px solid #ddd;
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
        }
        nav a {
            text-decoration: none;
            color: var(--gray-text);
            font-weight: 600;
        }
        nav a:hover {
            color: var(--primary-purple);
            
        }
        @media(min-width: 768px) {
            nav {
                position: static;
                border-top: none;
                justify-content: flex-start;
                gap: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Bem-vindo, <%= primeiroNome %> </h1>
    </header>

    <main>
        <div class="card">
            <h2>Seu Perfil</h2>
            <%
                if ("true".equals(request.getParameter("success"))) {
            %>
            <div class="success-message">Perfil atualizado com sucesso!</div>
            <%
                }
            %>
            <form action="PerfilServlet" method="post">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" value="<%= usuario.getNome() %>" required>

                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= usuario.getEmail() %>" required>

                <label for="senha">Senha:</label>
                <input type="password" id="senha" name="senha" value="<%= usuario.getSenha() %>" required>

                <label for="idade">Idade:</label>
                <input type="number" id="idade" name="idade" value="<%= usuario.getIdade() %>" required>

                <label for="pesoInicial">Peso (kg):</label>
                <input type="number" step="0.1" id="pesoInicial" name="pesoInicial" value="<%= usuario.getPesoInicial() %>" required>

                <label for="altura">Altura (m):</label>
                <input type="number" step="0.01" id="altura" name="altura" value="<%= usuario.getAltura() %>" required>

                <label for="nivelInicial">Nível Inicial:</label>
                <select id="nivelInicial" name="nivelInicial" required>
                    <option value="Iniciante" <%= "Iniciante".equals(usuario.getNivelInicial()) ? "selected" : "" %>>Iniciante</option>
                    <option value="Intermediário" <%= "Intermediário".equals(usuario.getNivelInicial()) ? "selected" : "" %>>Intermediário</option>
                    <option value="Avançado" <%= "Avançado".equals(usuario.getNivelInicial()) ? "selected" : "" %>>Avançado</option>
                </select>

                <button type="submit">Salvar Alterações</button>
            </form>
        </div>
    </main>

    <nav>
        <a href="home.jsp">🏠 Home</a>
        <a href="workout.jsp">💪 Treino</a>
        <a href="progress.jsp">📊 Progresso</a>
        <a href="profile.jsp">👤 Perfil</a>
    </nav>
</body>
</html>