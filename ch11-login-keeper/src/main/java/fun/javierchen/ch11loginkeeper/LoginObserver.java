package fun.javierchen.ch11loginkeeper;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.util.logging.Logger;

@WebListener
public class LoginObserver implements HttpSessionListener {
    private static final Logger logger = Logger.getLogger(LoginObserver.class.getName());

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        logger.info("Session created: " + se.getSession().getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        String sessionId = se.getSession().getId();
        SessionManager.getInstance().logout(sessionId);
        logger.info("Session destroyed and removed from Map: " + sessionId);
    }
}
