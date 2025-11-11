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
            width: 100%; 
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
        .main-content {
            flex: 1;
            /* AJUSTE MOBILE: Padding superior e inferior é 2rem. Laterais usam 1rem */
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
            /* Responsividade padrão: 150px é o tamanho mínimo, ajusta colunas */
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
            /* No Mobile (Padrão), usa apenas UMA coluna para garantir que os cards se empilhem */
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
        /* Ajuste para o Histórico no Mobile (quebra a linha se o texto for muito longo) */
        @media (max-width: 450px) {
            .list-group-item {
                flex-direction: column;
                align-items: flex-start;
            }
            .list-group-item div {
                width: 100%;
                text-align: left !important;
            }
            .list-group-item div:last-child {
                margin-top: 5px;
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
        /* ESTILO PADRONIZADO PARA O BOTTOM NAV */
        .bottom-nav {
            display: flex;
            justify-content: space-around;
            padding: 0.8rem 0;
            background-color: var(--bg-sidebar); /* Usando variável para consistência */
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
        }
        .bottom-nav a .icon {
            font-size: 1.4rem;
        }
        .bottom-nav a.active,
        .bottom-nav a:hover {
            color: var(--primary-color);
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
        
        /* Media Query para Desktop (992px ou mais) */
        @media (min-width: 992px) {
            .sidebar {
                display: block;
            }
            .main-content {
                /* No desktop, voltamos a ter 2rem de padding em todos os lados e a margem lateral para o sidebar */
                padding: 2rem;
                margin-left: var(--sidebar-width);
                width: auto;
            }
            .bottom-nav {
                display: none;
            }
            .progress-grid {
                /* No Desktop, volta para 2 colunas */
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
            }
            /* Garante que os cards de Consistência e Gráfico usem 2 colunas no desktop */
            .progress-grid > .card.span-2 {
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
                <li><a href="ProgressoServlet" class="active"><i class="fas fa-chart-line icon"></i> Progresso</a></li>
                <li><a href="ConquistasServlet"><i class="fas fa-trophy icon"></i> Conquistas</a></li>
                <li><a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a></li>
                <li class="logout-link"><a href="SairServlet"><i class="fas fa-sign-out-alt icon"></i> Sair</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <header class="main-header">
                <h1>Seu Progresso 💪</h1>
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
                        <% if (progressosPeso != null && !progressosPeso.isEmpty()) { %>
                            <% for (ProgressoExercicio pe : progressosPeso) { %>
                                <li class="list-group-item">
                                    <strong><%= pe.getNomeExercicio() %></strong>
                                    <span><%= String.format("%.1f kg", pe.getPesoMaximo()) %></span>
                                </li>
                            <% } %>
                        <% } else { %>
                            <li class="list-group-item">
                                <span>Registre um treino para ver seu progresso de peso.</span>
                            </li>
                        <% } %>
                    </ul>
                </div>
                
                <div class="card">
                    <h2>Histórico de Treinos</h2>
                    <% 
                        final int LIMITE_EXIBICAO = 5; // Limita a 5 treinos para evitar que a div cresça demais
                        
                        if (sessoes != null && !sessoes.isEmpty()) { 
                            int contador = 0;
                    %>
                        <ul class="list-group">
                            <% for (Progresso sessao : sessoes) { 
                                // Otimização: para o loop após atingir o limite
                                if (contador >= LIMITE_EXIBICAO) break; 
                            %>
                                <li class="list-group-item">
                                    <div style="font-weight: 600;"><%= sessao.getNomeTreino() %></div>
                                    <div style="text-align: right;">
                                        <span style="display: block;">Duração: <strong><%= sessao.getDuracaoMinutos() %> min</strong></span>
                                        <small style="color: var(--text-muted);">Em: <%= sessao.getDataFim().format(dateFormatter) %></small>
                                    </div>
                                </li>
                            <% 
                                contador++;
                            } %>
                        </ul>
                        
                        <% if (sessoes.size() > LIMITE_EXIBICAO) { %>
                            <p style="text-align: center; margin-top: 1.5rem;">
                                <a href="historico-completo.jsp" style="color: var(--primary-color); text-decoration: none; font-weight: 600;">
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
            <a href="ProgressoServlet" class="active"><i class="fas fa-chart-line icon"></i> Progresso</a>
            <a href="ConquistasServlet"><i class="fas fa-trophy icon"></i> Conquistas</a>
            <a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a>
        </nav>
        </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const dadosTreinos = [];
        <% if (treinosPorMes != null) {
            for (ContagemMensal cm : treinosPorMes) { %>
                dadosTreinos.push({
                    // Conversão explícita para inteiro para maior robustez
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
                
                // Validação de índice: Garante que o índice esteja entre 0 e 11, evitando meses inválidos (0)
                if (mesIndex < 0 || mesIndex > 11 || isNaN(mesIndex)) {
                    // Retorna 'Inválido' se o mês for incorreto.
                    return "Inválido"; 
                }
                
                // Formato Mês (ex: Set)
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
                            // Configuração de Ticks (Rótulos) Adicionada/Ajustada para forçar visibilidade
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
                             // Adiciona o ano ao tooltip para contexto, já que foi removido do rótulo
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
    });
    </script>
</body>
</html>