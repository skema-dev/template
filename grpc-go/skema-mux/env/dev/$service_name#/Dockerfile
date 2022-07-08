FROM golang:1.18
WORKDIR /app
ADD . .
RUN go mod tidy
RUN go install ./cmd/{{.ProtocolServiceNameLower}}
ENTRYPOINT {{.ServiceNameLower}} --config=cmd/{{.ProtocolServiceNameLower}}/config/grpc.yaml
