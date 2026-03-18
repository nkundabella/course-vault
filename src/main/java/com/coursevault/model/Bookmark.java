package com.coursevault.model;

import jakarta.persistence.*;

@Entity
@Table(name = "bookmarks")
public class Bookmark {
    public Bookmark() {}
    public Bookmark(Long id, User user, Resource resource) {
        this.id = id;
        this.user = user;
        this.resource = resource;
    }
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "resource_id", nullable = false)
    private Resource resource;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Resource getResource() { return resource; }
    public void setResource(Resource resource) { this.resource = resource; }
}
