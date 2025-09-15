<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Strive - Eleve seu Treino</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #6a0dad;
        --secondary-color: #8A2BE2;
        --dark-color: #1a1a1a;
        --light-color: #f4f4f4;
        --text-color: #333;
        --white-color: #fff;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    html {
        scroll-behavior: smooth;
    }

    body {
        font-family: 'Poppins', sans-serif;
        background-color: var(--white-color);
        color: var(--text-color);
        line-height: 1.6;
    }

    .container {
        max-width: 1100px;
        margin: auto;
        padding: 0 2rem;
    }

    h1, h2 {
        font-weight: 600;
        line-height: 1.2;
    }

    h1 { font-size: 3rem; }
    h2 { font-size: 2.5rem; }
    
    a {
        text-decoration: none;
        color: var(--primary-color);
    }
    
    section {
        padding: 5rem 0;
    }

    .btn {
        display: inline-block;
        background: var(--primary-color);
        color: var(--white-color);
        padding: 12px 30px;
        font-size: 1.1rem;
        font-weight: 600;
        border-radius: 10px;
        transition: transform 0.3s ease, background-color 0.3s ease;
    }

    .btn:hover {
        background-color: var(--secondary-color);
        transform: scale(1.05);
    }

    .navbar {
        background: var(--white-color);
        color: var(--text-color);
        padding: 1rem 0;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        transition: background-color 0.3s ease;
    }

    .navbar .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .navbar .logo {
        font-size: 2rem;
        font-weight: 700;
        color: var(--primary-color);
        transition: transform 0.3s ease;
    }
    
    .navbar .logo:hover {
        transform: scale(1.1);
    }

    .navbar .nav-links {
        list-style: none;
        display: flex;
    }
    
    .navbar .nav-links li {
        margin-left: 25px;
        font-size: 25px;
    }
    
    .navbar .nav-links a {
        font-weight: 600;
        color: var(--text-color);
        transition: color 0.3s ease;
    }
    
    .navbar .nav-links a:hover {
        color: var(--primary-color);
    }
    
    .hamburger {
        display: none;
        cursor: pointer;
    }
    
    .hamburger .line {
        width: 25px;
        height: 3px;
        background-color: var(--dark-color);
        margin: 5px 0;
        transition: all 0.3s ease;
    }

    .hero {
        height: 100vh;
        background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('imagens/imagemfUNDO.jpg') no-repeat center center/cover;
        color: var(--white-color);
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        padding-top: 60px;
    }

    .hero h1 {
        font-size: 4rem;
        margin-bottom: 1rem;
        margin-left: 1rem;
        margin-right: 1rem;
    }
    
    .hero p {
        font-size: 1.5rem;
        font-weight: 300;
        margin-bottom: 2rem;
        margin-left: 0.5rem;
        margin-right: 0.5rem;
    }

    #features {
        background-color: var(--dark-color);
        color: var(--white-color);
    }
    
    .features-header {
        text-align: center;
        margin-bottom: 3rem;
    }
    
    .features-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 2rem;
        max-width: 800px;
        margin: auto;
    }
    
    .feature-card {
        background: #252525;
        padding: 2rem;
        text-align: center;
        border-radius: 10px;
        border: 1px solid #444;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .feature-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.2);
    }
    
    .feature-card .icon {
        font-size: 3rem;
        margin-bottom: 1rem;
    }
    
    .feature-card h3 {
        font-size: 1.5rem;
        margin-bottom: 0.5rem;
        color: var(--white-color);
    }

    footer {
        background: var(--dark-color);
        color: var(--light-color);
        text-align: center;
        padding: 2rem 0;
    }
    
    @media(max-width: 768px) {
        h1 { font-size: 2.5rem; }
        h2 { font-size: 2rem; }

        .navbar .container {
            padding: 0 1.5rem;
        }

        .nav-links {
            position: absolute;
            right: -100%;
            top: 70px;
            background: var(--white-color);
            flex-direction: column;
            width: 100%;
            text-align: center;
            transition: right 0.3s ease-in-out;
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }

        .nav-links li {
            margin: 1.5rem 0;
        }
        
        .nav-links.nav-active {
            right: 0;
        }
        
        .hamburger {
            display: block;
        }
        
        .hamburger.toggle .line1 {
            transform: rotate(-45deg) translate(-5px, 6px);
        }
        .hamburger.toggle .line2 {
            opacity: 0;
        }
        .hamburger.toggle .line3 {
            transform: rotate(45deg) translate(-5px, -6px);
        }

        .hero h1 { font-size: 3rem; }
        .features-grid { grid-template-columns: 1fr; }
    }
</style>
</head>
<body>

    <header class="navbar">
        <div class="container">
            <a href="#" class="logo">Strive</a>
            <ul class="nav-links">
                <li><a href="HomePadrao.jsp">Home</a></li>
                <li><a href="#features">Sobre</a></li>
                <li><a href="register.jsp">Cadastro</a></li>
                <li><a href="login.jsp">Login</a></li>
            </ul>
            <div class="hamburger">
                <div class="line line1"></div>
                <div class="line line2"></div>
                <div class="line line3"></div>
            </div>
        </div>
    </header>

    <main>
        <section class="hero" id="hero">
            <h1>Eleve Seu Treino a um Novo Nível</h1>
            <p>Sua jornada para uma vida mais forte e saudável começa aqui.</p>
            <a href="register.jsp" class="btn">Comece a Treinar Agora</a>
        </section>

        <section id="features">
             <div class="container">
                <div class="features-header">
                    <h2>Tudo que você precisa para evoluir</h2>
                    <p>Nossa plataforma oferece ferramentas completas para o seu sucesso.</p>
                </div>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="icon">🏋️</div>
                        <h3>Treinos Personalizados</h3>
                        <p>Receba treinos montados por especialistas e adaptados aos seus objetivos e nível de experiência.</p>
                    </div>
                    <div class="feature-card">
                        <div class="icon">📈</div>
                        <h3>Acompanhe seu Progresso</h3>
                        <p>Visualize sua evolução com gráficos de cargas, medidas corporais e fotos comparativas.</p>
                    </div>
                </div>
             </div>
        </section>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2025 Strive. Todos os direitos reservados.</p>
        </div>
    </footer>

    <script>
        const hamburger = document.querySelector('.hamburger');
        const navLinks = document.querySelector('.nav-links');

        hamburger.addEventListener('click', () => {
            navLinks.classList.toggle('nav-active');
            hamburger.classList.toggle('toggle');
        });
    </script>

</body>
</html>
