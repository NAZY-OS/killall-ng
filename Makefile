# Generic Makefile Template
# =========================

# Variables
# ---------
PROGRAM_NAME ?= killall-ng
DEST ?= /bin/$(PROGRAM_NAME)
INSTALLED_FILE := $(DEST)
SRC ?= ./$(PROGRAM_NAME)

# Phony Targets
.PHONY: help install deinstall remove install-all remove-silent install-silent help-h help---help

# Help text (mit doppelten \n für Zeilenumbrüche)
HELP_TEXT := Usage:\n\
  make help          # Show this help message\n\
  make install       # Install with YES/NO prompt\n\
  make deinstall     # Uninstall with YES/NO prompt\n\
  make remove        # Alias for deinstall\n\
  make install-all   # Install without prompt\n\
  make remove-silent # Uninstall without prompt\n\
  make install-silent # Install without prompt\n\
  make -h            # Show help (short form)\n\
  make --help        # Show help (long form)\n

help:
	@echo -e "$(HELP_TEXT)"

help-h:
	@$(MAKE) help

help---help:
	@$(MAKE) help

check-root:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "Error: Root privileges required"; \
		exit 1; \
	fi

check-source:
	@if [ ! -f "$(SRC)" ]; then \
		echo "Error: Source file $(SRC) not found"; \
		exit 1; \
	fi

do-install: check-source
	@echo "Installing $(PROGRAM_NAME) from $(SRC) to $(DEST) ..."; \
	install -m 0755 -o root -g root "$(SRC)" "$(INSTALLED_FILE)"; \
	echo "OK: $(PROGRAM_NAME) successfully installed to $(DEST)"; \
	echo "Installation completed successfully"

do-deinstall:
	@if [ ! -e "$(INSTALLED_FILE)" ]; then \
		echo "Nothing to remove: $(INSTALLED_FILE) does not exist"; \
	else \
		echo "Uninstalling $(PROGRAM_NAME) from $(DEST) ..."; \
		rm -f "$(INSTALLED_FILE)"; \
		echo "OK: $(PROGRAM_NAME) successfully removed from $(DEST)"; \
		echo "Uninstallation completed successfully"; \
	fi

install: check-root
	@echo "=== Installing $(PROGRAM_NAME) ==="
	@while : ; do \
		printf "Install $(PROGRAM_NAME)? (YES/NO) > " ; \
		read ans; \
		case "$$ans" in \
			YES|NO|Y|N) \
				if [ "$$ans" = "YES" ] || [ "$$ans" = "Y" ]; then \
					$(MAKE) do-install; \
				else \
					echo "Installation of $(PROGRAM_NAME) cancelled"; \
				fi; \
				break ;; \
			*) \
				if [ $$REPLY = "y" ] || [ $$REPLY = "n" ]; then \
					echo "Please use UPPERCASE letters (YES/NO)"; \
				else \
					echo "Invalid input. Please type YES or NO (uppercase)"; \
				fi;; \
		esac; \
	done

deinstall: check-root
	@echo "=== Uninstalling $(PROGRAM_NAME) ==="
	@while : ; do \
		printf "Uninstall $(PROGRAM_NAME)? (YES/NO) > " ; \
		read ans; \
		case "$$ans" in \
			YES|NO|Y|N) \
				if [ "$$ans" = "YES" ] || [ "$$ans" = "Y" ]; then \
					$(MAKE) do-deinstall; \
				else \
					echo "Uninstallation of $(PROGRAM_NAME) cancelled"; \
				fi; \
				break ;; \
			*) \
				if [ $$REPLY = "y" ] || [ $$REPLY = "n" ]; then \
					echo "Please use UPPERCASE letters (YES/NO)"; \
				else \
					echo "Invalid input. Please type YES or NO (uppercase)"; \
				fi;; \
		esac; \
	done

remove: deinstall

install-all: check-root check-source
	@echo "=== Automatic installation of $(PROGRAM_NAME) ==="
	@$(MAKE) do-install

remove-silent: check-root
	@echo "=== Automatic uninstallation of $(PROGRAM_NAME) ==="
	@$(MAKE) do-deinstall

install-silent: check-root check-source
	@echo "=== Automatic installation of $(PROGRAM_NAME) ==="
	@$(MAKE) do-install
