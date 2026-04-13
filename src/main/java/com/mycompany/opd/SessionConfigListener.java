package com.mycompany.opd;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.SessionTrackingMode;
import jakarta.servlet.annotation.WebListener;
import java.util.EnumSet;

@WebListener
public class SessionConfigListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Force the container to use Cookies for session tracking, disabling URL rewriting
        sce.getServletContext().setSessionTrackingModes(EnumSet.of(SessionTrackingMode.COOKIE));
    }
}