// Package {{ .ServiceName }} provides {{ .ServiceName }} logic implement
package service

import (
	"context"
	"log"

	pb "{{ .GoPackageAddress }}"
)

// {{ .ServiceNameCamelCase }}
type {{ .ServiceNameCamelCase }} struct{
{{- range .Services }}
{{- $ServiceName := .Name }}
{{- $ServiceName := $ServiceName }}
    pb.Unimplemented{{ $ServiceName }}Server
{{- end}}
}

func New() *{{ .ServiceNameCamelCase }} {
	svr := &{{ .ServiceNameCamelCase }}{
		// init custom fileds
	}
	return svr
}

{{- range .Services }}
  {{- range .RPC}}

// {{ .Name }}
func (s *{{ .ServiceCamelCase }}) {{ .Name }}(ctx context.Context, req *pb.{{ .RequestType }}) (rsp *pb.{{.ResponseType }},err error) {
	// implement business logic here ...
	// ...

	log.Printf("Received from {{ .Name }} request: %v", req)
	rsp = &pb.{{.ResponseType }}{
		// Msg: "Hello " + req.GetMsg(),
	}
	return rsp,err
}
  {{- end}}    
{{- end}}