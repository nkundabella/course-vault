package com.coursevault.services;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.util.concurrent.TimeUnit;

public class CaptchaService {
    private static final CaptchaService instance = new CaptchaService();
    private static final String SECRET_KEY = "1x0000000000000000000000000000000AA"; // Dummy for now, usually from config
    private final HttpClient httpClient;

    public static CaptchaService getInstance() {
        return instance;
    }

    private CaptchaService() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(java.time.Duration.ofSeconds(10))
                .build();
    }

    public boolean verify(String token, String remoteIp) {
        if (token == null || token.isEmpty()) return false;

        try {
            String params = "secret=" + SECRET_KEY + "&response=" + token + "&remoteip=" + remoteIp;
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://challenges.cloudflare.com/turnstile/v0/siteverify"))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(params))
                    .build();

            HttpResponse<String> response = httpClient.send(request, BodyHandlers.ofString());
            return response.body().contains("\"success\":true");
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
