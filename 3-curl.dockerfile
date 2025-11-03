FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl

RUN adduser --disabled-password myuser

USER myuser

ENTRYPOINT ["curl"]

CMD ["https://example.com"]
