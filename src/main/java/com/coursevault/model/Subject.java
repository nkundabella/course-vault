package com.coursevault.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "subjects")
public class Subject {
    public Subject() {}
    public Subject(Long id, String name, String iconClass, String description, List<Resource> resources) {
        this.id = id;
        this.name = name;
        this.iconClass = iconClass;
        this.description = description;
        this.resources = resources;
    }
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String iconClass;

    private String description;

    @OneToMany(mappedBy = "subject", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<Resource> resources;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIconClass() { return iconClass; }
    public void setIconClass(String iconClass) { this.iconClass = iconClass; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Resource> getResources() { return resources; }
    public void setResources(List<Resource> resources) { this.resources = resources; }
}
