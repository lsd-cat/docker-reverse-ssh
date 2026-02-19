#!/bin/sh
set -e

# Write tunnel private key from env variable
echo "$TUNNEL_PRIVATE_KEY" > /home/tunneluser/.ssh/id_ed25519
chmod 600 /home/tunneluser/.ssh/id_ed25519

# Write authorized_keys for login
echo "$LOGIN_PUBLIC_KEY" > /home/tunneluser/.ssh/authorized_keys
chmod 600 /home/tunneluser/.ssh/authorized_keys

# Generate host keys if missing
if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
  ssh-keygen -A
fi

# Start SSH daemon
/usr/sbin/sshd

# Establish reverse tunnel
exec ssh -N \
  -o StrictHostKeyChecking=no \
  -i /home/tunneluser/.ssh/id_ed25519 \
  -R ${REMOTE_PORT}:localhost:22 \
  ${REMOTE_USER}@${REMOTE_HOST}