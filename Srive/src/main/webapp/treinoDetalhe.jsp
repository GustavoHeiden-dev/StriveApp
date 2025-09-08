<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Modelos.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelos.Exercicio" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Exercicio> exercicios = (List<Exercicio>) request.getAttribute("exercicios");
    int idTreino = (Integer) request.getAttribute("idTreino");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Executando Treino - Strive</title>
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
            --sidebar-width: 250px;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--light-color); color: var(--text-color); }
        .dashboard-container { display: flex; }
        .sidebar { width: var(--sidebar-width); background-color: var(--white-color); height: 100vh; position: fixed; left: 0; top: 0; padding: 2rem 1rem; border-right: 1px solid #e0e0e0; display: none; }
        .sidebar .logo { font-size: 2rem; font-weight: 700; text-align: center; margin-bottom: 2.5rem; color: var(--primary-color); }
        .sidebar .nav-list { list-style: none; }
        .sidebar .nav-list a { display: flex; align-items: center; gap: 15px; color: #555; font-weight: 600; text-decoration: none; padding: 1rem; border-radius: 8px; margin-bottom: 0.5rem; }
        .sidebar .nav-list a:hover, .sidebar .nav-list a.active { background-color: var(--primary-color); color: var(--white-color); }
        .sidebar .nav-list a .icon { width: 20px; text-align: center; }
        .main-content { flex: 1; padding: 2rem; padding-bottom: 100px; }
        .main-header h1 { font-size: 2.5rem; font-weight: 700; color: var(--dark-color); }
        .main-header p { color: #666; margin-bottom: 2rem; }
        .exercicio-card { background: var(--white-color); border-radius: 12px; padding: 1.5rem; box-shadow: 0 4px 15px rgba(0,0,0,0.06); margin-bottom: 1.5rem; }
        .exercicio-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem; }
        .exercicio-header h3 { margin: 0; color: var(--primary-color); }
        .grupo-muscular { background: var(--secondary-color); color: white; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .exercicio-details p { margin: 0.5rem 0; color: #555; }
        .exercicio-form { margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid #eee; }
        .form-row { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; align-items: flex-end; }
        .form-group input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; font-family: 'Poppins', sans-serif; }
        .btn { display: inline-block; background: var(--primary-color); color: var(--white-color); padding: 10px 20px; border: none; border-radius: 8px; font-weight: 600; text-decoration: none; transition: background-color 0.3s; cursor: pointer; }
        .btn:hover { background-color: var(--secondary-color); }
        .btn.btn-sm { padding: 8px 15px; font-size: 0.9rem; }
        .bottom-nav { display: flex; justify-content: space-around; padding: 0.8rem 0; background-color: var(--white-color); box-shadow: 0 -2px 10px rgba(0,0,0,0.1); position: fixed; bottom: 0; left: 0; width: 100%; z-index: 100; }
        .bottom-nav a { display: flex; flex-direction: column; align-items: center; text-decoration: none; color: #888; font-size: 0.7rem; gap: 4px; }
        .bottom-nav a .icon { font-size: 1.4rem; }
        .bottom-nav a.active, .bottom-nav a:hover { color: var(--primary-color); }
        @media(min-width: 992px) { .sidebar { display: block; } .main-content { margin-left: var(--sidebar-width); } .main-header h1 { font-size: 3rem; } .bottom-nav { display: none; } }
    </style>
</head>
<body>
<div class="dashboard-container">
    <aside class="sidebar">
        <div class="logo">STRIVE</div>
        <ul class="nav-list">
            <li><a href="home.jsp"><i class="fas fa-home icon"></i> Home</a></li>
            <li><a href="TreinoServlet" class="active"><i class="fas fa-dumbbell icon"></i> Treino</a></li>
            <li><a href="progress.jsp"><i class="fas fa-chart-line icon"></i> Progresso</a></li>
            <li><a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <div class="main-header">
            <h1>Executando Treino</h1>
            <p>Complete os exercícios abaixo e registre seu progresso.</p>
        </div>

        <% if (exercicios != null && !exercicios.isEmpty()) { %>
            <% for (Exercicio ex : exercicios) { %>
                <div class="exercicio-card">
                    <div class="exercicio-header">
                        <h3><%= ex.getNome() %></h3>
                        <span class="grupo-muscular"><%= ex.getGrupoMuscular() %></span>
                    </div>
                    <div class="exercicio-details">
                        <p><strong>Descrição:</strong> <%= ex.getDescricao() %></p>
                        <p><strong>Meta:</strong> <%= ex.getRepeticoes() %> @ <%= (ex.getPeso() != null ? ex.getPeso() + "kg" : "Peso corporal") %></p>
                    </div>
                    <form class="exercicio-form" action="MarcarExercicioServlet" method="post">
                        <input type="hidden" name="idExercicio" value="<%= ex.getId() %>">
                        <input type="hidden" name="idTreino" value="<%= idTreino %>">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="repeticoesFeitas_<%= ex.getId() %>">Repetições Feitas:</label>
                                <input type="text" name="repeticoesFeitas" id="repeticoesFeitas_<%= ex.getId() %>" placeholder="Ex: 3x12" required>
                            </div>
                            <div class="form-group">
                                <label for="pesoUsado_<%= ex.getId() %>">Peso Usado (kg):</label>
                                <input type="number" step="0.5" name="pesoUsado" id="pesoUsado_<%= ex.getId() %>" placeholder="Ex: 80.5">
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn">Concluir Exercício</button>
                            </div>
                        </div>
                    </form>
                </div>
            <% } %>
        <% } else { %>
            <div class="card">
                <h2>Nenhum Exercício</h2>
                <p>Este treino ainda não possui exercícios cadastrados.</p>
            </div>
        <% } %>
        <a href="TreinoServlet" class="btn">Voltar para a Lista de Treinos</a>
    </main>

    <nav class="bottom-nav">
        <a href="home.jsp"><i class="fas fa-home icon"></i> Home</a>
        <a href="TreinoServlet" class="active"><i class="fas fa-dumbbell icon"></i> Treino</a>
        <a href="progress.jsp"><i class="fas fa-chart-line icon"></i> Progresso</a>
        <a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a>
    </nav>
</div>
</body>
</html>