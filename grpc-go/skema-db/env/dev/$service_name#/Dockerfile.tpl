FROM golang:1.18
WORKDIR /app
ADD . .
RUN ls .
RUN go mod tidy && go install ./cmd/{{.ServiceNameLower}}
RUN mv cmd/{{.ServiceNameLower}}/config .
ENTRYPOINT {{.ServiceNameLower}}
