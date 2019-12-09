package org.yasundial.crawler.app;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/*
 * References: https://github.com/yasserg/crawler4j
 */

public class App {
    public static void main(String[] args) throws Exception {
	MyConfig local_config = MyConfig.getInstance();
	String targetUrl = local_config.getString("TARGET_URL");
	String dataDir = local_config.getString("CRAWLER4J_STORAGE_DIR");
	    
        int numberOfCrawlers = 7;
	CrawlConfig config = new CrawlConfig();
        config.setCrawlStorageFolder(dataDir);
        config.setPolitenessDelay(1 * 1000);
	PageFetcher pageFetcher = new PageFetcher(config);
        RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
        RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
        CrawlController controller = new CrawlController(config, pageFetcher, robotstxtServer);
	controller.addSeed(targetUrl);
	controller.start(MyCrawler.class, numberOfCrawlers);
    }
}
