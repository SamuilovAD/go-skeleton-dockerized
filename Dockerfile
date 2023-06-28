FROM golang:1.20.5-alpine3.18
ENV CGO_ENABLED 0
RUN apk update && apk add bash inotify-tools
RUN mkdir /build/
WORKDIR /build/
COPY startScript.sh /build/startScript.sh
COPY . /build/
RUN go mod download
RUN go get go-skeleton-dockerized
RUN go get go.mongodb.org/mongo-driver
RUN go build -gcflags "all=-N -l" -o /server .
RUN go install github.com/go-delve/delve/cmd/dlv@latest
ENTRYPOINT sh startScript.sh