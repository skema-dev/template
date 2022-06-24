package main

import (
	pb "{{ .GoPackageAddress }}"
	"{{.GoModule}}/cmd/{{.ProtocolServiceNameLower}}/service"
	"github.com/skema-dev/skema-go/data"
	"github.com/skema-dev/skema-go/grpcmux"
	"github.com/skema-dev/skema-go/logging"
)

func main() {
	data.InitWithFile("./config/database.yaml", "database")

	srv := grpcmux.NewServer()
	srvImp := service.New()

	{{- range .RpcServices }}
	pb.Register{{ .Name }}Server(srv, srvImp)
	{{- end}}
	{{ if .HttpEnabled }}
	ctx, mux, conn := srv.GetGatewayInfo()
	{{- range .RpcServices }}
	pb.Register{{ .Name }}HandlerClient(ctx, mux, pb.New{{ .Name }}Client(conn))
	{{- end}}
	{{end}}

	logging.Infof("Serving gRPC start...")
	if err := srv.Serve(); err != nil {
		logging.Fatalf("Serve error %v", err.Error())
	}
}
