database:
    db1:
        type: mysql
        username: root
        password: {{ .Value.MysqlPassword }}
        host: {{.Value.MysqlServerName}}
        port: 3306
        dbname: {{ .OriginalServiceNameLower }}
        charset: utf8mb4
        automigrate: true
        retry: 3
        models:
{{- range .DataModels }}
        - {{ .ModelNameCamelCase }}:
{{- end}}
