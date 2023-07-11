FROM golang:1.20.5-alpine3.18
ENV CGO_ENABLED 0
RUN apk update && apk add bash inotify-tools
RUN mkdir /app/
WORKDIR /app/
COPY startScript.sh /app/startScript.sh
COPY . /app/
RUN go mod download
RUN go get go-skeleton-dockerized
RUN go get go.mongodb.org/mongo-driver
RUN go build -gcflags "all=-N -l" -o /server .
RUN go install github.com/go-delve/delve/cmd/dlv@latest
RUN go get github.com/beego/bee/v2
RUN go get -u github.com/beego/bee/v2
#RUN mkdir ~/.go
#RUN echo "GOPATH=$HOME/.go" >> ~/.bashrc
#RUN echo "export GOPATH" >> ~/.bashrc
#RUN echo "PATH=\$PATH:\$GOPATH/bin # Add GOPATH/bin to PATH for scripting" >> ~/.bashrc
#RUN source ~/.bashrc
RUN echo $PATH
RUN export PATH="$PATH:/go/bin";
RUN echo $PATH

ENTRYPOINT sh startScript.sh