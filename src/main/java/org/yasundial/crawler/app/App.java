package org.yasundial.crawler.app;

import edu.uci.ics.crawler4j.crawler.CrawlConfig;
import edu.uci.ics.crawler4j.crawler.CrawlController;
import edu.uci.ics.crawler4j.fetcher.PageFetcher;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtConfig;
import edu.uci.ics.crawler4j.robotstxt.RobotstxtServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class App {
    public static void main(String[] args) throws Exception {
	System.out.println("Hello World");

	String targetUrl = "https://www.yasundial.org/old/";
	    
        int numberOfCrawlers = 7;
	CrawlConfig config = new CrawlConfig();
        config.setCrawlStorageFolder("data");
        config.setPolitenessDelay(1 * 1000);
	PageFetcher pageFetcher = new PageFetcher(config);
        RobotstxtConfig robotstxtConfig = new RobotstxtConfig();
        RobotstxtServer robotstxtServer = new RobotstxtServer(robotstxtConfig, pageFetcher);
        CrawlController controller = new CrawlController(config, pageFetcher, robotstxtServer);
	controller.addSeed(targetUrl);
	controller.start(MyCrawler.class, numberOfCrawlers);
    }
}
