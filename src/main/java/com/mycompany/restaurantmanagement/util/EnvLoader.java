package com.mycompany.restaurantmanagement.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EnvLoader {
    private static final Logger LOGGER = Logger.getLogger(EnvLoader.class.getName());
    private static final Map<String, String> envVars = new HashMap<>();
    
    // Hardcoded absolute path for local development to ensure GlassFish can find it
    private static final String ENV_FILE_PATH = "C:\\Users\\Lenovo\\Java\\RestaurantManagement\\.env";

    static {
        loadEnv();
    }

    private static void loadEnv() {
        try (BufferedReader reader = new BufferedReader(new FileReader(ENV_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }
                int splitIndex = line.indexOf('=');
                if (splitIndex > 0) {
                    String key = line.substring(0, splitIndex).trim();
                    String value = line.substring(splitIndex + 1).trim();
                    envVars.put(key, value);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to load .env file from " + ENV_FILE_PATH, e);
        }
    }

    public static String get(String key) {
        return envVars.get(key);
    }
}
