<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Modelos.Usuario" %>
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
    <title>Dashboard - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --primary-color: #6a0dad;
            --secondary-color: #8A2BE2;
            --bg-light: #f9f9fb;
            --bg-card: #ffffff;
            --text-dark: #333;
            --text-muted: #666;
            --sidebar-width: 250px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
        }

        .dashboard-container {
            display: flex;
        }

        .sidebar {
            width: var(--sidebar-width);
            background-color: #f0f0f5;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 2rem 1rem;
            border-right: 1px solid #ddd;
            display: none;
        }

        .sidebar .logo {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 2.5rem;
            color: var(--primary-color);
        }

        .sidebar .nav-list {
            list-style: none;
        }

        .sidebar .nav-list a {
            display: flex;
            align-items: center;
            gap: 15px;
            color: var(--text-muted);
            font-weight: 600;
            text-decoration: none;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            transition: background-color 0.3s, color 0.3s;
        }

        .sidebar .nav-list a:hover,
        .sidebar .nav-list a.active {
            background-color: var(--primary-color);
            color: #fff;
        }

        .sidebar .nav-list a .icon {
            width: 20px;
            text-align: center;
        }

        .main-content {
            flex: 1;
            padding: 2rem;
            padding-bottom: 100px;
        }

        .main-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-dark);
        }

        .main-header h1 span {
            color: var(--primary-color);
        }

        .main-header p {
            color: var(--text-muted);
            margin-bottom: 2rem;
        }

        .cards-grid {
            display: grid;
            gap: 1.5rem;
            grid-template-columns: 1fr;
        }

        .card {
            background: var(--bg-card);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
        }

        .card .card-icon {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            color: var(--secondary-color);
        }

        .card h2 {
            margin: 0 0 0.5rem 0;
            color: var(--text-dark);
            font-size: 1.3rem;
        }

        .card p {
            color: var(--text-muted);
            flex-grow: 1;
        }

        .card .btn {
            background: var(--primary-color);
            color: #fff;
            padding: 10px 15px;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            margin-top: 1rem;
            align-self: flex-start;
            transition: background-color 0.3s;
        }

        .card .btn:hover {
            background-color: var(--secondary-color);
        }

        .bottom-nav {
            display: flex;
            justify-content: space-around;
            padding: 0.8rem 0;
            background-color: #f0f0f5;
            border-top: 1px solid #ddd;
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            z-index: 100;
        }

        .bottom-nav a {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--text-muted);
            font-size: 0.7rem;
            gap: 4px;
            transition: color 0.3s;
            flex-basis: 0;
            flex-grow: 1;
            text-align: center;
        }

        .bottom-nav a .icon {
            font-size: 1.4rem;
        }

        .bottom-nav a.active,
        .bottom-nav a:hover {
            color: var(--primary-color);
        }

        @media(min-width: 992px) {
            .sidebar {
                display: block;
            }
            .main-content {
                margin-left: var(--sidebar-width);
                padding: 2.5rem;
                padding-bottom: 2.5rem;
            }
            .main-header h1 { font-size: 3rem; }
            .main-header p { font-size: 1.1rem; }

            .cards-grid {
                /* Ajuste para 2 colunas fixas no desktop */
                grid-template-columns: 1fr 1fr;
            }
            .bottom-nav {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        
        <aside class="sidebar">
            <div class="logo">STRIVE</div>
            <ul class="nav-list">
                <li><a href="home.jsp" class="active"><i class="fas fa-home icon"></i> Home</a></li>
                <li><a href="TreinoServlet" ><i class="fas fa-dumbbell icon"></i> Treino</a></li>
                <li><a href="PerfilServlet"><i class="fas fa-user icon"></i> Perfil</a></li>
                <li class="logout-link"><a href="SairServlet"><i class="fas fa-sign-out-alt icon"></i> Sair</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <div class="main-header">
                <div>
	                <h1>Bem-vindo, <span><%= primeiroNome %></span></h1>
					<p>
						Hoje é
						<%=java.time.LocalDate.now().getDayOfWeek().getDisplayName(java.time.format.TextStyle.FULL,
			new java.util.Locale("pt", "BR"))%>,
						<%=java.time.LocalDate.now().getDayOfMonth()%>
						de
						<%=java.time.LocalDate.now().getMonth().getDisplayName(java.time.format.TextStyle.FULL,
			new java.util.Locale("pt", "BR"))%>
						de
						<%=java.time.LocalDate.now().getYear()%>. Um ótimo dia para
						treinar!
					</p>
                </div>
			</div>
            
            <div class="cards-grid">
                
                <div class="card">
                    <div class="card-icon"><i class="fas fa-lightbulb"></i></div>
                    <h2>Dica do Dia</h2>
                    <p>💪 A disciplina é a ponte entre metas e realizações. Mantenha o foco!</p>
                </div>
                
                <div class="card">
                    <div class="card-icon"><i class="fas fa-calendar-check"></i></div>
                    <h2>Próximo Treino</h2>
                    <p>Você não possui treinos agendados para hoje. Aproveite para descansar ou explore novos exercícios!</p>
                    <a href="TreinoServlet" class="btn">Ver Treinos</a>
                </div>

                <div class="card">
                    <div class="card-icon"><i class="fas fa-chart-line"></i></div>
                    <h2>Meu Progresso</h2>
                    <p>Acompanhe sua evolução de peso, medidas e recordes pessoais.</p>
                    <a href="ProgressoServlet" class="btn">Ver Progresso</a>
                </div>

                <div class="card">
                    <div class="card-icon"><i class="fas fa-trophy"></i></div>
                    <h2>Minhas Conquistas</h2>
                    <p>Veja todas as medalhas e troféus que você ganhou na sua jornada.</p>
                    <a href="ConquistasServlet" class="btn">Ver Conquistas</a>
                </div>
                
            </div>
        </main>

        <nav class="bottom-nav">
            <a href="home.jsp" class="active"><i class="fas fa-home icon"></i> Home</a>
           	<a href="TreinoServlet"><i class="fas fa-dumbbell icon"></i> Treino</a>
            <a href="PerfilServlet"><i class="fas fa-user icon"></i> Perfil</a>
            <a href="SairServlet"><i class="fas fa-sign-out-alt icon"></i> Sair</a>
        </nav>

    </div>
</body>
</html>