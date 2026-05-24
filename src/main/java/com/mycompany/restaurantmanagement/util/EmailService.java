package com.mycompany.restaurantmanagement.util;

import jakarta.annotation.Resource;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class EmailService {
    
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    
    @Resource(name = "mail/RestaurantManagementMail")
    private Session mailSession;
    
    public void sendEmail(String recipientEmail, String subject, String body) {
        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject(subject);
            message.setText(body);
            
            Transport.send(message);
            
            LOGGER.log(Level.INFO, "Email sent successfully to {0}", recipientEmail);
        } catch (MessagingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send email to " + recipientEmail, e);
            throw new RuntimeException("Failed to send email", e);
        }
    }
}