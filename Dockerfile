FROM golang:alpine AS deps

RUN apk update --no-cache && apk add git
WORKDIR /app

ENV GO111MODULE=on

COPY go.mod .
COPY go.sum .

RUN go mod download

ADD ./ /app

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-w -extldflags "-static"' -o azuretest  .

FROM alpine
WORKDIR /app
COPY --from=build /app/azuretest /app

ENTRYPOINT ["/app/azuretest"]

EXPOSE 8000
