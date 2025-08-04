<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String usuario = (session != null) ? (String) session.getAttribute("usuario") : null;

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Strive - Home</title>
</head>
<body>
    <h1>Bem-vindo, <%= usuario %>!</h1>
    <p>Você está logado com sucesso no sistema Strive.</p>
    <a href="LogoutServlet">Sair</a>
</body>
</html>
