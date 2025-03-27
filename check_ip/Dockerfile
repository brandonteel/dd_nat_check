FROM alpine:3.21.3
LABEL name="check_ip"
LABEL version="0.1"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-12"

# volume mount point for dir to output IP changes
VOLUME ["/var/check_ip"]

# add curl
RUN apk add --no-cache curl

# copy script
COPY --chmod=777 check_ip.sh check_ip.sh

# run script
CMD ["./check_ip.sh"]
