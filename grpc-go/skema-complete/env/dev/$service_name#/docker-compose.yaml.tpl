version: "2.1"
services:
  {{.Value.MysqlServerName}}:
    image: mysql
    # (this is just an example, not intended to be a production configuration)
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: {{ .Value.MysqlPassword }}
      MYSQL_DATABASE: {{ .ProtocolServiceNameLower }}

  hello3service:
    image: dev/{{.ProtocolServiceNameLower}}
    depends_on:
      {{.Value.MysqlServerName}}:
        condition: service_started
    ports:
      - "{{.Value.GrpcPort}}:{{.Value.GrpcPort}}"
      - "{{.Value.HttpPort}}:{{.Value.HttpPort}}"

