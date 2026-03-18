package com.coursevault.services;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class MailService {
    private static MailService instance = new MailService();
    public static MailService getInstance() { return instance; }

    private String smtpHost;
    private String smtpPort;
    private String smtpUser;
    private String smtpPass;

    public void configure(String host, String port, String user, String pass) {
        this.smtpHost = host;
        this.smtpPort = port;
        this.smtpUser = user;
        this.smtpPass = pass;
    }

    private void loadConfigFromDb() {
        try (org.hibernate.Session sesh = com.coursevault.hibernate.HibernateUtil.getSessionFactory().openSession()) {
            com.coursevault.model.SystemConfig config = sesh.createQuery("from SystemConfig", com.coursevault.model.SystemConfig.class)
                    .setMaxResults(1)
                    .uniqueResult();
            if (config != null) {
                this.smtpHost = config.getSmtpHost();
                this.smtpPort = config.getSmtpPort();
                this.smtpUser = config.getSmtpUser();
                this.smtpPass = config.getSmtpPass();
            }
        } catch (Exception e) {
            System.err.println("[MailService] Pre-config check failed: " + e.getMessage());
        }
    }

    public boolean isConfigured() {
        if (smtpUser == null || smtpPass == null) {
            loadConfigFromDb();
        }
        return smtpUser != null && smtpPass != null;
    }

    public void sendVerificationCode(String toEmail, String code) throws MessagingException {
        if (!isConfigured()) {
            System.err.println("[MailService] SMTP not configured!");
            throw new MessagingException("SMTP not configured");
        }

        final String host = this.smtpHost;
        final String port = this.smtpPort;
        final String user = this.smtpUser;
        final String pass = this.smtpPass;

        System.out.println("[MailService] Sending to=" + toEmail + " via " + host + ":" + port + " user=" + user);

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.trust", host);
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.connectiontimeout", "20000");
        props.put("mail.smtp.timeout", "20000");

        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });

        Message message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress(user));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("CourseVault | Your Verification Code");
        message.setText("Your CourseVault verification code is:\n\n" + code + "\n\nThis code expires in 10 minutes.");

        System.out.println("[MailService] Connecting to SMTP…");
        Transport.send(message);
        System.out.println("[MailService] SUCCESS — email delivered to " + toEmail);
    }
}
