#!/bin/zsh

wd() {
  local file="$HOME/.cache/.pio_warp_dirs"

  # Ensure the directory and file exist
  mkdir -p "${file:h}"
  [[ -f "$file" ]] || touch "$file"

  local action="$1"
  local arg="$2"

  case "$action" in
  add)
    local name="${arg:-${PWD:t}}"
    # Check if the name already exists at the start of a line
    if grep -q "^${name} " "$file" 2>/dev/null; then
      echo "wd: warning: name '${name}' already exists. Use 'wd rm ${name}' first." >&2
      return 1
    fi
    # Append the new name and current path
    echo "$name $PWD" >>"$file"
    ;;
  rm)
    if [[ -n "$arg" ]]; then
      grep -v "^${arg} " "$file" >"${file}.tmp" 2>/dev/null
      mv "${file}.tmp" "$file"
    fi
    ;;
  list)
    # Display the contents; column -t aligns the output if available
    if command -v column >/dev/null; then
      column -t "$file"
    else
      cat "$file"
    fi
    ;;
  *)
    if [[ -n "$action" ]]; then
      # Look up the path by matching the beginning of the line
      local target_dir
      target_dir=$(grep "^${action} " "$file" | cut -d' ' -f2-)

      if [[ -n "$target_dir" && -d "$target_dir" ]]; then
        cd "$target_dir" || return 1
      else
        echo "wd: no valid directory found for '$action'" >&2
        return 1
      fi
    else
      echo "Usage: wd [add [name] | rm <name> | list | <name>]" >&2
      return 1
    fi
    ;;
  esac
}
