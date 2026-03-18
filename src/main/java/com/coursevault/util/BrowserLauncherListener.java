package com.coursevault.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.awt.Desktop;
import java.net.URI;

/**
 * A practical utility that automatically opens the browser 
 * whenever the Course-Vault server starts up.
 */
@WebListener
public class BrowserLauncherListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // We only want to open the browser if running on a local development machine
        String os = System.getProperty("os.name").toLowerCase();
        
        // Use a background thread so we don't block the server startup
        new Thread(() -> {
            try {
                // Give the server 3 seconds to fully finish its internal binding
                Thread.sleep(3000);
                
                // Detect the context path dynamically (e.g. "" or "/Course-Vault")
                String contextPath = sce.getServletContext().getContextPath();
                if (contextPath == null || contextPath.equals("/")) contextPath = "";
                
                String url = "http://localhost:8081" + contextPath + "/";
                
                System.out.println("[Course-Vault] System Initialized at: " + url + ". Launching browser...");
                
                if (os.contains("win")) {
                    new ProcessBuilder("cmd", "/c", "start", url).start();
                } else if (os.contains("mac")) {
                    new ProcessBuilder("open", url).start();
                } else {
                    if (Desktop.isDesktopSupported()) {
                        Desktop.getDesktop().browse(new URI(url));
                    }
                }
            } catch (Exception e) {
                // Silently fail if browser can't be opened (e.g. on a real server)
                System.err.println("[Course-Vault] Could not auto-launch browser: " + e.getMessage());
            }
        }).start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}
