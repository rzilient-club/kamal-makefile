RED=\033[0;31m
BLUE=\033[0;34m
LIGHT_GREY=\033[0;37m
YELLOW=\033[0;33m
DARK_GREEN=\033[38;5;22m
GREEN=\033[38;5;28m
BRIGHT_GREEN=\033[38;5;34m
LIME_GREEN=\033[38;5;40m
LIGHT_LIME_GREEN=\033[38;5;46m
PALE_GREEN=\033[38;5;82m
LIGHT_GREEN=\033[38;5;118m
VERY_LIGHT_GREEN=\033[38;5;154m
BRIGHT_GREEN=\033[38;5;34m
VERY_LIGHT_GREEN=\033[38;5;154m
COLOUR_END=\033[0m


#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

define HEADER
$(DARK_GREEN)              .__.__  .__               __      __                .__$(COLOUR_END)
$(GREEN)______________|__|  | |__| ____   _____/  |_  _/  |_  ____   ____ |  |__$(COLOUR_END)
$(BRIGHT_GREEN)\_  __ \___   /  |  | |  |/ __ \ /    \   __\ \   __\/ __ \_/ ___\|  |  \\$(COLOUR_END)
$(LIME_GREEN) |  | \//    /|  |  |_|  \  ___/|   |  \  |    |  | \  ___/\  \___|   Y  \\$(COLOUR_END)
$(LIGHT_LIME_GREEN) |__|  /_____ \__|____/__|\___  >___|  /__|    |__|  \___  >\___  >___|  /$(COLOUR_END)
$(PALE_GREEN)             \/               \/     \/                  \/     \/     \/$(COLOUR_END)
endef

export HEADER

# Define a preamble target to print the header
preamble:
	@echo "$$HEADER"

# Ensure the preamble runs before any target
.PHONY: preamble FORCE

# Add FORCE dependency to every target to ensure preamble is always executed
%: preamble FORCE
	@:

# Declare all targets as .PHONY to prevent conflicts
.PHONY: credentials kamal rubocop

ENV=
credentials:
	@echo "$(GREEN)Editing credentials...$(COLOUR_END)"
	EDITOR=nano rails credentials:edit --environment $(ENV)

rubocop:
	@echo "$(GREEN)Running rubocop static code analyzer ...$(COLOUR_END)"
	bundle exec rubocop --display-only-fail-level-offenses --fail-fast
	@echo "$(GREEN)Rubocop ended!$(COLOUR_END)"

kamal:
	@echo "$(PALE_GREEN)Please select an environment to deploy using Kamal:$(COLOUR_END)"
	@echo "	1) $(LIGHT_GREEN)Setup environment$(COLOUR_END)"
	@echo "	2) $(LIGHT_LIME_GREEN)Generate and push environment file$(COLOUR_END)"
	@echo "	3) $(VERY_LIGHT_GREEN)Build and deploy$(COLOUR_END)"
	@echo "	4) $(BRIGHT_GREEN)Manage accessories$(COLOUR_END)"
	@echo "	5) $(LIME_GREEN)Trail application logs$(COLOUR_END)"
	@echo "	6) $(LIGHT_LIME_GREEN)Run rails console$(COLOUR_END)"
	@read -p "Enter your choice:" choice; \
	case $$choice in \
		1) \
        	echo "$(GREEN)Kamal setup in $(ENV) environment...$(COLOUR_END)"; \
        	if [ -n "$(ENV)" ]; then \
               	kamal envify --skip-push -d $(ENV); \
                kamal setup -v -d $(ENV); \
            else \
              	kamal envify; \
                kamal setup -v; \
            fi; \
        	;; \
		2) \
			echo "$(YELLOW)Access secure credentials...$(COLOUR_END)"; \
			op signin --account rzilientgroup.1password.com --raw; \
			echo $(op whoami); \
			echo "$(YELLOW)Generate .env on $(ENV)...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
				kamal lock release -d $(ENV); \
				kamal envify --skip-push -d $(ENV); \
			else \
				kamal lock release; \
				kamal envify --skip-push; \
			fi; \
			echo "$(YELLOW)Push .env...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
				kamal env push -d $(ENV); \
			else \
				kamal env push; \
			fi; \
			echo "$(YELLOW)Boot application in $(ENV) environment...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
				kamal app boot -v -d $(ENV); \
			else \
				kamal app boot -v; \
			fi; \
			;; \
		3) \
			echo "$(GREEN)Executing deploy $(ENV) environment...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
				kamal lock release -d $(ENV); \
            	kamal env push -d $(ENV); \
                kamal deploy -v -d $(ENV); \
            else \
				kamal lock release; \
              	kamal env push; \
                kamal deploy -v; \
            fi; \
			;; \
		4) \
			if [ -n "$(ACS)" ]; then \
			echo "$(GREEN)Accessory $(ACS) $(ENV) environment...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
				kamal lock release -d $(ENV); \
            	kamal accessory reboot $(ACS) -d $(ENV); \
            else \
				kamal lock release; \
              	kamal accessory reboot $(ACS); \
            fi; \
            else \
              echo "$(RED)⛔ Accessory name required...$(COLOUR_END)"; \
            fi;\
			;; \
		5) \
			echo "$(GREEN)Trail application logs on $(ENV) environment...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
                kamal app logs -d $(ENV) -f; \
            else \
                kamal app logs -f; \
            fi; \
			;; \
		6) \
			echo "$(GREEN)Run rails console on $(ENV) environment...$(COLOUR_END)"; \
			if [ -n "$(ENV)" ]; then \
                kamal app exec -i 'bin/rails console' -d $(ENV); \
            else \
                kamal app exec -i 'bin/rails console'; \
            fi; \
			;; \
		*) \
			echo "$(RED)Invalid choice!$(COLOUR_END)"; \
			;; \
	esac
