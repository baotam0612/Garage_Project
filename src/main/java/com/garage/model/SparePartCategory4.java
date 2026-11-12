package com.garage.model;

/** Category value object kept for the class name shown in the diagram. */
public class SparePartCategory4 {
    private String id;
    private String categoryName;
    private String description;

    public SparePartCategory4() {
    }

    public SparePartCategory4(String id, String categoryName, String description) {
        this.id = id;
        this.categoryName = categoryName;
        this.description = description;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
