.PHONY: all

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort| while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: fmt
fmt: # Formats the code in the src/ and test/ directories using black.
	poetry run isort .
	poetry run black .

.PHONY: typecheck
typecheck: # Performs type checking in the src/ and test/ directories using mypy.
	poetry run mypy .
