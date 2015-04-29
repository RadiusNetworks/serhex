# compiler
CC=gcc

# Directory organization
SRCDIR=./src
OBJDIR=./build
LIBDIR=./lib
BINDIR=./bin

# Compiler flags
CFLAGS=-g -Wall -std=gnu99 -fpic -I./src

## Base filenames
DEPS=serhex/serhex_api rblog/rblog
SRCS=$(patsubst %,$(SRCDIR)/%.c,$(DEPS))
OBJS=$(patsubst %,$(OBJDIR)/%.o,$(DEPS))

# Library name (both .so and a .a will be created)
LIB=libserhex

CLI_SRC=$(SRCDIR)/serhex/serhex_cli.c

CLI_TGT=$(BINDIR)/serhex
LIB_TGT=$(LIBDIR)/$(LIB)

.PHONY : rbcom all lib

all: rbcom lib

rbcom: $(CLI_TGT)

$(CLI_TGT): $(OBJS) $(CLI_SRC)
	$(CC) $(CFLAGS) -I./ $(OBJS) $(CLI_SRC) -o $@

# compile the source file matching the path and name of the obj file
# replacing build path with source path, and .o with .c
$(OBJS): $(SRCS)
	@mkdir -p $(@D)  # create directory in objdir
	$(CC) $(CFLAGS) -c $(patsubst build/%.o,src/%.c,$@) -o $@

lib: $(OBJS)
	$(CC) -shared -o  $(LIB_TGT).so $(OBJS)
	ar rvs $(LIB_TGT).a $(OBJS)

.PHONY : clean clean-all clean-native clean-core clean-lib

clean-all: clean clean-lib

clean:
	rm -f $(OBJS)
	find $(OBJDIR) -empty -type d -delete
	rm -f $(CLI_TGT)

clean-lib:
	rm -f $(LIB_TGT).a
	rm -f $(LIB_TGT).so

.PHONY : install uninstall

prefix?=/usr/local

install: $(CLI_TGT)
	install -m 0755 $(CLI_TGT) $(prefix)/bin

uninstall:
	rm -f $(prefix)/bin/rbcom
