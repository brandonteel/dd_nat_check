# NAT IP Change Monitor

This project consists of two Docker containers that work together to monitor changes in the external NAT IP address and generate metrics for monitoring:

## check-ip Container

Located in the `check-ip` directory, this container is responsible for detecting changes in the external IP address.

### Features:
- Built on Alpine Linux 3.21.3
- Periodically checks the external IP using `ipv4.icanhazip.com`
- Writes the current IP to a shared volume at `/var/checks/check_ip/check_ip`
- Implements a liveness check by writing timestamps to `/var/checks/still_alive/still_alive`
- Logs IP changes with timestamps
- Error handling with status codes

### Volume Mount:
- Requires a volume mounted at `/var/checks`
- Creates two subdirectories:
  - `/var/checks/check_ip/` - stores the current IP
  - `/var/checks/still_alive/` - stores liveness check timestamps

## dd-directory Container

Located in the `dd-directory` directory, this container runs a Datadog agent that monitors the shared volume for changes.

### Features:
- Based on the official Datadog agent image
- Monitors two directories for changes:
  - `/var/checks/check_ip` - tracks IP changes
  - `/var/checks/still_alive` - monitors the health of the check-ip container
- Exposes DogStatsD (UDP 8125) and trace-agent (TCP 8126) ports
- Configurable shutdown timer (default: 86220 seconds)

### Volume Mount:
- Requires the same volume mounted at `/var/checks` (shared with check-ip container)

## Environment Variables:
- `SHUTDOWN_SECONDS`: By default set to 23 hours and 57 minutes (86220 seconds), time before container gracefully shuts down.
- `DD_SITE`: Normally datadoghq.com, the datadog API endpoint
- `DD_TAGS`: Default tag to add to all metrics
- `DD_HOSTNAME`: Hostname of the agent instance to report to Datadog
- `DD_API_KEY`: API key of the Datadog instance

### Datadog Configuration:
The agent is configured to monitor two instances:
1. NAT IP Check:
   - Directory: `/var/checks/check_ip`
   - Name: check_nat_ip
   - Tag: directory:check_ip

2. Liveness Check:
   - Directory: `/var/checks/still_alive`
   - Name: check_nat_ip_alive
   - Tag: directory:still_alive

## System Operation

1. The `check-ip` container continuously monitors the external IP address:
   - If a change is detected, it updates the file in the shared volume
   - Periodically writes timestamps for liveness monitoring

2. The `dd-directory` container's Datadog agent:
   - Monitors the shared volume for file changes
   - Generates metrics when the IP changes
   - Monitors the liveness check file to ensure the check-ip container is functioning
   - Sends metrics to Datadog for monitoring and alerting

This setup allows for automated monitoring of NAT IP changes and the health of the monitoring system itself through Datadog metrics and alerts.

# Cloud Run Considerations

## Deployment
- **gcloud**: [Confluence](https://telushealth.atlassian.net/wiki/spaces/EO/pages/160759883/Gcloud+Commands#Create-Job)
- **yaml**: [Confluence](https://telushealth.atlassian.net/wiki/spaces/EO/pages/160759902/Creating+Job+with+YAML)

## Scheduling
- check-ip should be scheduled to run regularly, eg. 5 minute intervals
- dd-directory should be scheduled to run once every 24 hours. See [SHUTDOWN_SECONDS](#SHUTDOWN_SECONDS)

## SHUTDOWN_SECONDS
- This is set to 23 hours and 57 minutes because Cloud Run Jobs can only run for 1 day before being forcibly shut down. A Cloud Scheduler job can be set up to restart this container every day, and it will shut down gracefully 3 minutes before it hits the limit. If this is not set, you'll see errors in the Cloud Run logs when the container is forced to shut down every night, and it may prevent the new instance from starting up. See the page on [Confluence](https://telushealth.atlassian.net/wiki/spaces/EO/pages/160694353/Scheduling+Job)

# Datadog Monitor
- **Monitor IP**: avg(last_5m):avg:system.disk.directory.file.modified_sec_ago.median{monitor:natip} by {monitor} <= 300
  - This will alert if the file in /var/checks/check_ip has changed in the last 5 minutes, indicating that the NAT IP has changed
- **Monitor Liveness**: avg(last_5m):avg:system.disk.directory.file.modified_sec_ago.median{monitor:natip} by {monitor} >= 600
  - This will alert if the file in  `/var/checks/still_alive` has not updated in the past 10 minutes, indicating that the check-ip container has not been updating the file it uses to verify its liveness.