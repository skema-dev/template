package main

import (
	"context"
	"log"
	"net"
	"net/http"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"

	pb "{{ .GoPackageAddress }}"
)

func main() {
	// Create a listener on TCP port
	lis, err := net.Listen("tcp", ":{{.Value.GrpcPort}}")
	if err != nil {
		log.Fatalln("Failed to listen:", err)
	}

	// Create a gRPC server object
	s := grpc.NewServer()
	// Attach the Greeter service to the server
	{{- range .RpcServices }}
	pb.Register{{ .Name }}Server(s, NewService())
	{{- end}}

	// Serve gRPC server
	log.Println("Serving gRPC on 0.0.0.0:{{.Value.GrpcPort}}")
	go func() {
		log.Fatalln(s.Serve(lis))
	}()

	// Create a client connection to the gRPC server we just started
	// This is where the gRPC-Gateway proxies the requests
	conn, err := grpc.DialContext(
		context.Background(),
		"0.0.0.0:{{.Value.GrpcPort}}",
		grpc.WithBlock(),
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
	if err != nil {
		log.Fatalln("Failed to dial server:", err)
	}

	gwmux := runtime.NewServeMux()
	// Register Greeter
	{{- range .RpcServices }}
	err = pb.Register{{ .Name }}HandlerClient(context.Background(), gwmux, pb.New{{ .Name }}Client(conn))
	if err != nil {
		log.Fatalln("Failed to register gateway:", err)
	}
	{{- end}}

	gwServer := &http.Server{
		Addr:    ":{{.Value.HttpPort}}",
		Handler: gwmux,
	}

	log.Println("Serving gRPC-Gateway on http://0.0.0.0:{{.Value.HttpPort}}")
	log.Fatalln(gwServer.ListenAndServe())
}