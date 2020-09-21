FROM alpine:3.11 AS builder
RUN apk add --no-cache entr py3-pip git zip
COPY slides/requirements.txt .
RUN pip3 install -r requirements.txt
COPY . /app
WORKDIR /app
RUN cd slides && ./build.sh once && rm -rf slides.zip

FROM nginx:alpine
MAINTAINER iaroki
COPY --from=builder /app/slides /usr/share/nginx/html
