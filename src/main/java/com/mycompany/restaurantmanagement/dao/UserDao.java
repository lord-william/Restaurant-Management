package com.mycompany.restaurantmanagement.dao;

import com.mycompany.restaurantmanagement.model.User;
import com.mycompany.restaurantmanagement.util.JPAUtil;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.List;

@ApplicationScoped
public class UserDao {
    
    private EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }
    
    public void save(User user) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(user);
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
    
    public User findById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }
    
    public User findByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    public List<User> findAll() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u ORDER BY u.id", User.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<User> findByRole(String role) {
        EntityManager em = getEntityManager();
        try {
            // Use JPQL with field name instead of column name to avoid reserved keyword issues
            return em.createQuery("SELECT u FROM User u WHERE u.userRole = :roleParam ORDER BY u.id", User.class)
                    .setParameter("roleParam", role)
                    .getResultList();
        } finally {
            em.close();
        }
    }
    
    // Keep this method for backward compatibility, but now it just calls findByRole directly
    public List<User> findByRoleString(String roleStr) {
        return findByRole(roleStr);
    }
    
    public List<User> findByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE u.status = :status ORDER BY u.id", User.class)
                    .setParameter("status", status)
                    .getResultList();
        } finally {
            em.close();
        }
    }
    
    public void updateStatus(int userId, String status) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user != null) {
                user.setStatus(status);
                em.merge(user);
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
    
    public void updateRole(int userId, String role) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user != null) {
                user.setUserRole(role);
                em.merge(user);
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
    
    // Keep this method for backward compatibility, but now it just calls updateRole directly
    public void updateRoleString(int userId, String roleStr) {
        updateRole(userId, roleStr);
    }
    
    public void update(User user) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(user);
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
    
    public void delete(int userId) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user != null) {
                em.remove(user);
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
    
    public void updatePassword(int userId, String newPassword) {
        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, userId);
            if (user != null) {
                user.setPassword(newPassword);
                em.merge(user);
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
}