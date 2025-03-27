FROM renskiy/cron:alpine
LABEL name="check-ip-cron"
LABEL version="0.3"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-27"

ENV RUN_TIME=1438
ENV HEALTHCHECK_PORT=5555
ENV MAX_RETRIES=0

# volume mount point for dir to output IP changes
VOLUME ["/var/check_ip"]

# add curl
RUN apk add --no-cache curl
RUN apk add --no-cache lighttpd

COPY --chmod=644 lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --chmod=644 lighttpd/htdocs/index.html /var/www/localhost/htdocs/index.html

COPY --chmod=777 check_ip.sh check_ip.sh
COPY --chmod=777 entrypoint.sh entrypoint.sh

CMD ["sh","-c","/entrypoint.sh ${RUN_TIME} ${HEALTHCHECK_PORT} ${MAX_RETRIES}"]