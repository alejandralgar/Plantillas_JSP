<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio de Sesión</title>
    <link rel="stylesheet" href="css/index.css">
</head>
<body>

<div class="card">
    <h2>Iniciar Sesión</h2>

    <%-- CONDICIONAL: mostrar error si el parámetro 'error' está presente --%>
    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
        <div class="error-msg">
            <% if (error.equals("credenciales")) { %>
                Usuario o contraseña incorrectos.
            <% } else if (error.equals("vacio")) { %>
                Por favor completa todos los campos.
            <% } else { %>
                Error desconocido. Intenta de nuevo.
            <% } %>
        </div>
    <% } %>

    <form method="post" action="login">
        <div class="form-group">
            <label for="usuario">Usuario</label>
            <input type="text" id="usuario" name="usuario"
                   value="<%= request.getParameter("usuario") != null ? request.getParameter("usuario") : "" %>"
                   placeholder="Ingresa tu usuario">
        </div>
        <div class="form-group">
            <label for="password">Contraseña</label>
            <input type="password" id="password" name="password" placeholder="Ingresa tu contraseña">
        </div>
        <button type="submit">Entrar</button>
    </form>

    <%-- BUCLE: mostrar usuarios de prueba disponibles --%>
    <div class="hint">
        <strong>Usuarios de prueba:</strong><br>
        <%
            String[] usuariosPrueba = {"admin", "devmaster", "editorX", "testerQA", "guestUser"};
            for (int i = 0; i < usuariosPrueba.length; i++) {
        %>
            <%= usuariosPrueba[i] %><%= (i < usuariosPrueba.length - 1) ? ", " : "" %>
        <%
            }
        %>
        (contraseña: <em>1234</em>)
    </div>
</div>

</body>
</html>
