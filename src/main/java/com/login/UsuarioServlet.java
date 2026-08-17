package com.login;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet que maneja el login y logout de usuarios.
 * Usuarios válidos: admin/1234, usuario1/1234, usuario2/1234
 */
public class UsuarioServlet extends HttpServlet {

    // Credenciales hardcodeadas para el ejemplo (en producción usar BD)
    private static final Map<String, String[]> USUARIOS = new HashMap<>();

    static {
        // formato: usuario -> [contraseña, rol]
        USUARIOS.put("admin",    new String[]{"1234", "admin"});
        USUARIOS.put("usuario1", new String[]{"1234", "usuario"});
        USUARIOS.put("usuario2", new String[]{"1234", "usuario"});
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario  = request.getParameter("usuario");
        String password = request.getParameter("password");

        // Validar campos vacíos
        if (usuario == null || usuario.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            response.sendRedirect("index.jsp?error=vacio&usuario=" + (usuario != null ? usuario : ""));
            return;
        }

        // Validar credenciales
        String[] datos = USUARIOS.get(usuario.trim());
        if (datos != null && datos[0].equals(password)) {
            // Login exitoso — guardar datos en sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario.trim());
            session.setAttribute("rol",     datos[1]);
            response.sendRedirect("dashboard.jsp");
        } else {
            // Credenciales incorrectas
            response.sendRedirect("index.jsp?error=credenciales&usuario=" + usuario.trim());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Manejar logout
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("index.jsp");
    }
}
