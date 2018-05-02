FROM ruby:2.5.1

ENV LANG=C.UTF-8

RUN set -ex && \
      apt-get update -qq && \
      apt-get install -y build-essential libpq-dev nodejs openssl libxml2-dev libxslt-dev

ENV ENTRYKIT_VERSION=0.4.0
RUN set -ex && \
      curl -LO https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
      tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
      rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
      mv entrykit /bin/entrykit && \
      chmod +x /bin/entrykit && \
      entrykit --symlink

RUN mkdir -p /app/nova
WORKDIR /app/nova

RUN bundle config build.nokogiri --use-system-libraries
ENV PATH=/app/nova/bin:$PATH

ENTRYPOINT [ \
  "prehook", "ruby -v", "--", \
  "prehook", "./bin/docker-setup", "--"]
