# find out where ruby is. can override this by providing environment or command
# line variable
RUBY ?= $(shell ./find-ruby.sh)

default: install

.PHONY: delete
delete:
	@echo going to remove the bundle directory. press ENTER to continue.
	@read
	rm -rf bundle

NEOBUNDLE := bundle/neobundle.vim
${NEOBUNDLE}:
	rm -rf bundle/vundle
	mkdir -p bundle && cd bundle && git clone https://github.com/Shougo/neobundle.vim.git

.PHONY: git-cleanup
git-cleanup:
	ls bundle | while read b;do (cd bundle/$$b && git clean -f);done

.PHONY: cleanup
cleanup:
	vim -u bundles.vim +NeoBundleClean +NeoBundleCheck +NeoBundleDocs

.PHONY: compile-command-t
compile-command-t:
	test ! -d bundle/Command-T || (cd bundle/Command-T/ruby/command-t/ && $(RUBY) extconf.rb && make)

.PHONY: compile-vimproc
compile-vimproc:
	test ! -d bundle/vimproc || make -C bundle/vimproc

.PHONY: compile
compile: compile-command-t compile-vimproc

.PHONY: install
install: ${NEOBUNDLE} cleanup compile

.PHONY: reinstall
reinstall: delete install

.PHONY: help
help:
	@echo make install                     (default) make sure all bundles installed and compiled
	@echo make reinstall                   [DANGEROUS!] - remove bundles and reinstall
