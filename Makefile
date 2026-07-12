# Makefile

PROGRAM_NAME := killall-ng
DEST := /sbin/$(PROGRAM_NAME)
INSTALLED_FILE := $(DEST)

SRC := ./$(PROGRAM_NAME)

.PHONY: help install deinstall install-all

HELP_TEXT := "Usage: make <target>\n\n" \
"Variables:\n" \
"  PROGRAM_NAME (source/program to install): $(PROGRAM_NAME)\n" \
"  SRC  : $(SRC)\n" \
"  DEST : $(DEST)\n\n" \
"Targets:\n" \
"  make install      -> checks root + asks YES/NO\n" \
"  make deinstall    -> checks root + asks YES/NO\n" \
"  make install-all  -> installs and deinstalls (no prompts)\n"

help:
	@printf "%b" "$(HELP_TEXT)"

check-root:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "You have not the rights."; \
		exit 1; \
	fi

install: check-root
	@printf "Do you really want to install? (Type YES or NO) > "; \
	read ans; \
	case "$$ans" in \
		YES|yes|Y|y ) \
			if [ ! -f "$(SRC)" ]; then \
				echo "Missing source file: $(SRC)"; \
				exit 1; \
			fi; \
			echo "Installing to $(DEST) ..."; \
			install -m 0755 -o root -g root "$(SRC)" "$(INSTALLED_FILE)"; \
			;; \
		NO|no|N|n ) \
			echo "Cancelled (no installation)."; \
			;; \
		* ) \
			echo "Invalid input. Please type YES or NO."; \
			exit 1; \
			;; \
	esac

deinstall: check-root
	@printf "Do you really want to deinstall? (Type YES or NO) > "; \
	read ans; \
	case "$$ans" in \
		YES|yes|Y|y ) \
			echo "Deinstalling from $(DEST) ..."; \
			rm -f "$(INSTALLED_FILE)"; \
			;; \
		NO|no|N|n ) \
			echo "Cancelled (no deinstallation)."; \
			;; \
		* ) \
			echo "Invalid input. Please type YES or NO."; \
			exit 1; \
			;; \
	esac

install-all: check-root
	@$(MAKE) install </dev/null
	@$(MAKE) deinstall </dev/null
