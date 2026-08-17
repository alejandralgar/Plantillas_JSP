<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar usuario</title>
    <link rel="stylesheet" href="css/editar.css">
</head>
<body>

<%
    // Solo admin puede entrar a esta página (mismo control de rol que dashboard.jsp)
    String usuarioLogueado = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
    if (usuarioLogueado == null) {
        response.sendRedirect("index.jsp?error=sesion");
        return;
    }
    if (!"admin".equals(rol)) {
        response.sendRedirect("error.jsp");
        return;
    }

    // Misma lista compartida en application scope que usa dashboard.jsp
    List<String[]> usuarios = (List<String[]>) application.getAttribute("usuarios");
    if (usuarios == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    // POST: guardar cambios
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("guardar") != null) {
        String usuarioOriginal = request.getParameter("usuarioOriginal");
        String nombre  = request.getParameter("nombre");
        String correo  = request.getParameter("correo");
        String estado  = request.getParameter("estado");

        for (String[] u : usuarios) {
            if (u[0].equals(usuarioOriginal)) {
                u[1] = nombre;
                u[2] = correo;
                u[3] = estado;
                break;
            }
        }
        response.sendRedirect("dashboard.jsp");
        return;
    }

    // GET: buscar usuario a editar
    String usuarioParam = request.getParameter("usuario");
    String[] usuarioEncontrado = null;
    for (String[] u : usuarios) {
        if (u[0].equals(usuarioParam)) {
            usuarioEncontrado = u;
            break;
        }
    }
    if (usuarioEncontrado == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<div class="card">
    <h2>Editar usuario</h2>

    <form method="post" action="editar.jsp">
        <input type="hidden" name="usuarioOriginal" value="<%= usuarioEncontrado[0] %>">
        <input type="hidden" name="guardar" value="1">

        <div class="form-group">
            <label>Usuario</label>
            <input type="text" value="<%= usuarioEncontrado[0] %>" disabled>
        </div>
        <div class="form-group">
            <label for="nombre">Nombre</label>
            <input type="text" id="nombre" name="nombre" value="<%= usuarioEncontrado[1] %>" required>
        </div>
        <div class="form-group">
            <label for="correo">Correo</label>
            <input type="text" id="correo" name="correo" value="<%= usuarioEncontrado[2] %>" required>
        </div>
        <div class="form-group">
            <label for="estado">Estado</label>
            <select id="estado" name="estado">
                <option value="activo"   <%= "activo".equals(usuarioEncontrado[3])   ? "selected" : "" %>>Activo</option>
                <option value="inactivo" <%= "inactivo".equals(usuarioEncontrado[3]) ? "selected" : "" %>>Inactivo</option>
            </select>
        </div>

        <button type="submit">Guardar cambios</button>
        <a href="dashboard.jsp" class="cancelar">Cancelar</a>
    </form>
</div>

</body>
</html>
