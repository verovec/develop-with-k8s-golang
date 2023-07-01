FROM golang:latest as base

WORKDIR /app

RUN adduser \
  --no-create-home \
  --uid 65532 \
  nonroot

COPY src/go.* ./

RUN go mod download
RUN go mod verify

COPY src/*.go ./

RUN curl -fLo install.sh https://raw.githubusercontent.com/cosmtrek/air/master/install.sh \
    && chmod +x install.sh && sh install.sh && cp ./bin/air /bin/air

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/app/binary .

CMD ["air"]


FROM alpine:latest

COPY --from=base /etc/passwd /etc/passwd
COPY --from=base /etc/group /etc/group

COPY --from=base /go/app/binary /app

EXPOSE 8080

USER nonroot:nonroot

CMD [ "./app" ]
