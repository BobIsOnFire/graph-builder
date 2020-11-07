__[graphviz](https://graphviz.org/) package is required to transform .dot
graphs! [imagemagick](https://imagemagick.org/index.php) package is 
required to compose gifs!__

# Project overview
This project is a collection of experiments to study possibilities of graphviz
package and different transformations that can be made via it. Study this file
and mans for respective utilities (dot, tred, convert) for deeper understanding.

## Quick launch
Launch this command from repository root to install all projects, or in a single
project for a single install:

```
make install -j 8 INSTALL_DIR=<your_install_dir>
```

This wil build and place all plain images and gifs into the specified
directory. Run `make clean` to clean this worktree (installed files will
remain untouched)

## Utilities overview
dot - transform oriented graph description into visual representation of graph
itself.

tred - swap nodes and edges in the graph to have as little edge intersections
as possible.

convert - perform various conversions on image files.

See mans for detailed descriptions.

## Projects structure

```
root
├── prj1
│   ├── base.dot
│   ├── frames
│   │   ├── 01.frame
│   │   ├── 02.frame
│   │   └── ...
│   ├── Makefile
│   └── plain
│       ├── prj1-img-plain.dot
│       └── ...
├── prj2
│   └── ...
│   ...
├── driver.mk
└── Makefile
```

### Root consists of:
* projects directories.
* driver.mk - main machinery for project builds.
* Makefile - to recursively launch every project.

### Project consists of:
* base.dot - a base file for frame description.
* frames directory - raw style description for every frame. These files are
translated into .dot files, which then are transformed into a single .gif file
during the build. 
* Makefile - configuration for a single project.
* plain directory - every .dot file located here is transformed into plain
image during the build.

# Building your own project
1. Create a directory structure for it:

```
mkdir -p my_project/plain my_project/frames
```

2. Create following `my_project/Makefile` (you can check different makefile configurations in project examples):

```
# Insert any configuration you need before include.
# Do not write any rules and targets! Also anything below include will most
# probably be ignored.
include ../driver.mk
```

3. If you want to create plain images, place .dot files in the plain/
directory.

   Also you can preprocess .dot files with tred by adding file to the
`TRED_RAW_GRAPHS` list. Note that tred can only work with directed graphs, but
you can override the final look by setting `DOT_FLAGS += -Edir=none` in the
project Makefile. See **cities** project configuration as an example.

4. If you want to create gifs, create my_project/base.dot file first. It should
be a valid .dot file. Animations are done by changing attributes of different
elements (nodes, edges, entire graph) in each frame. All places where animation
will be placed should be marked with `/* FRAMES */`. _bug!_ If you place more
than one `/* FRAMES */` mark in the line, only the first mark will be parsed.

   Then you should create numerous .frame files in my_project/frames directory.
Each line in the .frame replaces a single `/* FRAMES */` mark in base.dot. The
usage might seem complicated, check the example projects if you are in doubt.

   Do not forget to add `GIFS = YES` to the project Makefile!

5. Build the project and check the results:

```
make
```

Run `make clean` to remove intermediate files.

## Project configuration:
* `FORMAT` - Output graph format (png as default). See man dot for all possible
formats.
* `GIFS` - should build gifs or not (YES/NO; NO as default)
* `DOT_FLAGS` - custom dot flags (`-T$(FORMAT) -Elen=2` are always used)
* `DELAY` - pause between frames (60 as default)
* `LOOP` - add loop iterations (0 as default, which is infinite loop)
* `GIF_CONVERT_EXEC` - custom convert flags (`-delay $(DELAY) -loop $(LOOP)`
are always used)
* `INSTALL_DIR` - where the images should be installed by 'make install' call
(`root/dots_$(FORMAT)` as default)
* `TRED_RAW_GRAPHS` - which graphs should be preprocessed via tred (absolute or
relative to project root, __even__ if make is launched from repository root)
