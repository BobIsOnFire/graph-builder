# _graphviz_ package is required to transform .dot graphs!

## Overview
dot - transform oriented graph description into visual representation of graph itself. See man dot for detailed desscription.
tred - swap nodes and edges to have as little edge intersections as possible.

## Makefile variables:
* FORMAT - Output graph format (png as default)
* DOT\_EXEC, TRED\_EXEC - dot & tred executables location
* DOT\_FLAGS - custom dot flags (-T$(FORMAT) -Elen=2 as default)
* INSTALL\_FOLDER - where the images should be installed by 'make install' call (pwd/dots\_$(FORMAT) as default)
* TRED\_RAW\_GRAPHS - which graphs should be preprocessed via tred (only cities.dot is default)

## TODO
* Test other graph output formats
* gifs!
