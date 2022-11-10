# CUE + Warpforge

## What's this?

This repo is an attempt to generate Warpforge plots using the CUE configuration language.

Each subdirectory contains a Warpforge module and plot. The plot is written in CUE (`plot.cue`) and then auto-generated into a `plot.wf` file.

## How do I use it?

First, install CUE with `go install cuelang.org/go/cmd/cue@latest`.

In each directory, you can run `cue export . > plot.wf` to generate the `plot.wf` from the `plot.cue`. Then, you can run the build as normal with `warpforge run`.


