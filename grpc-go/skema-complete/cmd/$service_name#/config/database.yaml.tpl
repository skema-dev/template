database:
    db1:
        type: mysql
        username: root
        password: {{ .Value.MysqlPassword }}
        host: {{.Value.MysqlServerName}}
        port: 3306
        dbname: {{ .ProtocolServiceNameLower }}
        charset: utf8mb4
        automigrate: true
        retry: 100
        models:
{{- range .DataModels }}
        - {{ .ModelNameCamelCase }}:
{{- end}}
