FROM golang:1.18
WORKDIR /app
ADD . .
RUN ls .
RUN go mod tidy && go install ./cmd/{{.ProtocolServiceNameLower}}
RUN mv cmd/{{.ProtocolServiceNameLower}}/config .
ENTRYPOINT {{.ProtocolServiceNameLower}}
