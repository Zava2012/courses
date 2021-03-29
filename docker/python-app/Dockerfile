FROM ubuntu:20.04

RUN apt update && apt install -y python3 python3-pip curl

WORKDIR /app
COPY ./ ./
RUN pip3 install -r requirements.txt
RUN ls -la && pwd

ARG name

ENV myenv=myuser

RUN echo "ARG: ${name}"; echo "ENV: ${myenv}"

ONBUILD RUN ls -la

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl", "localhost:5000" ]

VOLUME [ "/data" ]

RUN useradd test

USER test

RUN whoami

EXPOSE 5000

CMD [ "python3", "app.py" ]
