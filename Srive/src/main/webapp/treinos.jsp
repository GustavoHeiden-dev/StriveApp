<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Modelos.Usuario, java.util.List, Modelos.Treino, Modelos.Exercicio" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String primeiroNome = usuario.getNome().split(" ")[0];
    List<Treino> treinos = (List<Treino>) request.getAttribute("treinos");
    List<Exercicio> todosExercicios = (List<Exercicio>) request.getAttribute("todosExercicios");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Meus Treinos - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root { --primary-color: #6a0dad; --secondary-color: #8A2BE2; --dark-color: #1a1a1a; --light-color: #f8f7ff; --text-color: #333; --white-color: #fff; --sidebar-width: 250px; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--light-color); color: var(--text-color); }
        .dashboard-container { display: flex; }
        .sidebar { width: var(--sidebar-width); background-color: var(--white-color); height: 100vh; position: fixed; left: 0; top: 0; padding: 2rem 1rem; border-right: 1px solid #e0e0e0; display: none; }
        .sidebar .logo { font-size: 2rem; font-weight: 700; text-align: center; margin-bottom: 2.5rem; color: var(--primary-color); }
        .sidebar .nav-list { list-style: none; }
        .sidebar .nav-list a { display: flex; align-items: center; gap: 15px; color: #555; font-weight: 600; text-decoration: none; padding: 1rem; border-radius: 8px; margin-bottom: 0.5rem; transition: background-color 0.3s, color 0.3s; }
        .sidebar .nav-list a:hover, .sidebar .nav-list a.active { background-color: var(--primary-color); color: var(--white-color); }
        .sidebar .nav-list a .icon { width: 20px; text-align: center; }
        .main-content { flex: 1; padding: 2rem; padding-bottom: 100px; }
        .main-header h1 { font-size: 2.5rem; font-weight: 700; color: var(--dark-color); }
        .main-header p { color: #666; margin-bottom: 2rem; }
        .card { background: var(--white-color); border-radius: 12px; padding: 1.5rem; box-shadow: 0 4px 15px rgba(0,0,0,0.06); margin-bottom: 1.5rem; }
        .card h2 { margin-top: 0; margin-bottom: 1rem; color: var(--dark-color); }
        .btn { display: inline-block; background: var(--primary-color); color: var(--white-color); padding: 10px 20px; border: none; border-radius: 8px; font-weight: 600; text-decoration: none; transition: background-color 0.3s, transform 0.2s; cursor: pointer; }
        .btn:hover { background-color: var(--secondary-color); transform: translateY(-2px); }
        .form-grid { display: grid; gap: 1rem; grid-template-columns: 1fr; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 8px; font-weight: 600; color: #333; }
        .form-group input, .form-group textarea, .form-group select { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; font-family: 'Poppins', sans-serif; }
        .exercicio-checkbox-list { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; max-height: 200px; overflow-y: auto; border: 1px solid #ddd; padding: 1rem; border-radius: 8px; margin-top: 1rem; }
        .exercicio-checkbox-list label { display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .treinos-grid { display: grid; gap: 1.5rem; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); }
        .treino-card { background: var(--white-color); border-radius: 12px; padding: 1.5rem; box-shadow: 0 4px 15px rgba(0,0,0,0.06); display: flex; flex-direction: column; }
        .treino-card h3 { margin-top: 0; color: var(--primary-color); }
        .treino-card p { color: #555; flex-grow: 1; margin: 0.5rem 0 1rem 0; }
        .treino-info { display: flex; justify-content: space-between; font-size: 0.9rem; font-weight: 600; color: #777; border-top: 1px solid #eee; padding-top: 1rem; }
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
            <h1>Seus Treinos</h1>
            <p>Explore os treinos disponíveis ou crie uma nova rotina personalizada.</p>
        </div>

        <div class="card">
            <h2>Criar Novo Treino</h2>
            <form action="TreinoServlet" method="post">
                <input type="hidden" name="acao" value="criar">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="nome">Nome do Treino</label>
                        <input type="text" id="nome" name="nome" placeholder="Ex: Peito e Tríceps" required>
                    </div>
                    <div class="form-group">
                        <label for="nivel">Nível</label>
                        <select name="nivel" id="nivel" required>
                            <option value="" disabled selected>Selecione o Nível</option>
                            <option value="Iniciante">Iniciante</option>
                            <option value="Intermediário">Intermediário</option>
                            <option value="Avançado">Avançado</option>
                        </select>
                    </div>
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label for="descricao">Descrição</label>
                        <textarea name="descricao" id="descricao" placeholder="Uma breve descrição sobre o foco do treino" rows="3"></textarea>
                    </div>
                </div>

                <div class="form-group">
                    <label>Selecione os Exercícios para este Treino</label>
                    <div class="exercicio-checkbox-list">
                    <% if (todosExercicios != null && !todosExercicios.isEmpty()) { %>
                        <% for (Exercicio ex : todosExercicios) { %>
                            <label>
                                <input type="checkbox" name="exercicios" value="<%= ex.getId() %>">
                                <%= ex.getNome() %> <small>(<%= ex.getGrupoMuscular() %>)</small>
                            </label>
                        <% } %>
                    <% } else { %>
                        <p>Nenhum exercício cadastrado no sistema.</p>
                    <% } %>
                    </div>
                </div>
                
                <button type="submit" class="btn">Salvar Treino</button>
            </form>
        </div>

        <div class="card">
            <h2>Treinos Disponíveis</h2>
            <div class="treinos-grid">
                <% if (treinos != null && !treinos.isEmpty()) { %>
                    <% for (Treino t : treinos) { %>
                        <div class="treino-card">
                            <h3><%= t.getNome() %></h3>
                            <p><%= t.getDescricao() %></p>
                            <div class="treino-info">
                                <span><i class="fas fa-layer-group"></i> <%= t.getNivel() %></span>
                                <!-- A duração será mostrada no histórico de sessões -->
                            </div>
                            <a href="TreinoDetalheServlet?idTreino=<%= t.getId() %>" class="btn">Iniciar Treino</a>
                        </div>
                    <% } %>
                <% } else { %>
                    <p>Você ainda não possui treinos cadastrados. Crie um acima!</p>
                <% } %>
            </div>
        </div>
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