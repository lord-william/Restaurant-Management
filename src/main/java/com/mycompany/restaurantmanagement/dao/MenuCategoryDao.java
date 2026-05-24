package com.mycompany.restaurantmanagement.dao;

import com.mycompany.restaurantmanagement.model.MenuCategory;
import com.mycompany.restaurantmanagement.util.JPAUtil;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;

@ApplicationScoped
public class MenuCategoryDao {
    
    private EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }
    
    public void save(MenuCategory category) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(category);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void update(MenuCategory category) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(category);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void delete(int categoryId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            MenuCategory category = em.find(MenuCategory.class, categoryId);
            if (category != null) {
                em.remove(category);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public MenuCategory findById(int categoryId) {
        EntityManager em = getEntityManager();
        try {
            return em.find(MenuCategory.class, categoryId);
        } finally {
            em.close();
        }
    }
    
    public MenuCategory findByName(String name) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT c FROM MenuCategory c WHERE c.name = :name", MenuCategory.class)
                    .setParameter("name", name)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    public List<MenuCategory> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT c FROM MenuCategory c ORDER BY c.name", MenuCategory.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
