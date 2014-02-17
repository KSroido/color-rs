# Copyright 2013 The GLFW-RS Developers. For a full listing of the authors,
# refer to the AUTHORS file at the top-level directory of this distribution.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

RUSTC               = rustc
RUSTDOC             = rustdoc

SRC_DIR             = src
LIB_FILE            = $(SRC_DIR)/lib.rs

CRATE_NAME          = $(shell $(RUSTC) --crate-name $(LIB_FILE))
CRATE_FILES         = $(shell $(RUSTC) --crate-file-name $(LIB_FILE))

DOC_DIR             = doc
LIB_DIR             = lib

INSTALL_PREFIX      = /usr/local
BIN_INSTALL_DIR     = $(INSTALL_PREFIX)/bin
LIB_INSTALL_DIR     = $(INSTALL_PREFIX)/lib

all: lib examples doc

lib:
	mkdir -p $(LIB_DIR)
	$(RUSTC) --out-dir=$(LIB_DIR) -C link-args="$(LINK_ARGS)" -O $(LIB_FILE)

doc:
	mkdir -p $(DOC_DIR)
	$(RUSTDOC) -o $(DOC_DIR) $(LIB_FILE)

install: lib
	@ $(foreach crate, $(CRATE_FILES), \
		cp $(LIB_DIR)/$(crate) $(LIB_INSTALL_DIR)/$(crate) && \
		echo "Installed $(crate) to $(LIB_INSTALL_DIR)" ; \
	)

test: lib
	$(RUSTC) --test --out-dir=$(LIB_DIR) -O $(LIB_FILE)
	$(LIB_DIR)/color

uninstall:
	@-rm -f $(LIB_INSTALL_DIR)/lib$(CRATE_NAME)-*.rlib ||:
	@-rm -f $(LIB_INSTALL_DIR)/lib$(CRATE_NAME)-*.so ||:
	@-rm -f $(LIB_INSTALL_DIR)/lib$(CRATE_NAME)-*.dylib ||:

clean:
	rm -rf $(LIB_DIR)
	rm -rf $(EXAMPLES_DIR)
	rm -rf $(DOC_DIR)

.PHONY: \
	all \
	lib \
	doc \
	examples \
	examples-dir \
	$(EXAMPLE_FILES) \
	install \
	uninstall \
	clean \
	test
