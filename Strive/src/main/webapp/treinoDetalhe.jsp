<%@ page contentType="text/html;charset=UTF-8"
	import="Modelos.Usuario, java.util.List, Modelos.Exercicio, Modelos.Serie"%>
<%
Usuario usuario = (Usuario) session.getAttribute("usuario");
if (usuario == null) {
	response.sendRedirect("login.jsp");
	return;
}
List<Exercicio> exercicios = (List<Exercicio>) request.getAttribute("exercicios");
int totalExercicios = exercicios != null ? exercicios.size() : 0;
int idTreino = (Integer) request.getAttribute("idTreino");
int idSessao = (Integer) request.getAttribute("idSessao");
%>
<!DOCTYPE html>
<html>
<head>
<title>Executando Treino - Strive</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
:root {
	--primary-color: #6a0dad;
	--secondary-color: #8A2BE2;
	--dark-color: #1a1a1a;
	--light-color: #f8f7ff;
	--text-color: #333;
	--white-color: #fff;
	--success-color: #28a745;
	--success-light-color: #e9f7ec;
	--disabled-color: #ccc;
	--error-color: #dc3545;
	--sidebar-width: 250px;
	--border-radius: 12px;
	--shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Poppins', sans-serif;
	background-color: var(--light-color);
	color: var(--text-color);
}

.dashboard-container {
	display: flex;
}

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
	z-index: 1001;
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
	color: #555;
	font-weight: 600;
	text-decoration: none;
	padding: 1rem;
	border-radius: 8px;
	margin-bottom: 0.5rem;
}

.sidebar .nav-list a:hover, .sidebar .nav-list a.active {
	background-color: var(--primary-color);
	color: var(--white-color);
}

.sidebar .nav-list a .icon {
	width: 20px;
	text-align: center;
}

.main-content {
	flex: 1;
	padding: 1rem;
	padding-bottom: 100px;
}

.main-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 2rem;
	flex-wrap: wrap;
	gap: 1rem;
}

.main-header h1 {
	font-size: 2rem;
	font-weight: 700;
	color: var(--dark-color);
}

.progress-counter {
	background-color: var(--primary-color);
	color: var(--white-color);
	padding: 0.5rem 1rem;
	border-radius: 20px;
	font-weight: 600;
}

.exercicio-card {
	background: var(--white-color);
	border-radius: var(--border-radius);
	padding: 1.5rem;
	box-shadow: var(--shadow);
	margin-bottom: 1.5rem;
	border-left: 5px solid var(--primary-color);
	transition: all 0.4s ease;
}

.exercicio-card.concluido {
	border-left-color: var(--success-color);
	background-color: var(--success-light-color);
}

.exercicio-card.concluido .exercicio-header h3 {
	color: var(--success-color);
	text-decoration: line-through;
}

.exercicio-card.concluido .grupo-muscular {
	background-color: var(--success-color);
}

.exercicio-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 1rem;
}

.exercicio-header h3 {
	margin: 0;
	color: var(--primary-color);
}

.grupo-muscular {
	background: var(--secondary-color);
	color: white;
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: 600;
	white-space: nowrap;
}

.exercicio-details p {
	margin: 0.5rem 0;
	color: #555;
}

.btn {
	display: inline-block;
	background: var(--primary-color);
	color: var(--white-color);
	padding: 10px 20px;
	border: none;
	border-radius: 8px;
	font-weight: 600;
	text-decoration: none;
	transition: all 0.3s;
	cursor: pointer;
}

.btn:hover {
	background-color: var(--secondary-color);
	transform: translateY(-2px);
}

.btn-success {
	background-color: var(--success-color);
}

.finalizar-treino-container {
	text-align: center;
	margin-top: 2rem;
	padding: 2rem;
	background: var(--white-color);
	border-radius: var(--border-radius);
	box-shadow: var(--shadow);
}

.btn-finalizar {
	font-size: 1.2rem !important;
	padding: 15px 30px !important;
	width: 100%;
	max-width: 400px;
}

.btn-finalizar.disabled {
	background-color: var(--disabled-color);
	cursor: not-allowed;
	color: #888;
}

.btn-finalizar.disabled:hover {
	transform: none;
}

.bottom-nav {
	display: flex;
	justify-content: space-around;
	padding: 0.8rem 0;
	background-color: var(--white-color);
	box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
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
	color: #888;
	font-size: 0.7rem;
	gap: 4px;
}

.bottom-nav a .icon {
	font-size: 1.4rem;
}

.bottom-nav a.active, .bottom-nav a:hover {
	color: var(--primary-color);
}

