FROM alpine:3.21.3
LABEL name="check-ip"
LABEL version="0.2"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-28"
# 2025-03-28 - added new version of script with liveness check in

# volume mount point for dir to output IP changes
VOLUME ["/var/checks"]

# add curl
RUN apk add --no-cache curl

# copy script
COPY --chmod=777 check_ip.sh check_ip.sh

# run script
CMD ["./check_ip.sh"]
