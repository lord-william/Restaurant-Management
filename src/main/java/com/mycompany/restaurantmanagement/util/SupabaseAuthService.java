package com.mycompany.restaurantmanagement.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONObject;

public class SupabaseAuthService {

    private static final Logger LOGGER = Logger.getLogger(SupabaseAuthService.class.getName());
    
    private static final String SUPABASE_URL = EnvLoader.get("SUPABASE_URL");
    private static final String SUPABASE_ANON_KEY = EnvLoader.get("SUPABASE_ANON_KEY");

    /**
     * Signs up a new user in Supabase Auth.
     * @param email The user's email
     * @param password The user's password
     * @return String UUID of the created user, or null if failed
     */
    public static String signUp(String email, String password) {
        try {
            URL url = new URL(SUPABASE_URL + "/auth/v1/signup");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("apikey", SUPABASE_ANON_KEY);
            conn.setDoOutput(true);

            // Construct JSON payload
            JSONObject payload = new JSONObject();
            payload.put("email", email);
            payload.put("password", password);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200 || responseCode == 201) {
                // Success
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    JSONObject jsonResponse = new JSONObject(response.toString());
                    if (jsonResponse.has("user")) {
                        return jsonResponse.getJSONObject("user").getString("id");
                    }
                    return jsonResponse.getString("id"); // Sometimes returned directly
                }
            } else {
                // Error
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    LOGGER.log(Level.SEVERE, "Supabase Auth SignUp failed: {0}", response.toString());
                }
                return null;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Exception during Supabase Auth SignUp", e);
            return null;
        }
    }

    /**
     * Logs in an existing user via Supabase Auth.
     * @param email The user's email
     * @param password The user's password
     * @return String access_token, or null if failed
     */
    public static String logIn(String email, String password) {
        try {
            URL url = new URL(SUPABASE_URL + "/auth/v1/token?grant_type=password");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("apikey", SUPABASE_ANON_KEY);
            conn.setDoOutput(true);

            JSONObject payload = new JSONObject();
            payload.put("email", email);
            payload.put("password", password);

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    JSONObject jsonResponse = new JSONObject(response.toString());
                    return jsonResponse.getString("access_token");
                }
            } else {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }
                    LOGGER.log(Level.WARNING, "Supabase Auth Login failed: {0}", response.toString());
                }
                return null;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Exception during Supabase Auth Login", e);
            return null;
        }
    }
}
