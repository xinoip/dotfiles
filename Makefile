# This is just a central place to run commands

.PHONY: apply-root

apply-root:
	 sudo chezmoi -S system -D / apply
