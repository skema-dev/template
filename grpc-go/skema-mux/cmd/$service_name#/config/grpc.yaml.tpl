port: 9991     # for grpc service
{{ if .HttpEnabled }}
http:
  port: 9992   # for http service
  gateway:
    # path: "/test1/"
    path: "/"  # this is the routing prefix if you need. You can force to append an extra path before all standard URLs
  swagger:
    path: {{ .ProtocolServiceNameLower }}
    filepath: "./config/swagger.json"    
{{ end }}

logging:
  level: debug # info | debug
  encoding: console # console | json
  output: "./log/default.log"