package com.example.portal;

import javax.servlet.*;
import java.io.*;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicLong;

public class CounterListener implements ServletContextListener {
    private static final String ATTR = "hitCounter";
    private static final String FILE = "/WEB-INF/counter.dat";
    private AtomicLong counter;

    @Override public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        Path file = Paths.get(ctx.getRealPath(FILE));
        long start = 0L;
        try {
            if (Files.exists(file)) {
                start = Long.parseLong(new String(Files.readAllBytes(file)).trim());
            }
        } catch (Exception ignored) {}
        counter = new AtomicLong(start);
        ctx.setAttribute(ATTR, counter);
    }

    @Override public void contextDestroyed(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        Path file = Paths.get(ctx.getRealPath(FILE));
        try {
            Files.createDirectories(file.getParent());
            Files.write(file, String.valueOf(counter.get()).getBytes());
        } catch (Exception ignored) {}
    }

    public static long inc(ServletContext ctx) {
        AtomicLong c = (AtomicLong) ctx.getAttribute(ATTR);
        return c == null ? -1 : c.incrementAndGet();
    }
}