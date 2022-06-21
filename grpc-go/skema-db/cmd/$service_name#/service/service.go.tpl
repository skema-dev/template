// Package {{ .ServiceName }} provides {{ .ServiceName }} logic implement
package service

import (
	"context"
	"fmt"
	"github.com/skema-dev/skema-go/data"
	"github.com/skema-dev/skema-go/logging"
	
	"{{.GoModule}}/internal/{{.ServiceNameLower}}/model"

	pb "{{ .GoPackageAddress }}"
)

// {{ .ServiceNameCamelCase }}
type {{ .ServiceNameCamelCase }} struct{
{{- range .RpcServices }}
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

func create{{ .DefaultDataModelNameCamelCase }}Data(msg string) error {
	dao := data.Manager().GetDAO(&model.{{ .DefaultDataModelNameCamelCase }}{})
	err := dao.Upsert(&model.{{ .DefaultDataModelNameCamelCase }}{
		Message: msg,
	}, nil, nil)

	return err
}

func query{{ .DefaultDataModelNameCamelCase }}Data() []model.{{ .DefaultDataModelNameCamelCase }} {
	rs := []model.{{ .DefaultDataModelNameCamelCase }}{}
	dao := data.Manager().GetDAO(&model.{{ .DefaultDataModelNameCamelCase }}{})
	dao.Query(&data.QueryParams{}, &rs)

	return rs
}

{{- range .RpcServices }}
  {{- range .Methods}}

// {{ .Name }}
func (s *{{ $.ServiceNameCamelCase }}) {{ .Name }}(ctx context.Context, req *pb.{{ .RequestType }}) (rsp *pb.{{.ResponseType }},err error) {
	// implement business logic here ...
	// ...

	logging.Infof("Received from {{ .Name }} request: %v", req)

	if err := create{{ $.DefaultDataModelNameCamelCase }}Data(fmt.Sprintf("%v", req)); err != nil {
		logging.Errorf("%s\n", err.Error())
	} else {
		result := query{{ $.DefaultDataModelNameCamelCase }}Data()
		logging.Infof("total %d messages received", len(result))
	}

	rsp = &pb.{{.ResponseType }}{}
	return rsp,err
}
  {{- end}}    
{{- end}}