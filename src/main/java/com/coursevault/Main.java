package com.coursevault;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.awt.Desktop;
import java.io.File;
import java.net.URI;

public class Main {

    public static void main(String[] args) throws Exception {
        String webappDirLocation = "src/main/webapp/";
        File webappDir = new File(webappDirLocation);
        
        System.out.println("Checking webapp directory: " + webappDir.getAbsolutePath());
        if (!webappDir.exists()) {
            System.err.println("CRITICAL ERROR: The webapp directory was NOT found!");
            System.err.println("Current Working Directory: " + new File(".").getAbsolutePath());
            return;
        }

        Tomcat tomcat = new Tomcat();
        String webPort = System.getenv("PORT");
        if (webPort == null || webPort.isEmpty()) webPort = "8081";
        tomcat.setPort(Integer.parseInt(webPort));
        
        // This is required for Tomcat to find and initialize the JSP engine
        tomcat.getConnector();

        // Add the webapp to the root context
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir.getAbsolutePath());

        // Ensure that the server looks for classes in the target/classes folder (for IntelliJ/Maven)
        File additionWebInfClasses = new File("target/classes");
        if (!additionWebInfClasses.exists()) {
            additionWebInfClasses = new File("out/production/classes");
        }

        if (additionWebInfClasses.exists()) {
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
            System.out.println("Integrated classes from: " + additionWebInfClasses.getAbsolutePath());
        } else {
            System.out.println("WARNING: target/classes not found. Run 'mvn compile' if you get 404s on servlets.");
        }

        // Pre-flight Database Check
        System.out.println("-------------------------------------------------------------------");
        System.out.println("Verifying Database Connection...");
        try {
            com.coursevault.hibernate.HibernateUtil.getSessionFactory();
            System.out.println("DATABASE: OK - Connected Successfully.");
        } catch (Exception e) {
            System.err.println("DATABASE: FAILED!");
            System.err.println("ERROR: Could not connect to MySQL database 'coursevault'.");
            System.err.println("REMEDY: Ensure XAMPP/MySQL is running and the 'coursevault' schema exists.");
            System.err.println("-------------------------------------------------------------------");
            // We continue anyway so Tomcat logs can be viewed, or the user can fix it on the fly
        }

        System.out.println("-------------------------------------------------------------------");
        System.out.println("Starting Course-Vault System [Standalone Mode]...");
        System.out.println("Note: If you get a 404, verify that 'index.jsp' exists in " + webappDirLocation);
        System.out.println("-------------------------------------------------------------------");

        tomcat.start();
        
        String appUrl = "http://localhost:" + webPort + "/";
        System.out.println("Course-Vault is LIVE at: " + appUrl);
        
        // Automatically open the browser
        openBrowser(appUrl);

        tomcat.getServer().await();
    }

    private static void openBrowser(String url) {
        System.out.println("Attempting to open browser: " + url);
        try {
            String os = System.getProperty("os.name").toLowerCase();
            if (os.contains("win")) {
                // Windows: use cmd /c start
                new ProcessBuilder("cmd", "/c", "start", url.replace("&", "^&")).start();
            } else if (os.contains("mac")) {
                // Mac: use open
                new ProcessBuilder("open", url).start();
            } else {
                // Linux: use xdg-open
                new ProcessBuilder("xdg-open", url).start();
            }
        } catch (Exception e) {
            System.err.println("OS-specific browser launch failed. Trying Desktop API...");
            try {
                if (Desktop.isDesktopSupported() && Desktop.getDesktop().isSupported(Desktop.Action.BROWSE)) {
                    Desktop.getDesktop().browse(new URI(url));
                } else {
                    manualOpenHelp(url);
                }
            } catch (Exception e2) {
                System.err.println("Desktop API also failed.");
                manualOpenHelp(url);
            }
        }
    }

    private static void manualOpenHelp(String url) {
        System.out.println("-------------------------------------------------------------------");
        System.out.println("Please open your browser manually and navigate to:");
        System.out.println(url);
        System.out.println("-------------------------------------------------------------------");
    }
}
