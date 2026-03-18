package com.coursevault.model;

import jakarta.persistence.*;

@Entity
@Table(name = "system_config")
public class SystemConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String smtpHost;
    private String smtpPass;
    private String smtpPort;
    private String smtpUser;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSmtpHost() { return smtpHost; }
    public void setSmtpHost(String smtpHost) { this.smtpHost = smtpHost; }

    public String getSmtpPass() { return smtpPass; }
    public void setSmtpPass(String smtpPass) { this.smtpPass = smtpPass; }

    public String getSmtpPort() { return smtpPort; }
    public void setSmtpPort(String smtpPort) { this.smtpPort = smtpPort; }

    public String getSmtpUser() { return smtpUser; }
    public void setSmtpUser(String smtpUser) { this.smtpUser = smtpUser; }
}
