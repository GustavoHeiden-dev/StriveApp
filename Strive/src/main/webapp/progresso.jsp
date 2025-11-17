<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Modelos.Usuario, java.util.List" %>
<%@ page import="Modelos.Progresso, Modelos.ProgressoExercicio, Modelos.ContagemMensal" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // Lógica JSP para carregar dados e calcular estatísticas
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String primeiroNome = usuario.getNome().split(" ")[0]; // Adicionando para uso no cabeçalho.

    // As listas devem ser carregadas pelo ProgressoServlet
    List<Progresso> sessoes = (List<Progresso>) request.getAttribute("sessoesConcluidas");
    List<ProgressoExercicio> progressosPeso = (List<ProgressoExercicio>) request.getAttribute("progressoPeso");
    List<ContagemMensal> treinosPorMes = (List<ContagemMensal>) request.getAttribute("treinosPorMes");

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    
    int totalTreinos = (sessoes != null) ? sessoes.size() : 0;
    int totalDuracaoMinutos = 0;
    if (sessoes != null) {
        for (Progresso sessao : sessoes) {
            totalDuracaoMinutos += sessao.getDuracaoMinutos();
        }
    }
    int horas = totalDuracaoMinutos / 60;
    int minutos = totalDuracaoMinutos % 60;
    
    float duracaoMedia = (totalTreinos > 0) ? (float)totalDuracaoMinutos / totalTreinos : 0;
    
    final int META_MINUTOS_PADRAO = 1000; 
    int minutosParaMeta = META_MINUTOS_PADRAO;
    
    if ("avançado".equalsIgnoreCase(usuario.getNivelInicial())) {
        minutosParaMeta = 3000;
    } 
    else if ("intermediário".equalsIgnoreCase(usuario.getNivelInicial())) {
        minutosParaMeta = 2000;
    }

    float porcentagemProgresso = (totalDuracaoMinutos > 0) 
        ? Math.min(100.0f, ((float)totalDuracaoMinutos / minutosParaMeta) * 100.0f) 
        : 0;
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <title>Progresso - Strive</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <style>
        /* ESTILOS DA HOME.JSP COPIADOS E INTEGRADOS */
        :root {
            --primary-color: #6a0dad;
            --secondary-color: #8A2BE2;
            --success-color: #3CB371;
            --bg-light: #f9f9fb;
            --bg-card: #ffffff;
            --bg-sidebar: #f0f0f5;
            --text-dark: #333;
            --text-muted: #666;
            --border-color: #e0e0e0;
            --sidebar-width: 250px;
            --border-radius: 12px;
            --shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            --error-color: #dc3545; /* Adicionado para mensagens de erro no JS */
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
            overflow-x: hidden; 
        }

        .dashboard-container {
            display: flex;
        }

        /* Sidebar - Estilos da home.jsp */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--bg-sidebar); /* #f0f0f5 */
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 2rem 1rem;
            border-right: 1px solid #ddd;
            display: none; /* Inicia oculto, aparece em desktop */
            z-index: 1100;
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
            font-size: 1rem;
            width: 20px;
            text-align: center;
        }

        /* Bottom Nav - Estilos da home.jsp */
        .bottom-nav {
            display: flex;
            justify-content: space-around;
            padding: 0.8rem 0;
            background-color: var(--bg-sidebar);
            border-top: 1px solid #ddd;
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
        }

        .bottom-nav a {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none;
            color: var(--text-muted);
            font-size: 0.7rem;
            gap: 4px;
            flex-basis: 0;
            flex-grow: 1;
            text-align: center;
            transition: color 0.3s;
        }

        .bottom-nav a .icon {
            font-size: 1.4rem;
        }

        .bottom-nav a.active,
        .bottom-nav a:hover {
            color: var(--primary-color);
        }
        /* FIM ESTILOS DA HOME.JSP COPIADOS E INTEGRADOS */

        .main-content {
            flex: 1;
            padding: 2rem 1rem; 
            padding-bottom: 100px;
            min-width: 0; 
            width: 100%;
        }
        .main-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        .main-header p {
            color: var(--text-muted);
            margin-bottom: 2rem;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: var(--primary-color);
            color: white;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            text-align: center;
            box-shadow: var(--shadow);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card .value {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 0.2rem;
        }
        .stat-card .label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        .progress-grid {
            display: grid;
            gap: 2rem;
            grid-template-columns: 1fr; 
        }
        .card {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--shadow);
        }
        .card h2 {
            margin-top: 0;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
            font-size: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
        }
        .list-group {
            list-style: none;
            padding: 0;
        }
        .list-group-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 1rem;
        }
        /* NOVO ESTILO: Garante que o botão detalhes se alinhe corretamente */
        .list-group-item > div:last-child {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 5px;
        }
        .btn-detalhes-treino {
            background: none; 
            border: none; 
            color: var(--secondary-color); 
            cursor: pointer; 
            font-weight: 600; 
            padding: 0;
            font-size: 0.9rem;
            transition: color 0.3s;
        }
        .btn-detalhes-treino:hover {
            color: var(--primary-color) !important;
            text-decoration: underline;
        }
        /* FIM NOVO ESTILO */

        @media (max-width: 450px) {
            .list-group-item {
                flex-direction: column;
                align-items: flex-start;
            }
            .list-group-item div {
                width: 100%;
                text-align: left !important;
            }
            /* Ajuste para que o bloco de info básica não quebre o layout */
            .list-group-item > div:last-child {
                margin-top: 5px;
                align-items: flex-start;
            }
        }

        .list-group-item:last-child {
            border-bottom: none;
        }
        .list-group-item strong {
            color: var(--secondary-color);
            font-weight: 700;
        }
        .list-group-item span {
            color: var(--text-muted);
        }
        
        .progress-bar-container {
            width: 100%;
            background-color: var(--bg-light);
            border-radius: 8px;
            overflow: hidden;
            margin-top: 1rem;
        }
        .progress-bar {
            height: 25px;
            background-color: var(--primary-color);
            text-align: center;
            line-height: 25px;
            color: white;
            font-weight: 600;
            transition: width 0.5s ease;
        }
        
        .chart-container {
            position: relative;
            height: 350px; 
            width: 100%;
        }
        
        /* ESTILOS DO MODAL */
        .modal {
            display: none; 
            position: fixed;
            z-index: 2000; 
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto; 
            background-color: rgba(0,0,0,0.7); 
        }
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto; 
            padding: 20px;
            border-radius: var(--border-radius);
            width: 90%; 
            max-width: 600px; 
            box-shadow: var(--shadow);
            position: relative;
            max-height: 90vh; 
            overflow-y: auto; 
        }
        .close-button {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close-button:hover,
        .close-button:focus {
            color: var(--primary-color);
            text-decoration: none;
            cursor: pointer;
        }
        .modal-content h2 {
            margin-top: 0;
            margin-bottom: 1rem;
            color: var(--text-dark);
            font-size: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }
        .modal-list-group-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .modal-list-group-item:last-child {
            border-bottom: none;
        }
        /* NOVO ESTILO: Ícones de detalhes no modal */
        .modal-list-group-item .fa-sync-alt, .modal-list-group-item .fa-weight-hanging {
            color: var(--primary-color);
            margin-right: 5px;
        }
        /* FIM NOVO ESTILO */

        /* Ajuste mobile para lista no modal */
        @media (max-width: 450px) {
            .modal-list-group-item {
                flex-direction: column;
                align-items: flex-start;
            }
            .modal-list-group-item div {
                width: 100%;
                text-align: left !important;
            }
            .modal-list-group-item div:last-child {
                margin-top: 5px;
            }
        }
        /* FIM ESTILOS DO MODAL */

        /* Media Query para Desktop (992px ou mais) */
        @media (min-width: 992px) {
            .sidebar {
                display: block; /* Mostra a sidebar no desktop */
            }
            .main-content {
                padding: 2.5rem; /* Ajuste o padding para o desktop */
                margin-left: var(--sidebar-width); /* Empurra o conteúdo para a direita da sidebar */
                width: auto;
                padding-bottom: 2.5rem; /* Remove o padding extra do bottom-nav */
            }
            .bottom-nav {
                display: none; /* Oculta a navegação inferior no desktop */
            }
            .progress-grid {
                /* NOVO: 3 Colunas no desktop */
                grid-template-columns: repeat(3, 1fr); 
            }
            .progress-grid > .card.span-2 {
                /* Mantém o card do gráfico e progresso ocupando 3 colunas */
                grid-column: span 3;
            }
            /* NOVO: Histórico de Treinos ocupa 2 colunas, Recordes de Peso ocupa 1 */
            .progress-grid > .card.historico-desktop-span-2 {
                grid-column: span 2; 
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        
        <aside class="sidebar">
            <div class="logo">STRIVE</div>
            <ul class="nav-list">
                <li><a href="home.jsp"><i class="fas fa-home icon"></i> Home</a></li>
                <li><a href="TreinoServlet"><i class="fas fa-dumbbell icon"></i> Treino</a></li>
                <li><a href="PerfilServlet"><i class="fas fa-user icon"></i> Perfil</a></li>
                <li><a href="SairServlet"><i class="fas fa-sign-out-alt icon"></i> Sair</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <header class="main-header">
                <h1>Seu Progresso, <span><%= primeiroNome %></span> 💪</h1>
                <p>Aqui você pode acompanhar sua evolução em consistência, força e treinos concluídos.</p>
            </header>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="value"><%= totalTreinos %></div>
                    <div class="label">Treinos Concluídos</div>
                </div>
                <div class="stat-card">
                    <div class="value"><%= horas %>h <%= minutos %>m</div>
                    <div class="label">Tempo Total Treinado</div>
                </div>
                <div class="stat-card" style="background-color: var(--success-color);">
                    <div class="value"><%= String.format("%.0f", duracaoMedia) %> min</div>
                    <div class="label">Duração Média</div>
                </div>
            </div>
            
            <div class="progress-grid">
                
                <div class="card span-2"> 
                    <h2>Progresso de Consistência de Treino</h2>
                    <p style="margin-bottom: 1rem;">
                        Você completou <strong><%= totalDuracaoMinutos %></strong> minutos de uma meta de <strong><%= minutosParaMeta %></strong> minutos para o nível <%= usuario.getNivelInicial() %>.
                    </p>
                    <div class="progress-bar-container">
                        <div class="progress-bar" style="width: <%= String.format("%.0f", porcentagemProgresso) %>%;">
                            <%= String.format("%.0f", porcentagemProgresso) %>%
                        </div>
                    </div>
                </div>
                
                <div class="card span-2">
                    <h2>Consistência Mensal</h2>
                    <div class="chart-container">
                        <canvas id="treinosChart"></canvas>
                    </div>
                </div>
                
                <div class="card">
                    <h2>Recordes de Peso por Exercício</h2>
                    <ul class="list-group">
                        <% 
                            final int LIMITE_EXIBICAO_PESO = 5; 
                            int contadorPeso = 0;
                        
                            if (progressosPeso != null && !progressosPeso.isEmpty()) { 
                                for (ProgressoExercicio pe : progressosPeso) { 
                                    // Limita a exibição no card
                                    if (contadorPeso >= LIMITE_EXIBICAO_PESO) break;
                        %>
                                <li class="list-group-item">
                                    <strong><%= pe.getNomeExercicio() %></strong>
                                    <span><%= String.format("%.1f kg", pe.getPesoMaximo()) %></span>
                                </li>
                            <%  
                                    contadorPeso++;
                                } 
                            } else { 
                            %>
                            <li class="list-group-item">
                                <span>Registre um treino para ver seu progresso de peso.</span>
                            </li>
                        <% } %>
                    </ul>
                    <% if (progressosPeso != null && progressosPeso.size() > LIMITE_EXIBICAO_PESO) { %>
                        <p style="text-align: center; margin-top: 1.5rem;">
                            <a href="#" class="view-more-link" onclick="openModal('pesoModal'); return false;" 
                                style="color: var(--primary-color); text-decoration: none; font-weight: 600;">
                                Ver Mais Recordes (Total: <%= progressosPeso.size() %>)
                            </a>
                        </p>
                    <% } else if (progressosPeso != null && progressosPeso.size() > 0) { %>
                        <p style="text-align: center; margin-top: 1.5rem; color: var(--text-muted); font-size: 0.9rem;">
                            Todos os <%= progressosPeso.size() %> recordes exibidos.
                        </p>
                    <% } %>
                </div>
                
                <div class="card historico-desktop-span-2"> <h2>Histórico de Treinos</h2>
                    <% 
                        final int LIMITE_EXIBICAO = 5; 
                        
                        if (sessoes != null && !sessoes.isEmpty()) { 
                            int contador = 0;
                    %>
                        <ul class="list-group">
                            <% for (Progresso sessao : sessoes) { 
                                if (contador >= LIMITE_EXIBICAO) break; 
                            %>
                                <li class="list-group-item">
                                    <div style="font-weight: 600;"><%= sessao.getNomeTreino() %></div>
                                    <div>
                                        <span style="display: block;">Duração: <strong><%= sessao.getDuracaoMinutos() %> min</strong></span>
                                        <small style="color: var(--text-muted);">Em: <%= sessao.getDataFim().format(dateFormatter) %></small>
                                        
                                        <button type="button" 
                                            class="btn-detalhes-treino" 
                                            data-id-sessao="<%= sessao.getIdSessao() %>" 
                                            data-nome-treino="<%= sessao.getNomeTreino() %>"
                                            data-data-fim="<%= sessao.getDataFim().format(dateFormatter) %>"
                                            data-duracao="<%= sessao.getDuracaoMinutos() %>">
                                            <i class="fas fa-search"></i> Detalhes
                                        </button>
                                        </div>
                                </li>
                            <% 
                                contador++;
                            } %>
                        </ul>
                        
                        <% if (sessoes.size() > LIMITE_EXIBICAO) { %>
                            <p style="text-align: center; margin-top: 1.5rem;">
                                <a href="#" class="view-more-link" onclick="openModal('historicoModal'); return false;" style="color: var(--primary-color); text-decoration: none; font-weight: 600;">
                                    Ver Mais Histórico (Total: <%= sessoes.size() %>)
                                </a>
                            </p>
                        <% } %>
                        
                    <% } else { %>
                        <p>Você ainda não concluiu nenhum treino. Comece agora!</p>
                    <% } %>
                </div>
            </div>
        </main>

        <nav class="bottom-nav">
            <a href="home.jsp"><i class="fas fa-home icon"></i> Home</a>
            <a href="TreinoServlet"><i class="fas fa-dumbbell icon"></i> Treino</a>
            <a href="PerfilServlet"><i class="fas fa-user icon"></i> Perfil</a>
            <a href="SairServlet"><i class="fas fa-sign-out-alt icon"></i> Sair</a>
        </nav>
    </div>

    <div id="pesoModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal('pesoModal')">&times;</span>
            <h2>Todos os Recordes de Peso</h2>
            <ul class="list-group">
                <% if (progressosPeso != null && !progressosPeso.isEmpty()) { %>
                    <% for (ProgressoExercicio pe : progressosPeso) { %>
                        <li class="modal-list-group-item">
                            <strong><%= pe.getNomeExercicio() %></strong>
                            <span><%= String.format("%.1f kg", pe.getPesoMaximo()) %></span>
                        </li>
                    <% } %>
                <% } else { %>
                    <li class="modal-list-group-item">
                        <span>Nenhum recorde de peso registrado.</span>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>

    <div id="historicoModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal('historicoModal')">&times;</span>
            <h2>Histórico Completo de Treinos</h2>
            <ul class="list-group">
                <% if (sessoes != null && !sessoes.isEmpty()) { %>
                    <% for (Progresso sessao : sessoes) { %>
                        <li class="modal-list-group-item">
                            <div style="font-weight: 600;"><%= sessao.getNomeTreino() %></div>
                            <div style="text-align: right;">
                                <span style="display: block;">Duração: <strong><%= sessao.getDuracaoMinutos() %> min</strong></span>
                                <small style="color: var(--text-muted);">Em: <%= sessao.getDataFim().format(dateFormatter) %></small>
                            </div>
                        </li>
                    <% } %>
                <% } else { %>
                    <li class="modal-list-group-item">
                        <span>Nenhum treino concluído registrado.</span>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
    
    <div id="detalhesTreinoModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal('detalhesTreinoModal')">&times;</span>
            <h2 id="detalhesTreinoTitulo">Detalhes do Treino</h2>
            <p id="detalhesTreinoInfo" style="color: var(--text-muted); margin-bottom: 1.5rem; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;"></p>
            <div id="detalhesTreinoBody">
                <p style="text-align: center; color: #777;">Carregando detalhes...</p>
            </div>
        </div>
    </div>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const dadosTreinos = [];
        <% if (treinosPorMes != null) {
            for (ContagemMensal cm : treinosPorMes) { %>
                dadosTreinos.push({
                    ano: parseInt(<%= cm.getAno() %>),
                    mes: parseInt(<%= cm.getMes() %>),
                    total: parseInt(<%= cm.getTotalTreinos() %>)
                });
        <%  }
        } %> 

        if (dadosTreinos.length > 0) {
            const meses = [
                "Jan", "Fev", "Mar", "Abr", "Mai", "Jun", 
                "Jul", "Ago", "Set", "Out", "Nov", "Dez"
            ];
            
            const labels = dadosTreinos.map(d => {
                let mesIndex = d.mes - 1; 
                if (mesIndex < 0 || mesIndex > 11 || isNaN(mesIndex)) {
                    return "Inválido"; 
                }
                return meses[mesIndex];
            });
            
            const data = dadosTreinos.map(d => d.total);
            const primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--primary-color').trim();
            const textDarkColor = getComputedStyle(document.documentElement).getPropertyValue('--text-dark').trim();

            const ctx = document.getElementById('treinosChart').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Treinos Concluídos',
                        data: data,
                        backgroundColor: primaryColor,
                        borderColor: primaryColor,
                        borderWidth: 1,
                        borderRadius: 6,
                        hoverBackgroundColor: 'rgba(106, 13, 173, 0.9)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            // Limite de 30 para o eixo Y, conforme solicitado
                            max: 30, 
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)',
                                drawBorder: false
                            },
                            ticks: {
                                precision: 0
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: { 
                                color: textDarkColor, 
                                autoSkip: false,     
                                maxRotation: 45,     
                                minRotation: 45
                            },
                            barPercentage: 0.6, 
                            categoryPercentage: 0.8 
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleFont: { size: 14 },
                            bodyFont: { size: 12 },
                            displayColors: false,
                            callbacks: {
                                title: function(tooltipItems, data) {
                                    const index = tooltipItems[0].dataIndex;
                                    const ano = dadosTreinos[index].ano;
                                    const mes = meses[dadosTreinos[index].mes - 1];
                                    return mes + "/" + ano;
                                }, 
                                label: function(tooltipItem, data) {
                                    return 'Treinos: ' + tooltipItem.formattedValue;
                                }
                            }
                        }
                    }
                }
            });
        } else {
            const chartContainer = document.getElementById('treinosChart').parentNode;
            chartContainer.innerHTML = '<div class="chart-container"><p style="text-align: center; color: #777; margin-top: 5rem;">Ainda não há treinos concluídos para exibir no gráfico.</p></div>';
        }
        
        // NOVO: Listener para o botão de Detalhes do Treino
        document.querySelectorAll('.btn-detalhes-treino').forEach(button => {
            button.addEventListener('click', function(event) {
                const idSessao = this.dataset.idSessao;
                const nomeTreino = this.dataset.nomeTreino;
                const dataFim = this.dataset.dataFim;
                const duracao = this.dataset.duracao;
                const modalBody = document.getElementById('detalhesTreinoBody');
                const errorColor = getComputedStyle(document.documentElement).getPropertyValue('--error-color').trim();
                
                // Atualiza o cabeçalho do modal com informações básicas
                document.getElementById('detalhesTreinoTitulo').textContent = 'Detalhes: ' + nomeTreino;
                document.getElementById('detalhesTreinoInfo').innerHTML = 
                    'Concluído em: <strong>' + dataFim + '</strong> | Duração: <strong>' + duracao + ' min</strong>';
                
                // Exibe o modal
                openModal('detalhesTreinoModal');
                
                // Placeholder de carregamento
                modalBody.innerHTML = '<p style="text-align: center; color: #777;"><i class="fas fa-spinner fa-spin"></i> Carregando detalhes...</p>';

                // Faz a requisição AJAX para o servlet para obter o fragmento JSP com os detalhes
                fetch('ProgressoServlet?action=detalhes&idSessao=' + idSessao)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Erro na requisição: ' + response.statusText);
                        }
                        return response.text(); 
                    })
                    .then(html => {
                        // Insere o conteúdo HTML (o fragmento JSP renderizado) no corpo do modal
                        modalBody.innerHTML = html;
                    })
                    .catch(error => {
                        console.error('Erro ao buscar detalhes do treino:', error);
                        modalBody.innerHTML = '<p style="color: ' + errorColor + '; text-align: center;">Erro ao carregar os detalhes do treino. Tente novamente.</p>';
                    });
            });
        });
        // FIM NOVO LISTENER
    });

    // Funções do Modal
    function openModal(modalId) {
        document.getElementById(modalId).style.display = 'block';
    }

    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }

    // Fecha o modal se o usuário clicar fora dele
    window.onclick = function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    }
    </script>
</body>
</html>