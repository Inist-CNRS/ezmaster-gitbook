FROM nginx:1.13.3

# to help docker debugging
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y install vim curl gnupg2 git jq

# nodejs instalation used for startup scripts
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y build-essential nodejs

#install dependencies
RUN mkdir -p /app
WORKDIR /app
COPY ./package.json /app/package.json

RUN npm install gitbook-cli -g

#ENTRYPOINT
COPY config.json /
COPY docker-entrypoint.overload.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.overload.sh
COPY pull_build.periodically.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/pull_build.periodically.sh

# nginx config
COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.overload.sh" ]
