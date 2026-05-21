package com.coursevault.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;
import java.math.BigInteger;

/**
 * Simple CSRF protection filter.
 *
 * - Generates a token stored in the user's session (attribute "csrfToken").
 * - For any state‑changing HTTP method (POST, PUT, DELETE, PATCH) the request must contain a parameter
 *   named "csrfToken" whose value matches the session token.
 * - If the token is missing or does not match, the filter sends HTTP 403.
 * - The filter also adds the token as a request attribute ("csrfToken") so JSP pages can render it in forms.
 */
public class CsrfFilter implements Filter {
    private static final String TOKEN_ATTR = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No init needed
    }

    private String generateToken() {
        // 130‑bit token gives ~2^130 possibilities; encoded as base‑36 string.
        return new BigInteger(130, RANDOM).toString(36);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(true); // create if missing
        String token = (String) session.getAttribute(TOKEN_ATTR);
        if (token == null) {
            token = generateToken();
            session.setAttribute(TOKEN_ATTR, token);
        }
        // expose token for JSPs
        req.setAttribute(TOKEN_ATTR, token);

        String method = req.getMethod();
        // Only protect state‑changing methods
        if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method)
                || "DELETE".equalsIgnoreCase(method) || "PATCH".equalsIgnoreCase(method)) {
            String requestToken = req.getParameter(TOKEN_ATTR);
            if (requestToken == null || !requestToken.equals(token)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
        }
        // Continue processing
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No resources to clean up
    }
}
