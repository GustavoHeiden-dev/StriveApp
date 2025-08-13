<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
   <title>Login - Strive</title>
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
   <link >
   <style>
       :root {
           --soft-purple-1: #9575cd;
           --soft-purple-2: #673ab7;
           --primary-purple: #6a1b9a;
           --light-purple: #8e24aa;
           --white-bg: #ffffff;
           --light-gray-border: #e0e0e0;
           --gray-text: #6c757d;
           --dark-text: #343a40;
       }
       body {
           font-family: 'Poppins', sans-serif;
           margin: 0;
           padding: 0;
           overflow: hidden;
       }
       .login-container {
           display: flex;
           height: 100vh;
           width: 100vw;
       }
       .brand-panel {
           flex: 1;
           position: relative;
           display: flex;
           justify-content: center;
           align-items: center;
           background-image: linear-gradient(
               135deg,
               var(--soft-purple-1),
               var(--soft-purple-2)
           );
       }
       .brand-panel h1 {
           font-size: 5rem;
           font-weight: 700;
           letter-spacing: 4px;
           color: var(--white-bg);
           text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
           z-index: 10;
       }
       .form-panel {
           flex: 1;
           display: flex;
           justify-content: center;
           align-items: center;
           background-color: #f4f7f6;
           padding: 40px;
       }
       .form-container {
           width: 100%;
           max-width: 380px;
       }
       .form-container h2 {
           font-size: 2.5rem;
           color: var(--dark-text);
           margin-bottom: 10px;
           font-weight: 600;
       }
       .form-container p {
           color: var(--gray-text);
           margin-bottom: 40px;
           font-size: 1rem;
       }
       .input-label {
           display: block;
           margin-bottom: 8px;
           color: var(--dark-text);
           font-weight: 600;
           font-size: 0.9rem;
       }
       .form-input {
           width: 100%;
           padding: 14px;
           margin-bottom: 25px;
           border: 1px solid var(--light-gray-border);
           border-radius: 8px;
           font-size: 1rem;
           color: var(--dark-text);
           background-color: #f8f9fa;
           transition: border-color 0.3s, box-shadow 0.3s;
       }
       .form-input:focus {
           outline: none;
           border-color: var(--primary-purple);
           box-shadow: 0 0 8px rgba(106, 27, 154, 0.25);
           background-color: var(--white-bg);
       }
       .btn {
           width: 100%;
           padding: 15px;
           background-color: var(--primary-purple);
           color: white;
           border: none;
           border-radius: 8px;
           font-weight: 600;
           font-size: 1.1rem;
           cursor: pointer;
           transition: background-color 0.3s, transform 0.2s;
       }
       .btn:hover {
           background-color: var(--light-purple);
           transform: translateY(-2px);
       }
       .register-link-container {
           margin-top: 25px;
           text-align: center;
           color: var(--gray-text);
       }
       .register-link-container a {
           color: var(--primary-purple);
           font-weight: 600;
           text-decoration: none;
           transition: color 0.3s;
       }
       .register-link-container a:hover {
           color: var(--light-purple);
           text-decoration: underline;
       }
       @media (max-width: 800px) {
           .brand-panel {
               display: none;
           }
           .form-panel {
               flex-basis: 100%;
           }
       }
   </style>
</head>
<body>
   <div class="login-container">
       <div class="brand-panel">
           <h1>STRIVE</h1>
       </div>
       <div class="form-panel">
           <div class="form-container">
               <h2>Bem-vindo!</h2>
               <p>Entre na sua conta para continuar.</p>
               <form method="post" action="LoginServlet">
                   <label for="email" class="input-label">Seu Email</label>
                   <input type="email" id="email" name="email" class="form-input" required>
                   <label for="password" class="input-label">Sua Senha</label>
                   <input type="password" id="password" name="password" class="form-input" required>
                   <button type="submit" class="btn">Entrar</button>
               </form>
               <div class="register-link-container">
                   <span>Não tem uma conta?</span>
                   <a href="register.jsp">Crie uma agora</a>
               </div>
           </div>
       </div>
   </div>
</body>
</html>
