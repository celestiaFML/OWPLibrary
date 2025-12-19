package com.example.portal.storage;

import com.example.portal.model.Book;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import javax.servlet.ServletContext;
import java.io.*;
import java.util.*;

public class BookStorage {
    private static final String FILE_PATH = "/WEB-INF/books.json";
    private ServletContext context;
    private List<Book> books;
    private int nextId = 1;

    public BookStorage(ServletContext context) {
        this.context = context;
        loadBooks();
    }

    private void loadBooks() {
        try (InputStream is = context.getResourceAsStream(FILE_PATH)) {
            ObjectMapper mapper = new ObjectMapper();
            CollectionType listType = mapper.getTypeFactory()
                    .constructCollectionType(List.class, Book.class);

            if (is != null) {
                books = mapper.readValue(is, listType);
                nextId = books.stream()
                        .mapToInt(Book::getId)
                        .max()
                        .orElse(0) + 1;
            } else {
                books = new ArrayList<>();
            }
        } catch (IOException e) {
            books = new ArrayList<>();
        }
    }

    private void saveBooks() {
        try {
            String realPath = context.getRealPath(FILE_PATH);
            ObjectMapper mapper = new ObjectMapper();
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(realPath), books);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<Book> getAllBooks() {
        return new ArrayList<>(books);
    }

    public Book getBookById(int id) {
        return books.stream()
                .filter(b -> b.getId() == id)
                .findFirst()
                .orElse(null);
    }

    public void addBook(Book book) {
        book.setId(nextId++);
        books.add(book);
        saveBooks();
    }

    public void updateBook(Book updatedBook) {
        for (int i = 0; i < books.size(); i++) {
            if (books.get(i).getId() == updatedBook.getId()) {
                books.set(i, updatedBook);
                saveBooks();
                return;
            }
        }
    }

    public void deleteBook(int id) {
        books.removeIf(b -> b.getId() == id);
        saveBooks();
    }

    public List<String> getGenres() {
        List<String> genres = new ArrayList<>();
        for (Book book : books) {
            if (book.getGenre() != null && !book.getGenre().trim().isEmpty()) {
                genres.add(book.getGenre());
            }
        }
        return genres;
    }
}