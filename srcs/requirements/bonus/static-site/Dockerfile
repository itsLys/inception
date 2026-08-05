FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    nodejs \
    npm

COPY portfolio /portfolio

WORKDIR /portfolio

EXPOSE 3000

CMD [ "node", "app.js" ]

