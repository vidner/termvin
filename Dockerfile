FROM nginx:alpine

WORKDIR /opt/vlang

ENV VVV  /opt/vlang
ENV PATH /opt/vlang:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV VFLAGS -cc gcc

RUN mkdir -p /opt/vlang && ln -s /opt/vlang/v /usr/bin/v

RUN apk --no-cache add \
  git make gcc bash\
  musl-dev \
  openssl-dev

RUN git clone https://github.com/vlang/v /opt/vlang && make && v -version

COPY nginx.conf /etc/nginx/nginx.conf
COPY . /app
RUN v /app/termvin.v
RUN chmod +x /app/start.sh
CMD [ "/app/start.sh" ]

