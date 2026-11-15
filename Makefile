# This is just a central place to run commands

all: apply

.PHONY: apply
apply:
	chezmoi apply

.PHONY: apply-root
apply-root:
	 sudo chezmoi -S system -D / apply

.PHONY: sync-nvim-pack-lock
sync-nvim-pack-lock:
	cp ~/.config/nvim/nvim-pack-lock.json ./home/dot_config/nvim/
