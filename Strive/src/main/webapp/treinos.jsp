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
<html lang="pt-BR">
<head>
    <title>Meus Treinos - Strive</title>
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
            --bg-sidebar: #f0f0f5;
            --text-dark: #333;
            --text-muted: #666;
            --border-color: #e0e0e0;
            --sidebar-width: 250px;
            --border-radius: 12px;
            --shadow: 0 4px 15px rgba(0,0,0,0.1);
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

        .dashboard-container { display: flex; }

        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--bg-sidebar);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 2rem 1rem;
            border-right: 1px solid #ddd;
            display: none;
            z-index: 1100;
        }

        .sidebar .logo {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 2.5rem;
            color: var(--primary-color);
        }

        .sidebar .nav-list { list-style: none; }

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

        .sidebar .nav-list a:hover, .sidebar .nav-list a.active {
            background-color: var(--primary-color);
            color: #fff;
        }

        .sidebar .nav-list a .icon {
            font-size: 1rem; 
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

        .main-header p {
            color: var(--text-muted);
            margin-bottom: 2rem;
        }

        .card {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .card h2 {
            margin-top: 0;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
            font-size: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
        }

        .btn {
            display: inline-block;
            background: var(--primary-color);
            color: #fff;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            text-align: center;
            transition: background-color 0.3s, transform 0.2s;
            cursor: pointer;
        }

        .btn:hover {
            background-color: var(--secondary-color);
            transform: translateY(-3px);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }

        .btn-outline:hover {
            background-color: var(--primary-color);
            color: #fff;
        }

        .form-grid { display: grid; gap: 1.5rem; grid-template-columns: 1fr 1fr; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { margin-bottom: 8px; font-weight: 600; color: var(--text-dark); }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
        }
        .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(106, 13, 173, 0.15);
        }

        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.6); display: none; align-items: center; justify-content: center; z-index: 1000; backdrop-filter: blur(5px); }
        .modal-overlay.active { display: flex; }
        .modal { background: var(--bg-card); border-radius: var(--border-radius); box-shadow: 0 10px 30px rgba(0,0,0,0.2); width: 90%; max-width: 700px; max-height: 90vh; display: flex; flex-direction: column; }
        .modal-header { padding: 1.5rem; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .modal-header h3 { margin: 0; font-size: 1.5rem; color: var(--text-dark); }
        .modal-header .close-btn { background: none; border: none; font-size: 1.8rem; cursor: pointer; color: var(--text-muted); }
        .modal-body { padding: 1.5rem; overflow-y: auto; flex-grow: 1; }
        .modal-exercicio-list { list-style: none; }
        .modal-exercicio-list li { display: flex; align-items: center; padding: 1rem; border-radius: 8px; cursor: pointer; transition: background-color 0.2s; border-bottom: 1px solid #f0f0f0; }
        .modal-exercicio-list li:hover { background-color: var(--bg-light); }
        .modal-exercicio-list li.selected { background-color: #eadaff; font-weight: 600; }
        .modal-exercicio-list input[type="checkbox"] { width: 18px; height: 18px; accent-color: var(--primary-color); margin-right: 15px; }
        .modal-footer { padding: 1.5rem; border-top: 1px solid var(--border-color); text-align: right; }
        
        .selected-exercises-list { list-style: none; padding: 1rem; margin-top: 1rem; background-color: var(--bg-light); border: 1px solid var(--border-color); border-radius: var(--border-radius); min-height: 40px; }
        .selected-exercise-item { padding: 0.5rem 0; color: var(--text-dark); font-weight: 500; }

        .treinos-grid { display: grid; gap: 1.5rem; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); }
        .treino-card { background: var(--bg-card); border-radius: var(--border-radius); box-shadow: var(--shadow); display: flex; flex-direction: column; transition: transform 0.3s; }
        .treino-card:hover { transform: translateY(-5px); }
        .treino-card-content { padding: 1.5rem; flex-grow: 1; display: flex; flex-direction: column; }
        .treino-card h3 { margin-top: 0; color: var(--primary-color); font-size: 1.3rem; }
        .treino-card p { color: var(--text-muted); flex-grow: 1; margin: 0.5rem 0 1.5rem 0; }
        .treino-card .btn { margin-top: auto; }
        .treino-info { font-size: 0.9rem; font-weight: 600; color: #777; border-top: 1px solid var(--border-color); padding-top: 1rem; margin-bottom: 1.5rem; }
        
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
            z-index: 1000;
        }
        .bottom-nav a { display: flex; flex-direction: column; align-items: center; text-decoration: none; color: var(--text-muted); font-size: 0.7rem; gap: 4px; }
        .bottom-nav a .icon { font-size: 1.4rem; }
        .bottom-nav a.active, .bottom-nav a:hover { color: var(--primary-color); }
        
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .main-content { padding: 1.5rem; padding-bottom: 100px; }
            .main-header h1 { font-size: 2rem; }
        }
        @media (min-width: 992px) {
            .sidebar { display: block; }
            .main-content { margin-left: var(--sidebar-width); }
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
            <li><a href="TreinoServlet" class="active"><i class="fas fa-dumbbell icon"></i> Treino</a></li>
            <li><a href="progress.jsp"><i class="fas fa-chart-line icon"></i> Progresso</a></li>
            <li><a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a></li>
        </ul>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <h1>Seus Treinos</h1>
            <p>Explore os treinos disponíveis ou crie uma nova rotina personalizada.</p>
        </header>

        <section class="card">
            <h2>Criar Novo Treino</h2>
            <form id="createTreinoForm" action="TreinoServlet" method="post">
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
                    <label>Exercícios Selecionados</label>
                    <div id="selectedExercisesContainer">
                        <ul class="selected-exercises-list">
                            <li>Nenhum exercício selecionado.</li>
                        </ul>
                    </div>
                    <button type="button" id="openModalBtn" class="btn btn-outline" style="margin-top: 1rem;">
                        <i class="fas fa-plus"></i> Adicionar Exercícios
                    </button>
                </div>
                
                <div id="hidden-inputs-container"></div>
                
                <button type="submit" class="btn" style="margin-top: 1.5rem;">Salvar Treino</button>
            </form>
        </section>

        <section class="card">
            <h2>Treinos Disponíveis</h2>
            <div class="treinos-grid">
                <% if (treinos != null && !treinos.isEmpty()) { %>
                    <% for (Treino t : treinos) { %>
                        <div class="treino-card">
                            <div class="treino-card-content">
                                <h3><%= t.getNome() %></h3>
                                <div class="treino-info">
                                    <span><i class="fas fa-layer-group"></i> <%= t.getNivel() %></span>
                                </div>
                                <p><%= t.getDescricao() %></p>
                                <a href="TreinoDetalheServlet?idTreino=<%= t.getId() %>" class="btn">Iniciar Treino</a>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <p>Você ainda não possui treinos cadastrados. Crie um acima!</p>
                <% } %>
            </div>
        </section>
    </main>

    <nav class="bottom-nav">
        <a href="home.jsp"><i class="fas fa-home icon"></i> Home</a>
        <a href="TreinoServlet" class="active"><i class="fas fa-dumbbell icon"></i> Treino</a>
        <a href="progress.jsp"><i class="fas fa-chart-line icon"></i> Progresso</a>
        <a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a>
    </nav>
</div>

<div id="exercicioModal" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3>Selecione os Exercícios</h3>
            <button class="close-btn" id="closeModalBtn">&times;</button>
        </div>
        <div class="modal-body">
            <div class="form-group">
                <input type="text" id="searchExercicio" placeholder="Buscar exercício por nome...">
            </div>
            <ul class="modal-exercicio-list">
                <% if (todosExercicios != null && !todosExercicios.isEmpty()) { %>
                    <% for (Exercicio ex : todosExercicios) { %>
                        <li data-id="<%= ex.getId() %>" data-name="<%= ex.getNome() %>">
                            <input type="checkbox" id="ex-<%= ex.getId() %>">
                            <label for="ex-<%= ex.getId() %>" style="flex-grow: 1; cursor: pointer;">
                                <%= ex.getNome() %> <small>(<%= ex.getGrupoMuscular() %>)</small>
                            </label>
                        </li>
                    <% } %>
                <% } else { %>
                    <li>Nenhum exercício cadastrado.</li>
                <% } %>
            </ul>
        </div>
        <div class="modal-footer">
            <button id="confirmSelectionBtn" class="btn">Confirmar</button>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const openModalBtn = document.getElementById('openModalBtn');
    const modalOverlay = document.getElementById('exercicioModal');
    const closeModalBtn = document.getElementById('closeModalBtn');
    const confirmSelectionBtn = document.getElementById('confirmSelectionBtn');
    const searchInput = document.getElementById('searchExercicio');
    const exerciseListItems = modalOverlay.querySelectorAll('.modal-exercicio-list li');
    const selectedContainer = document.getElementById('selectedExercisesContainer');
    const hiddenInputsContainer = document.getElementById('hidden-inputs-container');

    let selectedExercises = new Map();

    function openModal() {
        exerciseListItems.forEach(item => {
            const id = item.dataset.id;
            const checkbox = item.querySelector('input[type="checkbox"]');
            checkbox.checked = selectedExercises.has(id);
            item.classList.toggle('selected', checkbox.checked);
        });
        modalOverlay.classList.add('active');
    }

    function closeModal() {
        modalOverlay.classList.remove('active');
    }

    function updateSelectedDisplay() {
        selectedContainer.innerHTML = '';
        hiddenInputsContainer.innerHTML = '';

        const list = document.createElement('ul');
        list.className = 'selected-exercises-list';

        if (selectedExercises.size === 0) {
            list.innerHTML = '<li>Nenhum exercício selecionado.</li>';
        } else {
            selectedExercises.forEach((name, id) => {
                const listItem = document.createElement('li');
                listItem.className = 'selected-exercise-item';
                listItem.textContent = name;
                list.appendChild(listItem);

                const hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'exercicios';
                hiddenInput.value = id;
                hiddenInputsContainer.appendChild(hiddenInput);
            });
        }
        selectedContainer.appendChild(list);
    }

    openModalBtn.addEventListener('click', openModal);
    closeModalBtn.addEventListener('click', closeModal);
    modalOverlay.addEventListener('click', (e) => {
        if (e.target === modalOverlay) closeModal();
    });

    confirmSelectionBtn.addEventListener('click', () => {
        selectedExercises.clear();
        exerciseListItems.forEach(item => {
            const checkbox = item.querySelector('input[type="checkbox"]');
            if (checkbox.checked) {
                selectedExercises.set(item.dataset.id, item.dataset.name);
            }
        });
        updateSelectedDisplay();
        closeModal();
    });
    
    exerciseListItems.forEach(item => {
        item.addEventListener('click', (e) => {
            const checkbox = item.querySelector('input[type="checkbox"]');
            if (e.target.tagName !== 'INPUT') {
                checkbox.checked = !checkbox.checked;
            }
            item.classList.toggle('selected', checkbox.checked);
        });
    });

    searchInput.addEventListener('keyup', () => {
        const filter = searchInput.value.toLowerCase();
        exerciseListItems.forEach(item => {
            const name = item.dataset.name.toLowerCase();
            item.style.display = name.includes(filter) ? 'flex' : 'none';
        });
    });
});
</script>

</body>
</html>