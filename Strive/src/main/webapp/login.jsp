<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
   <title>Login - Strive</title>
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
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-color);
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Painel da Esquerda (Imagem) */
        .image-panel {
            flex: 1;
            background: linear-gradient(to top, rgba(0,0,0,0.85), rgba(0,0,0,0.2)), url('https://images.unsplash.com/photo-1548690312-e3b507d8c110?q=80&w=1964&auto=format&fit=crop') center center/cover;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 50px;
            color: var(--white-color);
        }

        .image-panel h1 {
            font-size: 3.5rem;
            margin: 0;
            font-weight: 700;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7);
        }

        .image-panel p {
            font-size: 1.2rem;
            max-width: 400px;
            font-weight: 300;
        }

        /* Painel da Direita (Formulário) */
        .form-panel {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .form-container {
            width: 100%;
            max-width: 400px;
        }

        .form-container h2 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 10px;
        }

        .form-container .subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        
        .input-wrapper {
            position: relative;
            margin-bottom: 20px;
        }

        .input-wrapper .icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }
        
        .form-input {
            width: 100%;
            padding: 14px 14px 14px 45px; /* Espaço para o ícone */
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 8px rgba(106, 29, 173, 0.2);
        }

        .options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            font-size: 0.9rem;
        }

        .options a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            cursor: pointer;
            transition: transform 0.2s, background-color 0.3s;
        }

        .btn-submit:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }

        .register-link {
            margin-top: 25px;
            display: block;
            text-align: center;
            color: #555;
        }

        .register-link a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }
        
        /* --- DESIGN RESPONSIVO (MOBILE) --- */
        @media (max-width: 900px) {
            .container {
                flex-direction: column;
            }

            .image-panel {
                flex: none; /* Remove a flexibilidade */
                height: 30vh; /* Altura do cabeçalho no mobile */
                justify-content: center;
                text-align: center;
                padding: 20px;
            }
            .image-panel h1 { font-size: 2.5rem; }
            .image-panel p { display: none; } /* Esconde o subtítulo */

            .form-panel {
                padding: 30px 20px;
            }
            
            .form-container h2 { font-size: 2rem; }
        }

        /* --- AJUSTES PARA DESKTOPS MAIORES --- */
        @media (min-width: 1200px) {
            .form-container {
                max-width: 450px; /* Um pouco mais de espaço */
            }
            .form-container h2 {
                font-size: 2.8rem; /* Título maior */
            }
            .form-container .subtitle {
                font-size: 1.1rem; /* Subtítulo maior */
            }
            .form-input {
                font-size: 1.1rem; /* Texto dos inputs maior */
                padding: 16px 16px 16px 45px; /* Aumenta o padding para acompanhar a fonte */
            }
            .btn-submit {
                font-size: 1.2rem; /* Botão com texto maior */
                padding: 16px;
            }
            .options, .register-link {
                font-size: 1rem; /* Links um pouco maiores */
            }
        }
   </style>
</head>
<body>
   <div class="container">
       <div class="image-panel">
           <div>
                <h1>STRIVE</h1>
                <p>Continue sua jornada rumo à sua melhor versão.</p>
           </div>
       </div>
       <div class="form-panel">
           <div class="form-container">
               <h2>Bem-vindo de volta!</h2>
               <p class="subtitle">Faça o login para acessar seus treinos.</p>
               <form method="post" action="LoginServlet">

                   <div class="input-wrapper">
                        <i class="fa-solid fa-envelope icon"></i>
                        <input type="email" id="email" name="email" class="form-input" placeholder="Seu email" required>
                   </div>
                   
                   <div class="input-wrapper">
                        <i class="fa-solid fa-lock icon"></i>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Sua senha" required>
                   </div>
                   
                   <div class="options">
                        <div>
                            </div>
                        <a href="#">Esqueci minha senha</a>
                   </div>

                   <button type="submit" class="btn-submit">Entrar</button>
               </form>
               <p class="register-link">
                   Ainda não tem uma conta? <a href="register.jsp">Crie uma agora</a>
               </p>
           </div>
       </div>
   </div>
</body>
</html>