port: {{.Value.GrpcPort}}     # for grpc service
{{ if .HttpEnabled }}
http:
  port: {{.Value.HttpPort}}   # for http service
  gateway:
    # path: "/test1/"
    path: "/"  # this is the routing prefix if you need. You can force to append an extra path before all standard URLs
  swagger:
    path: /{{ .ProtocolServiceNameLower }}/swagger
    filepath: "./config/swagger.json"
{{ end }}

logging:
  level: debug # info | debug
  encoding: console # console | json
  output: "./log/default.log"