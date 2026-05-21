package com.coursevault.util;

import java.util.logging.Level;
import java.util.logging.Logger;

public class LoggingUtil {
    private static final Logger LOGGER = Logger.getLogger(LoggingUtil.class.getName());

    public static void info(String msg) {
        LOGGER.log(Level.INFO, msg);
    }

    public static void warning(String msg) {
        LOGGER.log(Level.WARNING, msg);
    }

    public static void error(String msg, Throwable t) {
        LOGGER.log(Level.SEVERE, msg, t);
    }

    public static void error(String msg) {
        LOGGER.log(Level.SEVERE, msg);
    }
}
