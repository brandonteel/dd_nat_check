FROM alpine:3.21.3
LABEL name="check-ip"
LABEL version="1.0"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-28"
# simple container that gets the current external IP and writes it to an attached volume at /var/checks/, 
# to the file /var/checks/check_ip/check_ip
# there is additional logic to also write the current time to another file at /var/checks/still_alive/still_alive,
# for liveness checks
#
# 2025-03-28 - added new version of script with liveness check in
# 2025-04-01 - release version

# volume mount point for dir to output IP changes
VOLUME ["/var/checks"]

# add curl
RUN apk add --no-cache curl

# copy script
COPY --chmod=777 check_ip.sh check_ip.sh

# run script
CMD ["./check_ip.sh"]
