FROM alpine:3.19

RUN apk add --no-cache openssh bash

# Create ssh user
RUN adduser -D tunneluser

# Prepare ssh directory
RUN mkdir -p /home/tunneluser/.ssh && \
    chown -R tunneluser:tunneluser /home/tunneluser/.ssh && \
    chmod 700 /home/tunneluser/.ssh

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER tunneluser

ENTRYPOINT ["/entrypoint.sh"]