apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{.ServiceNameLower}}-deployment
  labels:
    app: {{.ServiceNameLower}}
spec:
  selector:
    matchLabels:
      app: {{.ServiceNameLower}}
  replicas: 1
  template:
    metadata:
      labels:
        app: {{.ServiceNameLower}}
    spec:
      containers:
        - name: {{.ServiceNameLower}}
          image: docker.io/dev/{{.ProtocolServiceNameLower}}:latest
          imagePullPolicy: Never  # or IfNotPresent
          ports:
            - containerPort: {{.Value.HttpPort}}
              protocol: TCP
            - containerPort: {{.Value.GrpcPort}}
              protocol: TCP
---
apiVersion: v1
kind: Pod
metadata:
  name: mysql-db
  labels:
    app: mysql-db
spec:
  containers:
    - name: mysql-db
      image: mysql
      imagePullPolicy: IfNotPresent  # or IfNotPresent
      ports:
        - containerPort: 3306
          protocol: TCP
      env:
          - name: MYSQL_ROOT_PASSWORD
            value: {{ .Value.MysqlPassword }}
          - name: MYSQL_DATABASE
            value: {{ .ProtocolServiceNameLower }}            
---
apiVersion: v1
kind: Pod
metadata:
  name: phpmyadmin
  labels:
    app: phpmyadmin
spec:
  containers:
    - name: phpmyadmin
      image: phpmyadmin/phpmyadmin
      imagePullPolicy: IfNotPresent  # or IfNotPresent
      ports:
        - containerPort: 80
          protocol: TCP
      env:
          - name: PMA_HOST
            value: {{.Value.MysqlServerName}}
          - name: PMA_PORT
            value: "3306"

---
kind: Service
apiVersion: v1
metadata:
  name: {{.ServiceNameLower}}
spec:
  selector:
    app: {{.ServiceNameLower}}
  ports:
  - port: {{.Value.HttpPort}}
    name: http-port
  - port: {{.Value.GrpcPort}}
    name: grpc-port

---
kind: Service
apiVersion: v1
metadata:
  name: {{.Value.MysqlServerName}}
spec:
  type: NodePort
  selector:
    app: mysql-db
  ports:
  - protocol: TCP
    port: 3306
    targetPort: 3306

---
kind: Service
apiVersion: v1
metadata:
  name: phpmyadmin-svc
spec:
  type: NodePort
  selector:
    app: phpmyadmin
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{.ServiceNameLower}}-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /{{.ProtocolServiceNameLower}}/?(.*)
        backend:
          service:
            name:  {{.ServiceNameLower}}
            port:
              number: {{.Value.HttpPort}}
      - pathType: Prefix
        path: /phpmyadmin/?(.*)
        backend:
          service:
            name:  phpmyadmin-svc
            port:
              number: 80