PICORUBY_DIR  ?= ../picoruby
CONFIG_NAME    = htest
ROOT          != pwd
BUILD_CONFIG   = $(ROOT)/build_config/$(CONFIG_NAME).rb
BUILD_NAME    != sed -n 's/^MRuby::Build.new("\([^"]*\)").*/\1/p' $(BUILD_CONFIG)
BUILD_DIR      = $(PICORUBY_DIR)/build/$(BUILD_NAME)
SOURCES       != find mrblib src test -type f 2>/dev/null | sort
BUILD_STAMP    = tmp/build.stamp

MRBC           = $(BUILD_DIR)/bin/mrbc
MRUBY_INCLUDE  = $(PICORUBY_DIR)/mrbgems/picoruby-mruby/lib/mruby/include
MAIN_IREP      = tmp/main.c
BIN            = tmp/$(BUILD_NAME)
DEFINES        = -DPICORB_PLATFORM_POSIX -DMRB_TICK_UNIT=4 -DMRB_TIMESLICE_TICK_COUNT=3 \
                 -DMRB_INT64 -DMRB_NO_BOXING -DMRB_UTF8_STRING -DPICORB_VM_MRUBY \
                 -DMRB_USE_TASK_SCHEDULER -DMRB_BASELINE_PROFILE=1 \
                 -DHAVE_MRUBY_IO_GEM -DNDEBUG=1
CFLAGS         = -std=gnu99 -g $(DEFINES) -I$(MRUBY_INCLUDE) -I$(BUILD_DIR)/include -pthread
LIBS           = $(BUILD_DIR)/lib/libmruby.a -pthread -ljail -lm

.PHONY: all build test clean distclean

all: test

build: $(BIN)

$(BUILD_STAMP): $(BUILD_CONFIG) $(SOURCES)
	mkdir -p tmp
	cd $(PICORUBY_DIR) && MRUBY_CONFIG=$(BUILD_CONFIG) rake all
	touch $(BUILD_STAMP)

$(MAIN_IREP): src/main.rb $(BUILD_STAMP)
	mkdir -p tmp
	$(MRBC) -Bhtest_main -o $@ src/main.rb

$(BIN): main.c $(MAIN_IREP) Makefile
	$(CC) $(CFLAGS) -o $@ main.c $(MAIN_IREP) $(LIBS)

test: build
	$(BIN)

clean:
	rm -f $(BUILD_STAMP) $(MAIN_IREP) $(BIN)
	cd $(PICORUBY_DIR) && MRUBY_CONFIG=$(BUILD_CONFIG) rake clean

distclean: clean
	rm -rf $(BUILD_DIR)
