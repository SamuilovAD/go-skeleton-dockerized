# syntax=docker/dockerfile:1

FROM golang:1.19

# Set destination for COPY
WORKDIR /go/app

# Download Go modules
COPY go.mod go.sum ./

RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY ./ ./

RUN go get go-skeleton-dockerized

RUN go get go.mongodb.org/mongo-driver

# Build
RUN go build -o /main .

RUN rm go.mod

# Run
CMD ["/main"]