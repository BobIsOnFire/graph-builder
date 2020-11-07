#### Environment setting
SHELL := /bin/bash

FORMAT ?= png
GIFS   ?= NO

DOT_EXEC  ?= dot
TRED_EXEC ?= tred
DOT_FLAGS += -T$(FORMAT) -Elen=2

INSTALL_DIR     ?= ../dots_$(FORMAT)
TRED_RAW_GRAPHS ?= 

PLAIN_DIR        := plain
GRAPHS           := $(filter-out $(TRED_RAW_GRAPHS),$(wildcard $(PLAIN_DIR)/*.dot))
TRED_GRAPHS	     := $(patsubst $(PLAIN_DIR)/%.dot,$(PLAIN_DIR)/%.tred.dot,$(TRED_RAW_GRAPHS))
PICTURES         := $(patsubst $(PLAIN_DIR)/%.dot,%.$(FORMAT),$(GRAPHS) $(TRED_GRAPHS))
INSTALL_PICTURES := $(patsubst %,$(INSTALL_DIR)/%,$(PICTURES))

ifeq ($(GIFS),YES)

FRAME_DIR        := frames
FRAME_DOT_DIR    := frame_dots
FRAME_PIC_DIR    := frame_$(FORMAT)
FRAMES           := $(wildcard $(FRAME_DIR)/*.frame)

ifneq ($(FRAMES),)

FRAME_GRAPHS     := $(patsubst $(FRAME_DIR)/%,$(FRAME_DOT_DIR)/%.dot,$(FRAMES))
FRAME_PICTURES   := $(patsubst $(FRAME_DIR)/%,$(FRAME_PIC_DIR)/%.$(FORMAT),$(FRAMES))
GIF              := $(notdir $(CURDIR)).gif
INSTALL_PICTURES += $(INSTALL_DIR)/$(GIF)

DELAY ?= 60
LOOP  ?= 0

GIF_CONVERT_EXEC  ?= convert
GIF_CONVERT_FLAGS += -delay $(DELAY) -loop $(LOOP)

endif
endif

#### Targets and rules

all: $(PICTURES)

%.$(FORMAT): $(PLAIN_DIR)/%.dot Makefile
	$(DOT_EXEC) $(DOT_FLAGS) $< > $@

$(PLAIN_DIR)/%.tred.dot: $(PLAIN_DIR)/%.dot Makefile
	$(TRED_EXEC) $< > $@

install: $(INSTALL_DIR) $(INSTALL_PICTURES)

$(INSTALL_DIR):
	mkdir -p $@

$(INSTALL_DIR)/%: % | $(INSTALL_DIR)
	cp $< $@

clean: clean_plain

clean_plain:
	rm -rf $(PICTURES)

ifeq ($(GIFS),YES)
ifneq ($(FRAMES),)

all: $(GIF) $(FRAME_DOT_DIR) $(FRAME_PIC_DIR)

$(FRAME_DOT_DIR)/%.dot: $(FRAME_DIR)/% Makefile | $(FRAME_DOT_DIR)
	@echo "Translating $@ file" 
	@readarray -t replaces < $<; \
	i=0; \
	while read line; do \
    	if [[ $$line == *'/* FRAMES */'* ]]; then \
        	echo "$$line" | sed -e "s@/\* FRAMES \*/@\[$${replaces[$$i]}\]@"; \
        	i=$$(( $$i + 1 )); \
    	else \
        	echo "$$line"; \
    	fi; \
	done < base.dot > $@

$(FRAME_PIC_DIR)/%.$(FORMAT): $(FRAME_DOT_DIR)/%.dot Makefile | $(FRAME_PIC_DIR)
	$(DOT_EXEC) $(DOT_FLAGS) $< > $@

$(FRAME_DOT_DIR) $(FRAME_PIC_DIR):
	mkdir $@

$(GIF): $(FRAME_PICTURES)
	$(GIF_CONVERT_EXEC) $(GIF_CONVERT_FLAGS) $(sort $^) $@

clean: clean_gif

clean_gif:
	rm -rf $(FRAME_DOT_DIR) $(FRAME_PIC_DIR) $(GIF)

endif
endif


.PHONY: all install clean clean_plain clean_gif
