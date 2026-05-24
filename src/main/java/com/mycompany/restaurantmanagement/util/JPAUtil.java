package com.mycompany.restaurantmanagement.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for managing EntityManager instances
 */
public class JPAUtil {
    private static final Logger LOGGER = Logger.getLogger(JPAUtil.class.getName());
    private static final String PERSISTENCE_UNIT_NAME = "RestaurantPU";
    private static EntityManagerFactory factory;
    
    /**
     * Get the EntityManagerFactory with robust error handling
     * @return EntityManagerFactory instance
     */
    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (factory == null || !factory.isOpen()) {
            try {
                LOGGER.info("Initializing JPA EntityManagerFactory for unit: " + PERSISTENCE_UNIT_NAME);
                factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to create EntityManagerFactory: " + e.getMessage(), e);
                throw new RuntimeException("Cannot initialize JPA EntityManagerFactory", e);
            }
        }
        return factory;
    }
    
    /**
     * Get a new EntityManager with error handling
     * @return EntityManager instance
     */
    public static EntityManager getEntityManager() {
        try {
            EntityManager em = getEntityManagerFactory().createEntityManager();
            if (em == null) {
                LOGGER.severe("EntityManager is null");
                throw new RuntimeException("Failed to create EntityManager");
            }
            return em;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating EntityManager: " + e.getMessage(), e);
            throw new RuntimeException("Cannot create EntityManager", e);
        }
    }
    
    /**
     * Close the EntityManagerFactory
     */
    public static void shutdown() {
        if (factory != null && factory.isOpen()) {
            try {
                LOGGER.info("Closing JPA EntityManagerFactory");
                factory.close();
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error closing EntityManagerFactory: " + e.getMessage(), e);
            }
        }
    }
}
