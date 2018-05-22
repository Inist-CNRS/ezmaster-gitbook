FROM nginx:1.13.12

# to help docker debugging
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y install vim curl gnupg2 git jq

# nodejs instalation used for startup scripts
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y build-essential nodejs

#install dependencies
RUN mkdir -p /app
WORKDIR /app
COPY ./package.json /app/package.json

RUN npm install gitbook-cli@2.3.2 -g

#ENTRYPOINT
COPY config.json /
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
COPY pull_build.periodically.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/pull_build.periodically.sh

# nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# ezmasterization of refgpec
# see https://github.com/Inist-CNRS/ezmaster-gitbook
# notice: httpPort is useless here but as ezmaster require it (v3.8.1) we just add a wrong port number
RUN echo '{ \
  "httpPort": 8080, \
  "configPath": "/config.json", \
  "configType": "json", \
  "dataPath": "/app/src/_book" \
}' > /etc/ezmaster.json

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
