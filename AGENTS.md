# Agent Instructions

## Overview

- This repository contains my personal dotfiles and system configurations.
- **Void Linux is the primary target.** Support for other operating systems is
  secondary.
- **Chezmoi** is required and is the authoritative tool for managing dotfiles.
- The root `Makefile` serves as the primary command runner for common
  operations. Inspect it before running commands manually.

## Guidelines

- Prefer simple, minimal, and maintainable solutions.
- Follow existing conventions and directory structures.
- Avoid introducing new dependencies unless necessary.
- Prioritize Void Linux compatibility over cross-platform portability.
- Do not modify unrelated configurations.
- Do not introduce secrets, credentials, or machine-specific sensitive
  information into version control.

## Working with Dotfiles

- Make changes in the repository rather than directly modifying deployed
  configuration files.
- Respect Chezmoi's file naming conventions, templates, and life cycle scripts.
- Review generated changes before applying them.
- **Never run destructive or system-changing commands without explicit
  permission.**
- Prefer existing Makefile targets over ad hoc commands.
