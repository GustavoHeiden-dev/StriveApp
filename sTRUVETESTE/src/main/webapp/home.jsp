<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Modelos.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String primeiroNome = usuario.getNome().split(" ")[0];
%>s
<!DOCTYPE html>
<html>
<head>
    <title>Home - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --soft-purple-1: #9575cd;
            --soft-purple-2: #673ab7;
            --primary-purple: #6a1b9a;
            --light-purple: #8e24aa;
            --white-bg: #ffffff;
            --gray-text: #6c757d;
            --dark-text: #343a40;
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
            <h2>Resumo do Dia</h2>
            <p>Aqui você pode ver seu progresso, treinos e dicas para manter a motivação.</p>
        </div>

        <div class="card">
            <h2>Próximo Treino</h2>
            <p>Você não possui treinos agendados para hoje. Aproveite para descansar!</p>
        </div>

        <div class="card">
            <h2>Dica do Dia</h2>
            <p>💪 A disciplina é a ponte entre metas e realizações.</p>
        </div>
    </main>

    <nav>
        <a href="home.jsp">🏠 Home</a>
        <a href="workout.jsp">💪 Treino</a>
        <a href="progress.jsp">📊 Progresso</a>
        <a href="editarperfil.jsp">👤 Perfil</a>
    </nav>
</body>
</html>
