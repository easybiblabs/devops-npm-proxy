#!/bin/sh
# ----------------------------------------------------------------------------
# entrypoint for container
# ----------------------------------------------------------------------------
set -e

HOST_IP=`/bin/grep $HOSTNAME /etc/hosts | /usr/bin/cut -f1`
export HOST_IP=${HOST_IP}
echo
echo "container started with ip: ${HOST_IP}..."
echo
for script in /docker-init.d/*; do
	case "$script" in
		*.sh)     echo "... running $script"; . "$script" ;;
		*)        echo "... ignoring $script" ;;
	esac
	echo
done

if [ "$1" == "npmproxy" ]; then
	echo "starting /service.sh..."
	/npmproxy/node_modules/sinopia2/bin/sinopia --config ./config.yaml --listen 0.0.0.0:${NPMPROXY_TCP_PORT}
elif [ "$1" == "bash" ] || [ "$1" == "shell" ]; then
	echo "starting /bin/bash with /etc/profile..."
	/bin/bash --rcfile /etc/profile
else
	echo "Running something else ($@)"
	exec "$@"
fi
