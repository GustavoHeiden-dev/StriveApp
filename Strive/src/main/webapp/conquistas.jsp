<%@ page contentType="text/html;charset=UTF-8" import="Modelos.Usuario"%>
<%
Usuario usuario = (Usuario) session.getAttribute("usuario");
if (usuario == null) {
	response.sendRedirect("login.jsp");
	return;
}
int treinosConcluidos = 0;
if (request.getAttribute("treinosConcluidos") != null) {
	treinosConcluidos = (Integer) request.getAttribute("treinosConcluidos");
}

class Conquista {
	String nome, descricao, icone;
	int meta;
	double progresso;
	boolean concluido;
	Conquista(String nome, String descricao, String icone, int meta, int feitos) {
		this.nome = nome;
		this.descricao = descricao;
		this.icone = icone;
		this.meta = meta;
		this.progresso = Math.min(100.0, ((double) feitos / meta) * 100);
		this.concluido = this.progresso >= 100;
	}
}

java.util.List<Conquista> conquistas = new java.util.ArrayList<>();
conquistas.add(new Conquista("Iniciante", "Complete seu primeiro treino.", "fas fa-rocket", 1, treinosConcluidos));
conquistas.add(new Conquista("Regular", "Complete 10 treinos.", "fas fa-running", 10, treinosConcluidos));
conquistas.add(new Conquista("Determinado", "Complete 50 treinos.", "fas fa-trophy", 50, treinosConcluidos));
conquistas.add(new Conquista("Persistente", "Complete 100 treinos.", "fas fa-fire", 100, treinosConcluidos));
conquistas.add(new Conquista("Focado", "Complete 200 treinos.", "fas fa-bolt", 200, treinosConcluidos));
conquistas.add(new Conquista("Maratonista", "Complete 500 treinos.", "fas fa-medal", 500, treinosConcluidos));
conquistas.add(new Conquista("Assíduo", "Treine todos os dias por 7 dias seguidos.", "fas fa-calendar-day", 7,
		treinosConcluidos));
conquistas.add(new Conquista("Sem Descanso", "Treine todos os dias por 30 dias seguidos.", "fas fa-calendar-week", 30,
		treinosConcluidos));
conquistas.add(new Conquista("Campeão", "Complete 1000 treinos.", "fas fa-crown", 1000, treinosConcluidos));
conquistas.add(new Conquista("Lenda", "Complete 2000 treinos.", "fas fa-star", 2000, treinosConcluidos));

java.util.List<Conquista> conquistasAtivas = new java.util.ArrayList<>();
java.util.List<Conquista> conquistasConcluidas = new java.util.ArrayList<>();
for (Conquista c : conquistas) {
	if (c.concluido)
		conquistasConcluidas.add(c);
	else
		conquistasAtivas.add(c);
}
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<title>Minhas Conquistas - Strive</title>
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
	--gold-color: #FFD700;
	--bg-light: #f8f7ff;
	--bg-card: #ffffff;
	--bg-sidebar: #f0f0f5;
	--text-dark: #333;
	--text-muted: #666;
	--border-radius: 12px;
	--shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
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
	background-color: var(--bg-sidebar);
	height: 100vh;
	position: fixed;
	left: 0;
	top: 0;
	padding: 2rem 1rem;
	border-right: 1px solid #ddd;
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
	margin-left: 0;
}

.main-header {
	margin-bottom: 2rem;
}

.main-header h1 {
	font-size: 2.5rem;
	margin-bottom: 0.5rem;
}

.main-header p {
	color: var(--text-muted);
	margin-bottom: 1rem;
}

.conquistas-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 1rem;
}

.conquista-card {
	background: var(--bg-card);
	border-radius: var(--border-radius);
	padding: 1rem;
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 0.5rem;
	position: relative;
	box-shadow: var(--shadow);
}

.conquista-icon {
	font-size: 2rem;
	color: var(--primary-color);
	width: 60px;
	height: 60px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #f1ebff;
}

.conquista-info h3 {
	font-size: 1rem;
	text-align: center;
	margin: 0;
}

.conquista-info p {
	font-size: 0.8rem;
	text-align: center;
	color: var(--text-muted);
	margin: 0.25rem 0;
}

.progress-bar-container {
	width: 80%;
	height: 6px;
	background: #eee;
	border-radius: 10px;
	overflow: hidden;
	margin-top: 0.25rem;
}

.progress-bar {
	height: 100%;
	width: 0%;
	background: var(--primary-color);
	transition: width 0.5s;
	border-radius: 10px;
}

.progress-bar.concluido {
	background: var(--gold-color);
}

.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	justify-content: center;
	align-items: center;
	z-index: 10000;
}

