package qlst.model;

import java.util.List;

public class Product5 {
    private int id;
    private String name;
    private String model;
    private String brand;
    private String origin;
    private String unit;
    private String description;
    private Category5 category;
    private List<ProductDetail5> details;

    public Product5() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Category5 getCategory() { return category; }
    public void setCategory(Category5 category) { this.category = category; }

    public List<ProductDetail5> getDetails() {
        return details;
    }

    public void setDetails(List<ProductDetail5> details) {
        this.details = details;
    }
}
