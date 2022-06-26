package model

import (
	"github.com/skema-dev/skema-go/data"
)

func init() {
	data.R(&{{ .ModelNameCamelCase }}{})
}

type {{ .ModelNameCamelCase }} struct {
	data.Model

	Message   string
}

func ({{ .ModelNameCamelCase }}) TableName() string {
	return "{{ .ModelNameLowerCase }}"
}