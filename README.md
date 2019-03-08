# Giza.jl

This package is for scientific plotting in Julia with the [Giza
library](https://github.com/danieljprice/giza).

Giza relies on [Cairo](https://cairographics.org/) for producing scientific
plots in various formats (interactive X window, PDF, (E)PS, PNG, etc.)

Giza was inspired by the [PGPLOT
library](http://www.astro.caltech.edu/~tjp/pgplot/) and provides an [almost
complete
replacement](https://github.com/danieljprice/giza/blob/master/docs/documentation/cpgplot-status.html)
of PGPLOT.

In its current state, Giza.jl binds almost all functions of Giza into Julia
(the only missing ones are the routines for plotting functions which can be
easily emulated in Julia).

Calling:

```julia
using Giza
```

brings all Giza constants into scope, all these constants start with
`GIZA_`.  Giza method are not imported but their names have been shortened,
hence: `giza_open_device` becomes `Giza.open_device`.  None of the
`giza_*_float` functions are directly accessible, but get automatically
called when all floating-point array/vector arguments are in single
precision.  For example, to draw a curve, just call `Giza.line` and the
most appropriate of `giza_line` or `giza_line_float` will be used.

An exception is `giza_round` (which round its argument to some *nice*
value) which is binded as `Giza.nice_number` because `round` has another
meaning in Julia.

The Julia methods do not need to known the size of the arrays/vectors
passed as argument, so this argument is omitted in the argument list.
Output arguments are are also omitted in the argument list and functions
which return one or several values return this value or a tuple of values.

For plotting 2D arrays (colored/grayscaled cells, contours, fields of
vectors), the sub-region indices are not part of the arguments in the Julia
version.  Plotting a sub-region is easily achieved by using *views* (FIXME:
loss of efficiency and will be fixed soon).


## Installation

```sh
cd "$PATH_TO_GIZA_REPOS/deps"
make GIZA_JL_DLL="$PATH_TO_GIZA_DLL" rebuild
```
