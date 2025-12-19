package com.example.portal.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Book {
    private int id;
    private String title;
    private String author;
    private String description;
    private String genre;
    private String isbn;
    private int pageCount;
    private int publicationYear;
    private String publisher;
    private String coverImage;
    private LocalDateTime addedDate;
    private boolean available;
    private int totalCopies;
    private int availableCopies;

    public Book() {
        this.addedDate = LocalDateTime.now();
        this.available = true;
        this.totalCopies = 1;
        this.availableCopies = 1;
    }

    public Book(int id, String title, String author, String description, String genre) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.description = description;
        this.genre = genre;
        this.addedDate = LocalDateTime.now();
        this.available = true;
        this.totalCopies = 1;
        this.availableCopies = 1;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public int getPageCount() { return pageCount; }
    public void setPageCount(int pageCount) { this.pageCount = pageCount; }

    public int getPublicationYear() { return publicationYear; }
    public void setPublicationYear(int publicationYear) { this.publicationYear = publicationYear; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public LocalDateTime getAddedDate() { return addedDate; }
    public void setAddedDate(LocalDateTime addedDate) { this.addedDate = addedDate; }

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    public int getTotalCopies() { return totalCopies; }
    public void setTotalCopies(int totalCopies) { this.totalCopies = totalCopies; }

    public int getAvailableCopies() { return availableCopies; }
    public void setAvailableCopies(int availableCopies) { this.availableCopies = availableCopies; }

    @JsonIgnore
    public String getFormattedDate() {
        if (addedDate == null) return "";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");
        return addedDate.format(formatter);
    }

    @JsonIgnore
    public String getShortDescription() {
        if (description == null) return "";
        if (description.length() > 150) {
            return description.substring(0, 150) + "...";
        }
        return description;
    }
}