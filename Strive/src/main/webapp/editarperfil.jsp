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
    <title>Editar Perfil - Strive</title>
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
            --success-bg: #e9f7ef;
            --success-text: #2b6447;
            --warning-bg: #fff8e1;
            --warning-text: #6d4c0d;
            --sidebar-width: 250px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-color);
        }

        .dashboard-container { display: flex; }

        /* --- Barra Lateral (Desktop) --- */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--white-color);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 2rem 1rem;
            border-right: 1px solid #e0e0e0;
            display: none;
        }
        .sidebar .logo { font-size: 2rem; font-weight: 700; text-align: center; margin-bottom: 2.5rem; color: var(--primary-color); }
        .sidebar .nav-list { list-style: none; }
        .sidebar .nav-list a { display: flex; align-items: center; gap: 15px; color: #555; font-weight: 600; text-decoration: none; padding: 1rem; border-radius: 8px; margin-bottom: 0.5rem; transition: background-color 0.3s, color 0.3s; }
        .sidebar .nav-list a:hover, .sidebar .nav-list a.active { background-color: var(--primary-color); color: var(--white-color); }
        .sidebar .nav-list a .icon { width: 20px; text-align: center; }

        /* --- Conteúdo Principal --- */
        .main-content {
            flex: 1;
            padding: 2rem;
            padding-bottom: 100px;
        }
        .main-header h1 { font-size: 2.5rem; font-weight: 700; color: var(--dark-color); }
        .main-header p { color: #666; margin-bottom: 2rem; }

        /* --- Card de Perfil e Formulário --- */
        .profile-card {
            background: var(--white-color);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }
        .profile-header {
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #eee;
        }
        .profile-header-info h2 { margin: 0 0 5px 0; }
        .profile-header-info p { margin: 0; color: #777; }

        .form-grid {
            display: grid;
            gap: 1.5rem 2rem;
        }
        
        .form-group { display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 8px; font-weight: 600; color: #333; }
        .form-group input, .form-group select {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 8px rgba(106, 29, 173, 0.2);
        }

        .btn-submit {
            background: var(--primary-color);
            color: var(--white-color);
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            margin-top: 2rem; 
        }
        .btn-submit:hover { background-color: var(--secondary-color); transform: translateY(-2px); }

        .success-message {
            background-color: var(--success-bg);
            color: var(--success-text);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            text-align: center;
            font-weight: 600;
        }

        .warning-message {
            background-color: var(--warning-bg);
            color: var(--warning-text);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 2rem;
            border: 1px solid #ffe58f;
        }

        /* --- Barra de Navegação Inferior (Mobile) --- */
        .bottom-nav { display: flex; justify-content: space-around; padding: 0.8rem 0; background-color: var(--white-color); box-shadow: 0 -2px 10px rgba(0,0,0,0.1); position: fixed; bottom: 0; left: 0; width: 100%; z-index: 100; }
        .bottom-nav a { display: flex; flex-direction: column; align-items: center; text-decoration: none; color: #888; font-size: 0.7rem; gap: 4px; transition: color 0.3s; }
        .bottom-nav a .icon { font-size: 1.4rem; }
        .bottom-nav a.active, .bottom-nav a:hover { color: var(--primary-color); }

        /* --- Media Queries --- */
        @media(min-width: 768px) {
            .form-grid { grid-template-columns: 1fr 1fr; }
        }
        @media(min-width: 992px) {
            .sidebar { display: block; }
            .main-content { margin-left: var(--sidebar-width); padding: 2.5rem; padding-bottom: 2.5rem; }
            .main-header h1 { font-size: 3rem; }
            .bottom-nav { display: none; }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="logo">STRIVE</div>
            <ul class="nav-list">
                <li><a href="home.jsp"><i class="fas fa-home icon"></i> Home</a></li>
                <li><a href="workout.jsp"><i class="fas fa-dumbbell icon"></i> Treino</a></li>
                <li><a href="progress.jsp"><i class="fas fa-chart-line icon"></i> Progresso</a></li>
                <li><a href="editarperfil.jsp" class="active"><i class="fas fa-user icon"></i> Perfil</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <div class="main-header">
                <h1>Seu Perfil</h1>
                <p>Mantenha seus dados sempre atualizados.</p>
            </div>
            
            <div class="profile-card">
                <% if ("true".equals(request.getParameter("success"))) { %>
                    <div class="success-message">Perfil atualizado com sucesso!</div>
                <% } %>

                <div class="profile-header">
                   <div class="profile-header-info">
                        <h2><%= usuario.getNome() %></h2>
                        <p>Altere suas informações abaixo</p>
                    </div>
                </div>

                <form action="PerfilServlet" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nome">Nome Completo</label>
                            <input type="text" id="nome" name="nome" value="<%= usuario.getNome() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="<%= usuario.getEmail() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="idade">Idade</label>
                            <input type="number" id="idade" name="idade" value="<%= usuario.getIdade() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="pesoInicial">Peso (kg)</label>
                            <input type="number" step="0.1" id="pesoInicial" name="pesoInicial" value="<%= usuario.getPesoInicial() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="altura">Altura (m)</label>
                            <input type="number" step="0.01" id="altura" name="altura" value="<%= usuario.getAltura() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="nivelInicial">Nível de Experiência</label>
                            <select id="nivelInicial" name="nivelInicial" required>
                                <option value="Iniciante" <%= "Iniciante".equals(usuario.getNivelInicial()) ? "selected" : "" %>>Iniciante</option>
                                <option value="Intermediário" <%= "Intermediário".equals(usuario.getNivelInicial()) ? "selected" : "" %>>Intermediário</option>
                                <option value="Avançado" <%= "Avançado".equals(usuario.getNivelInicial()) ? "selected" : "" %>>Avançado</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="senha">Senha</label>
                            <input type="password" id="senha" name="senha" required>
                        </div>
                    </div>
                    <button type="submit" class="btn-submit">Salvar Alterações</button>
                    <div class="warning-message">
                        <strong>Atenção:</strong> Por favor, insira sua senha atual ou uma nova senha para poder salvar as alterações.
                    </div>
                </form>
            </div>
        </main>

        <nav class="bottom-nav">
            <a href="home.jsp"><i class="fas fa-home icon"></i> Home</a>
            <a href="workout.jsp"><i class="fas fa-dumbbell icon"></i> Treino</a>
            <a href="progress.jsp"><i class="fas fa-chart-line icon"></i> Progresso</a>
            <a href="editarperfil.jsp" class="active"><i class="fas fa-user icon"></i> Perfil</a>
        </nav>
    </div>
</body>
</html>