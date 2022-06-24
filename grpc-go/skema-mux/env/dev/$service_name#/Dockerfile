FROM golang:1.18
WORKDIR /app
ADD . .
RUN ls .
RUN go mod tidy && go install ./cmd/{{.ProtocolServiceNameLower}}
ENTRYPOINT {{.ServiceNameLower}} --config=cmd/{{.ProtocolServiceNameLower}}/config/grpc.yaml
