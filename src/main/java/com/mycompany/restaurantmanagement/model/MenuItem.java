package com.mycompany.restaurantmanagement.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;

@Entity
@Table(name = "menu_items")
public class MenuItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "item_id")
    private int id;
    
    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private MenuCategory category;
    
    @NotEmpty(message = "Item name cannot be empty")
    @Column(name = "name", length = 100, nullable = false)
    private String name;
    
    @Column(name = "description")
    private String description;
    
    @NotNull(message = "Price is required")
    @DecimalMin(value = "0.01", message = "Price must be greater than zero")
    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price;
    
    @Column(name = "image_url")
    private String imageUrl;
    
    @Column(name = "is_vegetarian")
    private boolean vegetarian = false;
    
    @Column(name = "is_vegan")
    private boolean vegan = false;
    
    @Column(name = "is_gluten_free")
    private boolean glutenFree = false;
    
    @Column(name = "is_available")
    private boolean available = true;
    
    @Column(name = "preparation_time")
    private Integer preparationTime;
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public MenuCategory getCategory() {
        return category;
    }
    
    public void setCategory(MenuCategory category) {
        this.category = category;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public boolean isVegetarian() {
        return vegetarian;
    }
    
    public void setVegetarian(boolean vegetarian) {
        this.vegetarian = vegetarian;
    }
    
    public boolean isVegan() {
        return vegan;
    }
    
    public void setVegan(boolean vegan) {
        this.vegan = vegan;
    }
    
    public boolean isGlutenFree() {
        return glutenFree;
    }
    
    public void setGlutenFree(boolean glutenFree) {
        this.glutenFree = glutenFree;
    }
    
    public boolean isAvailable() {
        return available;
    }
    
    public void setAvailable(boolean available) {
        this.available = available;
    }
    
    public Integer getPreparationTime() {
        return preparationTime;
    }
    
    public void setPreparationTime(Integer preparationTime) {
        this.preparationTime = preparationTime;
    }
}
