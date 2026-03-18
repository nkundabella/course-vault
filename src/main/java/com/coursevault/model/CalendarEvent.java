package com.coursevault.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "calendar_events")
public class CalendarEvent {
    public CalendarEvent() {}

    public CalendarEvent(Long id, String title, java.time.LocalDate date, Integer term, String category, boolean major, String description, User user) {
        this.id = id;
        this.title = title;
        this.date = date;
        this.term = term;
        this.category = category;
        this.major = major;
        this.description = description;
        this.user = user;
    }
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private java.time.LocalDate date;
    private Integer term;
    private String category;
    private boolean major;
    private String description;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public java.time.LocalDate getDate() { return date; }
    public void setDate(java.time.LocalDate date) { this.date = date; }

    public Integer getTerm() { return term; }
    public void setTerm(Integer term) { this.term = term; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public boolean isMajor() { return major; }
    public void setMajor(boolean major) { this.major = major; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
