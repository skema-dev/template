package main

import (
	pb "{{ .GoPackageAddress }}"
	"github.com/skema-dev/skema-go/grpcmux"
	"github.com/skema-dev/skema-go/logging"
)

func main() {
	srv := grpcmux.NewServer()
	srvImp := NewService()

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
