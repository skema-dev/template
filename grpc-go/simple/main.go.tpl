package main

import (
	pb "{{ .GoPackageAddress }}"
	"github.com/skema-dev/skema-go/grpcmux"
	"github.com/skema-dev/skema-go/logging"
)

func main() {
	srv := grpcmux.NewServer()
	srvImp := {{ .ServiceName }}.New()
	pb.Register{{ .ServiceNameCamelCase }}Server(srv, srvImp)

    {{ if .HttpEnabled }}
	ctx, mux, conn := srv.GetGatewayInfo()
	pb.Register{{ .ServiceNameCamelCase }}HandlerClient(ctx, mux, pb.New{{ .ServiceNameCamelCase }}Client(conn))
    {{end}}

    logging.Infof("Serving gRPC start...")
	if err := srv.Serve(); err != nil {
		logging.Fatalf("Serve error %v", err.Error())
	}
}