.modal-content {
	background: #fff;
	padding: 2rem;
	border-radius: 12px;
	max-width: 500px;
	width: 90%;
	max-height: 80%;
	overflow-y: auto;
	position: relative;
}

.modal h2 {
	margin-bottom: 1rem;
}

.close-modal {
	position: absolute;
	top: 10px;
	right: 10px;
	cursor: pointer;
	font-size: 1.2rem;
}

.parabens-toast {
	position: fixed;
	top: 20px;
	left: 50%;
	transform: translateX(-50%);
	background: var(--gold-color);
	color: #333;
	padding: 1rem 2rem;
	border-radius: 12px;
	display: none;
	font-weight: 600;
	box-shadow: var(--shadow);
	z-index: 10000;
}

.bottom-nav {
	display: flex;
	justify-content: space-around;
	padding: 0.8rem 0;
	background: var(--bg-sidebar);
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
	color: #888;
	font-size: 0.7rem;
	gap: 4px;
	flex-basis: 0;
	flex-grow: 1;
	text-align: center;
}

.bottom-nav a .icon {
	font-size: 1.4rem;
}

.bottom-nav a.active, .bottom-nav a:hover {
	color: var(--primary-color);
}

@media ( min-width :992px) {
	.sidebar {
		display: block;
	}
	.main-content {
		margin-left: var(--sidebar-width);
	}
	.bottom-nav {
		display: none;
	}
}

@media ( max-width :768px) {
	.main-header h1 {
		font-size: 2rem;
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
				<li><a href="TreinoServlet"><i class="fas fa-dumbbell icon"></i>
						Treino</a></li>
				<li><a href="editarperfil.jsp"><i class="fas fa-user icon"></i>
						Perfil</a></li>
				<li><a href="SairServlet"><i
						class="fas fa-sign-out-alt icon"></i> Sair</a></li>
			</ul>
		</aside>

		<main class="main-content">
			<div class="main-header">
				<h1>Minhas Conquistas</h1>
				<p>Veja seu progresso e as medalhas que você ganhou!</p>
			</div>
			<div class="conquistas-grid">
				<%
				for (Conquista c : conquistasAtivas) {
				%>
				<div class="conquista-card">
					<div class="conquista-icon">
						<i class="<%=c.icone%>"></i>
					</div>
					<div class="conquista-info">
						<h3><%=c.nome%></h3>
						<p><%=c.descricao%></p>
						<div class="progress-bar-container">
							<div class="progress-bar" style="width:<%=c.progresso%>%"></div>
						</div>
						<p><%=(int) c.progresso%>
							%
						</p>
					</div>
				</div>
				<%
				}
				%>
			</div>
			<button id="verConquistas"
				style="margin-top: 2rem; padding: 0.7rem 1.2rem; border: none; background: var(--primary-color); color: #fff; border-radius: 8px; cursor: pointer;">Ver
				conquistas concluídas</button>
		</main>

		<nav class="bottom-nav">
			<a href="home.jsp"><i class="fas fa-home icon"></i> Home</a> <a
				href="TreinoServlet"><i class="fas fa-dumbbell icon"></i> Treino</a>
			<a href="editarperfil.jsp"><i class="fas fa-user icon"></i> Perfil</a>
			<a href="SairServlet"><i class="fas fa-sign-out-alt icon"></i>
				Sair</a>
		</nav>
	</div>

	<div class="modal" id="modalConquistas">
		<div class="modal-content">
			<span class="close-modal" id="closeModal">&times;</span>
			<h2>Conquistas Concluídas</h2>
			<ul>
				<%
				for (Conquista c : conquistasConcluidas) {
				%>
				<li><i class="<%=c.icone%>"
					style="color: var(--gold-color); margin-right: 0.5rem;"></i><%=c.nome%>
					- <%=c.descricao%></li>
				<%
				}
				%>
			</ul>
		</div>
	</div>

	<div class="parabens-toast" id="parabensToast">Parabéns!
		Conquista concluída!</div>

	<script>
        const verBtn = document.getElementById('verConquistas');
        const modal = document.getElementById('modalConquistas');
        const closeModal = document.getElementById('closeModal');
        verBtn.onclick = ()=> modal.style.display='flex';
        closeModal.onclick = ()=> modal.style.display='none';
        window.onclick = e=> { if(e.target == modal) modal.style.display='none'; }

        window.addEventListener('load', ()=>{
            const toast = document.getElementById('parabensToast');
            <%if (!conquistasConcluidas.isEmpty()) {%>
                toast.style.display='block';
                setTimeout(()=>{ toast.style.display='none'; }, 3000);
            <%}%>
        });
    </script>
</body>
</html>