package base

import "strings"

protoformula: {
	inputs: {...}
	action: {...}
	outputs: {...}
}

plot: {
	inputs: {...}
	steps: {...}
	outputs: {...}
}

catalogentry: {
	module:  string
	release: string
	item:    string
	as_string:     "catalog:\(module):\(release):\(item)"
	path:    "/pkg/\(module)"
}

pathstr: {
	items: [...string]
	as_string: "literal:\(strings.Join(items, ":"))"
}
