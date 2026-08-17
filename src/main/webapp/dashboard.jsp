<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<%
    // Verificar sesión — si no hay usuario en sesión, redirigir
    String usuarioLogueado = (String) session.getAttribute("usuario");
    if (usuarioLogueado == null) {
        response.sendRedirect("index.jsp?error=sesion");
        return;
    }

    // Determinar rol del usuario (condicional)
    String rol = (String) session.getAttribute("rol");
%>

<header>
    <span>Panel Principal</span>
    <span>
        Bienvenido, <strong><%= usuarioLogueado %></strong>
        &nbsp;|&nbsp;
        <a href="logout">Cerrar sesión</a>
    </span>
</header>

<div class="container">

    <div class="bienvenida">
        <p>Hola, <strong><%= usuarioLogueado %></strong>.</p>
        <p style="margin-top:8px">
            Tu rol:
            <%-- CONDICIONAL: badge según rol --%>
            <% if ("admin".equals(rol)) { %>
                <span class="badge admin">Administrador</span>
            <% } else { %>
                <span class="badge usuario">Usuario</span>
            <% } %>
        </p>

        <%-- CONDICIONAL: mensaje extra solo para admin --%>
        <% if ("admin".equals(rol)) { %>
            <p style="margin-top:10px; color:#888; font-size:13px">
                Tienes acceso completo al sistema.
            </p>
        <% } %>
    </div>

    <p class="section-title">Lista de usuarios registrados</p>

    <%
    // Datos de ejemplo — en un proyecto real vendrían de la BD.
    // Se guardan en application scope para que la edición persista entre requests
    // (sobrevive mientras el servidor esté corriendo; no hay BD en este proyecto).
    List<String[]> usuarios = (List<String[]>) application.getAttribute("usuarios");
    if (usuarios == null) {
        usuarios = new ArrayList<String[]>();
        usuarios.add(new String[]{"admin",    "Administrador", "admin@mail.com",    "activo"});
        usuarios.add(new String[]{"devmaster",  "Jorge Ramírez",   "jorge.ramirez@ejemplo.com",   "activo"});
        usuarios.add(new String[]{"editorX",    "Camila Fernández","camila.fernandez@ejemplo.com","inactivo"});
        usuarios.add(new String[]{"testerQA",   "Andrés Molina",   "andres.molina@ejemplo.com",   "activo"});
        usuarios.add(new String[]{"guestUser",  "Sofía Herrera",   "sofia.herrera@ejemplo.com",   "inactivo"});
        application.setAttribute("usuarios", usuarios);
    }
    %>


    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Usuario</th>
                <th>Nombre</th>
                <th>Correo</th>
                <th>Estado</th>
                <%-- CONDICIONAL: columna acciones solo para admin --%>
                <% if ("admin".equals(rol)) { %>
                    <th>Acciones</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
            <%-- BUCLE: iterar la lista de usuarios --%>
            <% for (int i = 0; i < usuarios.size(); i++) {
                   String[] u = usuarios.get(i);
            %>
            <tr>
                <td><%= i + 1 %></td>
                <td><%= u[0] %></td>
                <td><%= u[1] %></td>
                <td><%= u[2] %></td>
                <td>
                    <%-- CONDICIONAL: color según estado --%>
                    <% if ("activo".equals(u[3])) { %>
                        <span class="estado-activo">Activo</span>
                    <% } else { %>
                        <span class="estado-inactivo">Inactivo</span>
                    <% } %>
                </td>
                <% if ("admin".equals(rol)) { %>
                    <td>
                        <a href="editar.jsp?usuario=<%= java.net.URLEncoder.encode(u[0], "UTF-8") %>"
                           style="color:#4a90e2; font-size:13px">Editar</a>
                    </td>
                <% } %>
            </tr>
            <% } %>
        </tbody>
    </table>

</div>
</body>
</html>
