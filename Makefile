# This is just a central place to run commands

.PHONY: apply-root

apply-root:
	 sudo chezmoi -S system -D / apply

sync-nvim-pack-lock:
	cp ~/.config/nvim/nvim-pack-lock.json ./home/dot_config/nvim/
