FROM renskiy/cron:alpine
LABEL name="check-ip-cron"
LABEL version="0.2"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-14"

# volume mount point for dir to output IP changes
VOLUME ["/var/check_ip"]

# add curl
RUN apk add --no-cache curl

COPY --chmod=777 check_ip.sh check_ip.sh
COPY --chmod=777 entrypoint.sh entrypoint.sh

CMD ["/entrypoint.sh"]
