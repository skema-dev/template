FROM golang:1.18
WORKDIR /app
ADD . .
RUN ls .
RUN go mod tidy && go install ./cmd/{{.ServiceNameLower}}
ENTRYPOINT {{.ServiceNameLower}} --config=cmd/{{.ServiceNameLower}}/config/grpc.yaml
