package org.yasundial.crawler.app;

import java.io.IOException;
import java.util.Map;

import org.apache.solr.client.solrj.SolrClient;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.common.SolrInputDocument;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class MySolr {
    private static final MySolr INSTANCE = new MySolr();

    private SolrClient client;

    private MyConfig config = MyConfig.getInstance();
    private Logger logger = LogManager.getLogger(MySolr.class);

    private MySolr() {
        client = new HttpSolrClient.Builder(config.getString("MYC_SOLR_URL")).build();
    }

    public static MySolr getInstance() {
        return INSTANCE;
    }

    public void addDocument(Map<String, Object> document) {
        try {
            SolrInputDocument solrDocument = new SolrInputDocument();

            document.entrySet().forEach(entry -> solrDocument.addField(entry.getKey(), entry.getValue()));

            client.add(solrDocument);
        } catch (IOException | SolrServerException e) {
            logger.info("add Document error.", e);
        }
    }

    public void commit() {
        try {
            client.commit();
        } catch (IOException | SolrServerException e) {
            logger.info("commit error.", e);
        }
    }

    public void close() {
        try {
            client.close();
        } catch (IOException e) {
            logger.info("close error.", e);
        }
    }
}

