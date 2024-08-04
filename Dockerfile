## deploying for production

FROM docker.io/library/eclipse-temurin:21-jre-alpine

RUN apk update && \
    apk add --no-cache tzdata bash ca-certificates

RUN mkdir /jobs
WORKDIR /jobs
COPY target/crawlerdemo-1.0-SNAPSHOT.jar /jobs/
COPY run.sh /jobs/
RUN chmod +x /jobs/run.sh

ENV TARGET_URL="https://example.com/~user01/"
ENV VISIT_URL_PATTERN="^https://example.com/~user01/.+$"
ENV CRAWLER4J_STORAGE_DIR="data/crawl/strage"
ENV OK_FILTER=".*(\\.(text|txt|html|htm|yaml|yml|csv|json))$|.*/$"
ENV MYC_SOLR_URL="http://example.com:8983/solr/test"

RUN mkdir /jobs/data
RUN addgroup crawler
RUN adduser -S -G crawler crawler
RUN chown crawler /jobs/data
USER crawler

ENTRYPOINT ["./run.sh"]
