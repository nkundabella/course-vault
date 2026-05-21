package com.coursevault.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SecurityHeadersFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No init required
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResp = (HttpServletResponse) response;
            httpResp.setHeader("Strict-Transport-Security", "max-age=31536000 ; includeSubDomains");
            httpResp.setHeader("X-Content-Type-Options", "nosniff");
            httpResp.setHeader("X-Frame-Options", "SAMEORIGIN");
            httpResp.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
            // Tightened CSP: no unsafe-inline, only self sources
            httpResp.setHeader("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; object-src 'none'; frame-ancestors 'self'; base-uri 'self';");
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No resources to clean up
    }
}