.series-section {
	margin-top: 1.5rem;
	padding-top: 1.5rem;
	border-top: 1px solid #eee;
}

.series-list {
	list-style: none;
	margin-bottom: 1.5rem;
}

.serie-item {
	display: flex;
	justify-content: space-between;
	background-color: var(--light-color);
	padding: 0.75rem 1rem;
	border-radius: 6px;
	margin-bottom: 0.5rem;
	font-weight: 500;
}

.serie-form .form-row {
	display: grid;
	grid-template-columns: 1fr 1fr auto auto;
	gap: 1rem;
	align-items: flex-end;
}

.form-group {
	margin-bottom: 0;
}

.form-group label {
	font-size: 0.9rem;
	margin-bottom: 0.25rem;
	display: block;
}

.form-group input {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 1rem;
	font-family: 'Poppins', sans-serif;
}

.btn-concluir-exercicio {
	background-color: var(--success-color);
}

.serie-error-message {
	color: var(--error-color);
	font-weight: 500;
	margin-top: 0.5rem;
	height: 1em;
}

@media ( max-width : 768px) {
	.main-header h1 {
		font-size: 1.8rem;
	}
	.serie-form .form-row {
		grid-template-columns: 1fr;
	}
	.form-group {
		margin-bottom: 1rem;
	}
}

