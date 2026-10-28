NVIM ?= nvim
export NVIM_LOG_FILE ?= /tmp/paper-platinum-nvim.log
export XDG_STATE_HOME ?= /tmp/paper-platinum-state

.PHONY: test test-lsp test-languages

test:
	$(NVIM) --headless -u NONE -i NONE -l tests/run.lua

test-lsp:
	$(NVIM) --headless -u NONE -i NONE -l tests/lsp.lua

test-languages:
	$(NVIM) --headless -u NONE -i NONE -l tests/languages.lua
