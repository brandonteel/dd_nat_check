FROM datadog/agent:7.62.3-rc.1-linux
LABEL name="dd-directory"
LABEL version="0.4"
LABEL maintainer="brandon.teel@telus.com"
LABEL build_date="2025-03-31"
#2025-04-31 0.4 - hopefully shutdown gracefully

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