@media ( min-width : 992px) {
	.sidebar {
		display: block;
	}
	.main-content {
		margin-left: var(--sidebar-width);
		padding: 2rem;
	}
	.main-header h1 {
		font-size: 3rem;
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
				<li><a href="home.jsp"><i class="fas fa-home icon"></i>
						Home</a></li>
				<li><a href="TreinoServlet" class="active"><i
						class="fas fa-dumbbell icon"></i> Treino</a></li>
				<li><a href="progress.jsp"><i
						class="fas fa-chart-line icon"></i> Progresso</a></li>
				<li><a href="editarperfil.jsp"><i class="fas fa-user icon"></i>
						Perfil</a></li>
			</ul>
		</aside>

		<main class="main-content">
			<div class="main-header">
				<div>
					<h1>Executando Treino</h1>
					<p>Adicione suas séries e conclua os exercícios.</p>
				</div>
				<div class="progress-counter" id="progressCounter">
					<i class="fas fa-dumbbell"></i> <span id="completedCount">0</span>/<%=totalExercicios%>
					Concluídos
				</div>
			</div>

			<%
			if (exercicios != null && !exercicios.isEmpty()) {
			%>
			<%
			for (Exercicio ex : exercicios) {
			%>
			<div class="exercicio-card" id="card-<%=ex.getId()%>">
				<div class="exercicio-header">
					<h3><%=ex.getNome()%></h3>
					<span class="grupo-muscular"><%=ex.getGrupoMuscular()%></span>
				</div>
				<div class="exercicio-details">
					<p>
						<strong>Meta Sugerida:</strong>
						<%=ex.getRepeticoes()%></p>
				</div>

				<div class="series-section">
					<h4>Séries Realizadas</h4>
					<ul class="series-list" id="series-list-<%=ex.getId()%>">
						<%
						if (ex.getSeries() != null && !ex.getSeries().isEmpty()) {
							for (Serie s : ex.getSeries()) {
						%>
						<li class="serie-item"><span><%=s.getRepeticoes()%>
								repetições</span> <span><%=s.getPeso()%> kg</span></li>
						<%
						}
						} else {
						%>
						<li class="no-series"
							style="text-align: center; color: var(--text-muted);">Nenhuma
							série registrada.</li>
						<%
						}
						%>
					</ul>

					<form class="serie-form" data-exercicio-id="<%=ex.getId()%>">
						<input type="hidden" name="idExercicio" value="<%=ex.getId()%>">
						<input type="hidden" name="idSessao" value="<%=idSessao%>">
						<div class="form-row">
							<div class="form-group">
								<label>Repetições</label> <input type="number" name="repeticoes"
									placeholder="12" required>
							</div>
							<div class="form-group">
								<label>Peso (kg)</label> <input type="number" step="0.5"
									name="peso" placeholder="50.5" required>
							</div>
							<div class="form-group">
								<button type="submit" class="btn">
									<i class="fas fa-plus"></i> Adicionar Série
								</button>
							</div>
							<div class="form-group">
								<button type="button" class="btn btn-concluir-exercicio"
									data-exercicio-id="<%=ex.getId()%>">
									<i class="fas fa-check"></i> Concluir
								</button>
							</div>
						</div>
						<div class="serie-error-message" id="error-<%=ex.getId()%>"></div>
					</form>
				</div>
			</div>
			<%
			}
			%>

			<div class="finalizar-treino-container">
				<h2>Tudo pronto?</h2>
				<p>Finalize sua sessão para salvar seu progresso.</p>
				<form action="FinalizarTreinoServlet" method="post"
					id="finalizarTreinoForm">
					<input type="hidden" name="idSessao" value="<%=idSessao%>">
					<input type="hidden" name="idTreino" value="<%=idTreino%>">
					<button type="submit" id="finalizarBtn"
						class="btn btn-success btn-finalizar disabled">
						<i class="fas fa-flag-checkered"></i> Finalizar Treino
					</button>
				</form>
			</div>
			<%
			} else {
			%>
			<div class="card">
				<h2>Nenhum Exercício</h2>
				<p>Este treino ainda não possui exercícios cadastrados.</p>
			</div>
			<%
			}
			%>

			<a href="TreinoServlet" class="btn" style="margin-top: 2rem;">Voltar
				para a Lista de Treinos</a>
		</main>

		<nav class="bottom-nav">
			<a href="home.jsp"><i class="fas fa-home icon"></i> Home</a> <a
				href="TreinoServlet" class="active"><i
				class="fas fa-dumbbell icon"></i> Treino</a> <a href="progress.jsp"><i
				class="fas fa-chart-line icon"></i> Progresso</a> <a
				href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a>
		</nav>
	</div>

	<script>
        document.addEventListener('DOMContentLoaded', () => {
            let completedCount = 0;
            const totalExercicios = <%=totalExercicios%>;
            const completedCountSpan = document.getElementById('completedCount');
            const finalizarBtn = document.getElementById('finalizarBtn');
            finalizarBtn.disabled = true;

            function updateProgress() {
                completedCount++;
                completedCountSpan.textContent = completedCount;
                if (completedCount >= 1) {
                    finalizarBtn.classList.remove('disabled');
                    finalizarBtn.disabled = false;
                }
            }

            document.querySelectorAll('.serie-form').forEach(form => {
                form.addEventListener('submit', function(event) {
                    event.preventDefault();
                    
                    const exercicioId = this.dataset.exercicioId;
                    const seriesList = document.getElementById('series-list-' + exercicioId);
                    const noSeriesMsg = seriesList.querySelector('.no-series');
                    const errorMessageDiv = document.getElementById('error-' + exercicioId);
                    
                    const repeticoesInput = this.querySelector('input[name="repeticoes"]');
                    const pesoInput = this.querySelector('input[name="peso"]');
                    const repeticoesValue = repeticoesInput.value;
                    const pesoValue = pesoInput.value;
                    
                    const formData = new URLSearchParams(new FormData(this));

                    fetch('AdicionarSerieServlet', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.json())
                    .then(data => {
                        errorMessageDiv.textContent = '';
                        if (data.status === 'success') {
                            if (noSeriesMsg) {
                                noSeriesMsg.remove();
                            }
                            const newSerieItem = document.createElement('li');
                            newSerieItem.className = 'serie-item';
                            newSerieItem.innerHTML = `<span>${repeticoesValue} repetições</span><span>${pesoValue} kg</span>`;
                            seriesList.appendChild(newSerieItem);
                            this.reset();
                            repeticoesInput.focus();
                        } else {
                            errorMessageDiv.textContent = data.message;
                        }
                    })
                    .catch(error => {
                        console.error('Erro no fetch:', error);
                        errorMessageDiv.textContent = 'Não foi possível adicionar a série.';
                    });
                });
            });

            document.querySelectorAll('.btn-concluir-exercicio').forEach(button => {
                button.addEventListener('click', function(event) {
                    const exercicioId = this.dataset.exercicioId;
                    const card = document.getElementById('card-' + exercicioId);
                    
                    const params = new URLSearchParams();
                    params.append('idExercicio', exercicioId);
                    params.append('idSessao', '<%=idSessao%>');
                    
                    fetch('MarcarExercicioServlet', {
                        method: 'POST',
                        body: params
                    })
                    .then(response => response.ok ? response.json() : Promise.reject('Erro de rede'))
                    .then(data => {
                        if (data.status === 'success') {
                            card.classList.add('concluido');
                            card.querySelectorAll('.serie-form input, .serie-form button, .btn-concluir-exercicio').forEach(el => {
                                el.disabled = true;
                            });
                            this.innerHTML = '<i class="fas fa-check-circle"></i> Concluído';
                            updateProgress();
                        } else {
                            alert('Erro ao concluir o exercício: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Erro no fetch:', error);
                        alert('Não foi possível concluir o exercício.');
                    });
                });
            });
        });
    </script>
</body>
</html>