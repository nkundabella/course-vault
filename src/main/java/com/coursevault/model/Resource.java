package com.coursevault.model;

import jakarta.persistence.*;

@Entity
@Table(name = "resources")
public class Resource {
    public Resource() {}
    public Resource(Long id, String title, String filePath, int year, int term, String type, Subject subject, User uploader) {
        this.id = id;
        this.title = title;
        this.filePath = filePath;
        this.year = year;
        this.term = term;
        this.type = type;
        this.subject = subject;
        this.uploader = uploader;
    }
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String filePath;

    private int year;
    private int term;
    private String type; // NOTES or PAST_PAPER

    @ManyToOne
    @JoinColumn(name = "subject_id")
    private Subject subject;

    @ManyToOne
    @JoinColumn(name = "uploader_id")
    private User uploader;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public int getTerm() { return term; }
    public void setTerm(int term) { this.term = term; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Subject getSubject() { return subject; }
    public void setSubject(Subject subject) { this.subject = subject; }

    public User getUploader() { return uploader; }
    public void setUploader(User uploader) { this.uploader = uploader; }
}
