# Unoverridable (readonly-style) DEST based on /sbin/$VARIABLE_NAME
VARIABLE_NAME := killall-ng

# Prevent overriding DEST via: make DEST=/other/path ...
ifneq ($(origin DEST),undefined)
  $(error DEST is readonly; do not override)
endif

DEST := /sbin/$(VARIABLE_NAME)
READONLY_DEST := $(DEST)

.PHONY: help install deinstall install-all

HELP_TEXT = \
"Usage: make <target>\n" \
"\n" \
"Targets:\n" \
"  make install      -> checks root, then asks YES/NO (Install)\n" \
"  make deinstall    -> checks root, then asks YES/NO (Deinstall)\n" \
"  make install-all  -> runs install + deinstall without prompts\n" \
"  make help         -> shows this help text\n" \
"\n" \
"Notes:\n" \
"  Please answer in uppercase: YES or NO (or y/n).\n" \
"  Install/deinstall path: $(READONLY_DEST)\n"

help:
	@printf "%s" "$(HELP_TEXT)"

check-root:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "You have not the rights."; \
		exit 1; \
	fi

install: check-root
	@printf "Install to path [%s]? (Type YES or NO) > " "$(READONLY_DEST)"; \
	read ans; \
	case "$$ans" in \
		yes|YES|y|Y ) \
			echo "Installing to $(READONLY_DEST) ..."; \
			mkdir -p "$(READONLY_DEST)"; \
			# TODO: Add your real install commands here, e.g.:
			# cp -a ./bin/myprog "$(READONLY_DEST)/myprog" ; \
			;; \
		no|NO|n|N ) \
			echo "Cancelled (no installation)."; \
			;; \
		* ) \
			echo "Invalid input. Please type YES or NO."; \
			exit 1; \
			;; \
	esac

deinstall: check-root
	@printf "Deinstall from path [%s]? (Type YES or NO) > " "$(READONLY_DEST)"; \
	read ans; \
	case "$$ans" in \
		yes|YES|y|Y ) \
			echo "Deinstalling from $(READONLY_DEST) ..."; \
			# TODO: Remove only what you installed (adjust to your real files). \
			rm -rf "$(READONLY_DEST)"; \
			;; \
		no|NO|n|N ) \
			echo "Cancelled (no deinstallation)."; \
			;; \
		* ) \
			echo "Invalid input. Please type YES or NO."; \
			exit 1; \
			;; \
	esac

install-all: check-root
	@echo "Running install-all WITHOUT prompts."
	@$(MAKE) install
	@$(MAKE) deinstall
