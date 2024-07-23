package org.yasundial.crawler.app;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.builder.fluent.Configurations;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


import java.io.File;

public class MyConfig {
    private final String CONFIG_FILENAME = "config.properties";
    private final Logger logger = LogManager.getLogger(MyConfig.class);
    private Configuration config;
    
    private static final MyConfig INSTANCE = new MyConfig();
    public static MyConfig getInstance() {
        return INSTANCE;
    }

    MyConfig() {
        Configurations configs = new Configurations();
        try {
            config = configs.properties(new File(CONFIG_FILENAME));
        } catch (ConfigurationException e) {
            logger.error("cannot load config.properties from {}", System.getProperty("user.dir"));
        }
    }
    
    public String getString(String key) {
        try {
            String ret = System.getenv(key);
            if (ret != null && !ret.isEmpty()) {
                return ret;
            }
        } catch(Exception e) {
            logger.warn(e.toString());
        }
        return config.getString(key);
    }

    public int getInt(String key) {
        try {
            String ret = System.getenv(key);
            if (ret != null && !ret.isEmpty()) {
                return Integer.parseInt(ret);
            }
        } catch(Exception e) {
            logger.warn(e.toString());
        }
        return config.getInt(key);
    }
}
