version: "2.1"
services:
  {{.Value.MysqlServerName}}:
    image: mysql
    # (this is just an example, not intended to be a production configuration)
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: {{ .Value.MysqlPassword }}
      MYSQL_DATABASE: {{ .OriginalServiceNameLower }}

  hello3service:
    image: dev/{{.ServiceNameLower}}
    depends_on:
      mysql-server:
        condition: service_started
    ports:
      - "19991:9991"
      - "19992:9992"

