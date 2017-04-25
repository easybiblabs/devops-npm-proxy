FROM  mhart/alpine-node:latest

MAINTAINER jgilley@chegg.com

# set our environment
ENV APP_ENV='DEVELOPMENT'
# ENV APP_ENV='PRODUCTION'
ENV NPMPROXY_TCP_PORT=4873

# install base packages - BASH should only be used for debugging, it's almost a meg in size
# install ca-certificates
# clean up the apk cache (no-cache still caches the indexes)
# update the ca-certificates
RUN	apk --update --no-cache add \
		ca-certificates \
		build-base \
		python \
    	python-dev \
    	py-pip && \
	rm -rf /var/cache/apk/* && \
	update-ca-certificates

COPY entrypoint.sh /entrypoint.sh

RUN adduser -D -S -s /bin/sh -h /npmproxy npmproxy && \
	chmod a+x /entrypoint.sh && \
	mkdir -p /npmproxy/storage && \
	chmod a+rw /npmproxy/storage

WORKDIR /npmproxy

# RUN npm install js-yaml sinopia2 sinopia-github-oauth sinopia-github && \
RUN npm install js-yaml sinopia2 sinopia-github

COPY docker.yaml /npmproxy/config.yaml
COPY cli.js /npmproxy/node_modules/sinopia2/lib/cli.js

VOLUME ["/npmproxy/storage"]

# the entry point definition
ENTRYPOINT ["/entrypoint.sh"]

# default command for entrypoint.sh
CMD ["npmproxy"]

