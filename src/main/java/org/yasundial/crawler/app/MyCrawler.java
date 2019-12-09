package org.yasundial.crawler.app;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import edu.uci.ics.crawler4j.crawler.Page;
import edu.uci.ics.crawler4j.crawler.WebCrawler;
import edu.uci.ics.crawler4j.parser.HtmlParseData;
import edu.uci.ics.crawler4j.parser.TextParseData;
import edu.uci.ics.crawler4j.url.WebURL;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.mozilla.universalchardet.UniversalDetector;

public class MyCrawler extends WebCrawler {

    MyConfig local_config = MyConfig.getInstance();
    
    private final Logger logger = LoggerFactory.getLogger(getClass());
    private Pattern OK_FILTERS = null;
    private Pattern VISIT_ALLOW_FILTER = null;

    @Override
    public boolean shouldVisit(Page referringPage, WebURL url) {
        String hrefUrl = url.getURL();
	if(OK_FILTERS == null) {
	    OK_FILTERS = Pattern.compile(local_config.getString("OK_FILTER"), Pattern.CASE_INSENSITIVE);
	}
        if(! OK_FILTERS.matcher(hrefUrl).matches()) {
            return false;
        }
	if(VISIT_ALLOW_FILTER == null) {
	    VISIT_ALLOW_FILTER = Pattern.compile(local_config.getString("VISIT_URL_PATTERN"), Pattern.CASE_INSENSITIVE);
	}
	logger.info("hrefUrl: {} compared with {}", hrefUrl, local_config.getString("VISIT_URL_PATTERN"));
        return VISIT_ALLOW_FILTER.matcher(hrefUrl).matches();
    }
    
    @Override
    public void visit(Page page) {
        String url = page.getWebURL().getURL();
	
        // check encoding and convert page.ContentData to UTF-8
        UniversalDetector detector = new UniversalDetector(null);
        byte buf[] = page.getContentData();
        detector.handleData(buf, 0, buf.length);
        detector.dataEnd();
        String detectCharset = detector.getDetectedCharset();
        detector.reset();
        logger.info("detectCharset: {}, buf.length: {}", detectCharset, buf.length);
        if(detectCharset == null) {
            page.setContentCharset("UTF-8");
        }

	String html = "";
	byte[] dataByte = page.getContentData(); // TODO: should be replaced with buf[].
	try {
	    if(detectCharset != null) {
		html = new String(dataByte, detectCharset);
	    }
	} catch(java.io.UnsupportedEncodingException e) {
	    logger.warn(e.toString());
	}
	Document jsoupDoc = Jsoup.parse(html);
	System.out.println("title: " + jsoupDoc.title());
	System.out.println(" text: " + jsoupDoc.select("body").text());
    }
}
