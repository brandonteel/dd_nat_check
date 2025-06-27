FROM gcr.io/datadoghq/agent:current
LABEL name="dd-directory"
LABEL version="1.0"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-31"
# datadog agent running the dd-directory module, monitoring directory changes at /var/checks/check_ip and
# /var/checks/still_alive
# meant to run in tandem with check-ip container, to produce metrics determining if a NAT IP has changed.
# the /var/checks/still_alive check produces metrics to monitor whether the check-ip container is working as expected
#
#2025-03-31 0.4 - hopefully shutdown gracefully
#2025-04-02 1.0 - release version

ENV SHUTDOWN_SECONDS=86220

# Expose DogStatsD and trace-agent ports
EXPOSE 8125/udp 8126/tcp

# volume mount point for dir to test for changes
VOLUME ["/var/checks"]

# copy directory.d config
COPY --chown=dd-agent:root --chmod=664 directory.d/conf.yaml /etc/datadog-agent/conf.d/directory.d/conf.yaml
COPY --chmod=777 startup.sh /bin/startup.sh
COPY --chmod=777 killscript.sh /bin/killscript.sh

CMD ["/bin/startup.sh"]
