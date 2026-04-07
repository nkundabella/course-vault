package com.coursevault.util;

public class InputSanitizer {
    public static String cleanText(String text, int maxLength) {
        if (text == null) return "";
        text = text.trim();
        if (text.length() > maxLength) text = text.substring(0, maxLength);
        return text.replaceAll("&", "&amp;")
                   .replaceAll("<", "&lt;")
                   .replaceAll(">", "&gt;")
                   .replaceAll("\"", "&quot;")
                   .replaceAll("'", "&#x27;");
    }

    public static String cleanIconClass(String iconClass) {
        if (iconClass == null || iconClass.isEmpty()) return "fas fa-book";
        return iconClass.replaceAll("[^a-zA-Z0-9 -]", "");
    }

    public static String cleanResourceType(String type) {
        if (type == null) return "NOTES";
        String upper = type.toUpperCase();
        if (upper.equals("PAST_PAPER")) return "PAST_PAPER";
        if (upper.equals("GROUP_PRESENTATION")) return "GROUP_PRESENTATION";
        if (upper.equals("OTHER")) return "OTHER";
        System.out.println("[InputSanitizer] WARNING: Unknown resource type encountered: " + type + ". Falling back to NOTES.");
        return "NOTES";
    }

    public static int parseIntInRange(String val, int min, int max, int defaultVal) {
        try {
            int parsed = Integer.parseInt(val);
            if (parsed < min || parsed > max) return defaultVal;
            return parsed;
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
