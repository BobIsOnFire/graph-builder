FORMAT ?= png

DOT_EXEC  ?= dot
TRED_EXEC ?= tred
DOT_FLAGS += -T$(FORMAT) -Elen=2

INSTALL_FOLDER  ?= $(DESKTOP)/dots_$(FORMAT)
TRED_RAW_GRAPHS ?= $(wildcard cities.dot)

GRAPHS           := $(filter-out $(TRED_RAW_GRAPHS),$(wildcard *.dot))
TRED_GRAPHS	 := $(patsubst %.dot,%.tred.dot,$(TRED_RAW_GRAPHS))
PICTURES         := $(patsubst %.dot,%.$(FORMAT),$(GRAPHS) $(TRED_GRAPHS))
INSTALL_PICTURES := $(patsubst %,$(INSTALL_FOLDER)/%,$(PICTURES))

all: $(PICTURES)

%.$(FORMAT): %.dot Makefile
	$(DOT_EXEC) $(DOT_FLAGS) $< > $@

%.tred.dot: %.dot Makefile
	$(TRED_EXEC) $< > $@

install: $(INSTALL_FOLDER) $(INSTALL_PICTURES)

$(INSTALL_FOLDER):
	mkdir -p $@

$(INSTALL_FOLDER)/%: % | $(INSTALL_FOLDER)
	cp $< $@

clean:
	rm -rf $(PICTURES) 

.PHONY: all install clean

