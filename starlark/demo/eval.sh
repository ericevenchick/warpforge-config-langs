#!/bin/bash

find . -name plot.star | while IFS= read -r in_file
do 
    out_file="$(dirname $in_file)/plot.wf"
    echo "$in_file -> $out_file"
    warpforge-starlark-generator $in_file > $out_file
done