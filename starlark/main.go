package main

import (
	"fmt"
	"strconv"

	"go.starlark.net/lib/json"
	"go.starlark.net/starlark"
)

func load(_ *starlark.Thread, module string) (starlark.StringDict, error) {
	// todo detect cycles
	thread := &starlark.Thread{Name: "module " + module, Load: load}
	globals, err := starlark.ExecFile(thread, module, nil, nil)

	return globals, err
}

// Execute Starlark program in a file.
func main() {
	thread := &starlark.Thread{Name: "my thread", Load: load}
	globals, err := starlark.ExecFile(thread, "plot.star", nil, starlark.StringDict{"json": json.Module})
	if err != nil {
		panic(err)
	}

	// retrieve the starlark json functions
	json_encode := json.Module.Members["encode"]
	json_indent := json.Module.Members["indent"]

	// retrieve the plot to output
	plot := globals["result"]
	plotv1 := starlark.NewDict(1)
	plotv1.SetKey(starlark.String("plot.v1"), plot)

	// json encode then indent the plot using starlark library
	v, err := starlark.Call(thread, json_encode, starlark.Tuple{plotv1}, nil)
	if err != nil {
		panic(err)
	}
	v, err = starlark.Call(thread, json_indent, starlark.Tuple{v}, nil)
	if err != nil {
		panic(err)
	}

	// unescape the resulting string
	plotJson, err := strconv.Unquote(v.String())
	if err != nil {
		panic(err)
	}

	// print the result
	fmt.Println(plotJson)
}
