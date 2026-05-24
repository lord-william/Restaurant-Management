package com.mycompany.restaurantmanagement.dao;

import com.mycompany.restaurantmanagement.model.MenuItem;
import com.mycompany.restaurantmanagement.util.JPAUtil;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import java.util.List;

@ApplicationScoped
public class MenuItemDao {
    
    private EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }
    
    public int getMenuItemCount() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(m) FROM MenuItem m WHERE m.available = true", 
                Long.class
            );
            Long count = query.getSingleResult();
            return count != null ? count.intValue() : 0;
        } finally {
            em.close();
        }
    }
    
    public List<MenuItem> findAll() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<MenuItem> query = em.createQuery(
                "SELECT m FROM MenuItem m ORDER BY m.category.name, m.name", 
                MenuItem.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<MenuItem> findByCategory(String categoryName) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<MenuItem> query = em.createQuery(
                "SELECT m FROM MenuItem m WHERE m.category.name = :categoryName AND m.available = true ORDER BY m.name", 
                MenuItem.class
            );
            query.setParameter("categoryName", categoryName);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public MenuItem findById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(MenuItem.class, id);
        } finally {
            em.close();
        }
    }
    
    public boolean save(MenuItem menuItem) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(menuItem);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
    public boolean update(MenuItem menuItem) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(menuItem);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    
    public boolean delete(int id) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MenuItem menuItem = em.find(MenuItem.class, id);
            if (menuItem != null) {
                em.remove(menuItem);
                tx.commit();
                return true;
            }
            tx.rollback();
            return false;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}