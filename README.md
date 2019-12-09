# Sample Crawling Application for Japanese Contents

This is an Sample application to crawl Japanese contents encoded in EUC-JP, Shift-JIS, and UTF-8
using the org.mozilla.universalchardet.UniversalDetector and Crawler4j.

# References

* https://github.com/yasserg/crawler4j
* https://code.google.com/archive/p/juniversalchardet/

# How to run

	# update TARGET_URL and VISIT_URL_PATTERN of config.properties
	$ mvn compile
    $ mvn exec:java 
	
Or, you can use environment variables to overwrite the config.properties file.

    $ env TARGET_URL="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
          VISIT_URL_PATTERN="https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%83%A9" \
      mvn exec:java

