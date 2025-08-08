<%@ page import="java.util.Random" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // -----------------------------------------------------------------
    // PASSO 1: PREPARAÇÃO DAS VARIÁVEIS (DADOS VINDOS DO BANCO)
    // -----------------------------------------------------------------

    // Verifica a sessão do usuário
    String usuario = (session != null) ? (String) session.getAttribute("usuario") : null;
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String primeiroNome = usuario.split(" ")[0];
    String inicialUsuario = primeiroNome.substring(0, 1).toUpperCase();

    // --- VARIÁVEIS PRONTAS PARA RECEBER DADOS DO BANCO ---
    // TODO: Substitua os valores padrão (0, "...") pela sua lógica de busca no banco de dados.

    // Informações do treino de hoje
    String workoutTitle = "Seu próximo desafio"; // Valor genérico
    int workoutDuration = 0;
    int workoutExercises = 0;
    boolean isRestDay = false; // Mude para 'true' se a lógica do banco indicar descanso

    // Estatísticas de progresso
    int totalWorkouts = 0;
    int caloriesBurned = 0;
    int weeklyGoal = 5; // Pode vir das configurações do usuário no banco
    int currentWeekProgress = 0;

    // Lógica da dica motivacional
    String[] motivationalTips = {
        "💪 A disciplina é a ponte entre metas e realizações.",
        "🎯 Feito é melhor que perfeito. Apenas comece!",
        "⚡ Cada gota de suor é um passo para a vitória.",
        "🔥 Transforme a dor em poder e a dedicação em resultados."
    };
    Random rand = new Random();
    String todayTip = motivationalTips[rand.nextInt(motivationalTips.length)];

    // Cálculo da porcentagem para a barra de progresso
    int progressPercentage = 0;
    if (weeklyGoal > 0) {
        progressPercentage = (int) (((double) currentWeekProgress / weeklyGoal) * 100);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Strive - Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-50 text-gray-900">

    <div class="lg:flex">
        <!-- ================================================== -->
        <!-- NAVEGAÇÃO: SIDEBAR NO PC, FOOTER NO MOBILE       -->
        <!-- ================================================== -->
        <nav class="
            lg:w-64 lg:h-screen lg:flex lg:flex-col lg:justify-between lg:border-r lg:border-gray-200 lg:p-6
            fixed bottom-0 w-full bg-white/95 backdrop-blur-sm border-t border-gray-200 z-50
            lg:relative lg:bg-white lg:backdrop-blur-none lg:border-t-0
        ">
            <div>
                <!-- Logo (Visível apenas no PC) -->
                <div class="hidden lg:flex items-center gap-2 mb-10">
                    <i class="fa-solid fa-bolt text-purple-600 fa-lg"></i>
                    <span class="text-2xl font-extrabold tracking-tighter">Strive</span>
                </div>

                <!-- Itens do Menu -->
                <div class="flex justify-around lg:flex-col lg:space-y-2">
                    <a href="home.jsp" class="flex flex-col lg:flex-row items-center lg:items-center lg:gap-4 w-full h-16 lg:h-auto lg:p-4 text-purple-600 font-semibold lg:bg-purple-50 lg:rounded-lg">
                        <i class="fa-solid fa-house fa-lg"></i>
                        <span class="text-xs mt-1.5 lg:mt-0 lg:text-base">Home</span>
                    </a>
                    <a href="workout.jsp" class="flex flex-col lg:flex-row items-center lg:items-center lg:gap-4 w-full h-16 lg:h-auto lg:p-4 text-gray-500 hover:text-purple-600 hover:bg-purple-50 lg:rounded-lg">
                        <i class="fa-solid fa-dumbbell fa-lg"></i>
                        <span class="text-xs mt-1.5 lg:mt-0 lg:text-base">Treino</span>
                    </a>
                    <a href="progress.jsp" class="flex flex-col lg:flex-row items-center lg:items-center lg:gap-4 w-full h-16 lg:h-auto lg:p-4 text-gray-500 hover:text-purple-600 hover:bg-purple-50 lg:rounded-lg">
                        <i class="fa-solid fa-chart-pie fa-lg"></i>
                        <span class="text-xs mt-1.5 lg:mt-0 lg:text-base">Progresso</span>
                    </a>
                    <a href="notifications.jsp" class="flex flex-col lg:flex-row items-center lg:items-center lg:gap-4 w-full h-16 lg:h-auto lg:p-4 text-gray-500 hover:text-purple-600 hover:bg-purple-50 lg:rounded-lg">
                        <i class="fa-solid fa-bell fa-lg"></i>
                        <span class="text-xs mt-1.5 lg:mt-0 lg:text-base">Notificações</span>
                    </a>
                </div>
            </div>

            <!-- Perfil do Usuário (Visível apenas no PC) -->
            <div class="hidden lg:block border-t border-gray-200 pt-6">
                 <a href="profile.jsp" class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center font-bold text-purple-600">
                        <%= inicialUsuario %>
                    </div>
                    <div>
                        <p class="font-semibold text-gray-800"><%= primeiroNome %></p>
                        <p class="text-xs text-gray-500">Ver Perfil</p>
                    </div>
                </a>
            </div>
        </nav>

        <!-- ================================================== -->
        <!-- CONTEÚDO PRINCIPAL                               -->
        <!-- ================================================== -->
        <main class="flex-1 p-6 lg:p-10 pb-28 lg:pb-10">
            <div class="max-w-4xl mx-auto space-y-8">
                
                <!-- Header (Visível apenas no Mobile) -->
                <header class="lg:hidden flex justify-between items-center">
                    <div>
                        <p class="text-gray-500">Bem-vindo,</p>
                        <h1 class="text-2xl font-extrabold text-gray-900"><%= primeiroNome %>!</h1>
                    </div>
                    <a href="profile.jsp" class="w-10 h-10 bg-white border border-gray-200 rounded-full flex items-center justify-center font-bold text-purple-600">
                        <%= inicialUsuario %>
                    </a>
                </header>

                <!-- Grid de Conteúdo -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    
                    <!-- Coluna Esquerda (Maior) -->
                    <div class="lg:col-span-2 space-y-8">
                        <!-- Card Principal: Treino de Hoje -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6">
                             <h2 class="text-lg font-bold text-gray-800 mb-4">Seu Próximo Treino</h2>
                            <% if (isRestDay) { %>
                                <div class="text-center py-8">
                                    <i class="fa-solid fa-couch fa-2x text-purple-400 mb-3"></i>
                                    <p class="font-semibold text-gray-700">Hoje é dia de descanso!</p>
                                    <p class="text-sm text-gray-500">Aproveite para recarregar as energias.</p>
                                </div>
                            <% } else { %>
                                <div class="space-y-5">
                                    <h3 class="text-2xl font-bold text-gray-900"><%= workoutTitle %></h3>
                                    <div class="flex items-center gap-6 text-gray-600 border-t border-gray-100 pt-4">
                                        <div class="flex items-center gap-2">
                                            <i class="fa-regular fa-clock text-purple-500"></i>
                                            <span><%= workoutDuration %> min</span>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <i class="fa-solid fa-dumbbell text-purple-500"></i>
                                            <span><%= workoutExercises %> exercícios</span>
                                        </div>
                                    </div>
                                    <a href="workout.jsp" class="block w-full text-center bg-gray-900 text-white font-semibold py-3.5 rounded-xl hover:bg-gray-800 transition-colors">
                                        Começar Agora
                                    </a>
                                </div>
                            <% } %>
                        </div>
                        <!-- Dica Motivacional -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-5 flex items-center gap-4">
                            <div class="flex-shrink-0">
                                <i class="fa-regular fa-lightbulb fa-2x text-yellow-400"></i>
                            </div>
                            <div>
                                <h3 class="font-bold text-gray-800">Dica do Dia</h3>
                                <p class="text-sm text-gray-600"><%= todayTip %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Coluna Direita (Menor) -->
                    <div class="lg:col-span-1">
                        <!-- Card de Progresso e Estatísticas -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 h-full">
                            <h2 class="text-lg font-bold text-gray-800 mb-5">Resumo do Progresso</h2>
                            <div class="space-y-6">
                                <div class="grid grid-cols-2 gap-4 text-center">
                                    <div>
                                        <p class="text-3xl font-extrabold text-gray-800"><%= totalWorkouts %></p>
                                        <p class="text-sm text-gray-500">Treinos</p>
                                    </div>
                                    <div>
                                        <p class="text-3xl font-extrabold text-gray-800"><%= caloriesBurned %></p>
                                        <p class="text-sm text-gray-500">Kcal</p>
                                    </div>
                                </div>
                                <div class="space-y-2">
                                    <div class="flex justify-between text-sm font-medium text-gray-600">
                                        <span>Meta da Semana</span>
                                        <span><%= currentWeekProgress %> de <%= weeklyGoal %></span>
                                    </div>
                                    <div class="w-full bg-gray-200 rounded-full h-2.5">
                                        <div class="bg-purple-500 h-2.5 rounded-full" style="width: <%= progressPercentage %>%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

</body>
</html>
