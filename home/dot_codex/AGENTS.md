# Shared Brain for Agents

The user's shared notes are at `~/sync/brain`. Resolve relative paths below from
there, regardless of the current project.

- This is only for information that can be shared between different projects.
- When prior preferences, decisions, or project history could help, follow
  `INDEX.md` to find and navigate only the relevant information. Read only what
  the task needs. If a remembered fact materially affects the work, identify its
  note path.
- Record confirmed, reusable facts and preferences, decisions with reasons. Do
  not save chat transcripts or treat guesses as facts. Don't record project
  specific information.
- Include a source for new facts and a date when they may change. Put uncertain
  items in `inbox.md` until verified.
- Update existing pages instead of duplicating them. Link new pages from
  `INDEX.md`; keep each page brief.
- If a note conflicts with the user's current statement, follow the user and
  update the note when the correction is clear.
- Keep project specific notes and instructions out of the shared brain. Keep
  them under respective project folders.
- Memories are kept under `memories/`. Memories are the notes that can affect
  all kinds of sessions and projects. Record memories that future agents can
  benefit from.
- This is a git repository and it won't ever use Git LFS. Keep files small. Do
  not keep large archives, binaries, build trees, bulk logs, or exhaustive
  copies of temporary workspaces.

## Project Specific Brain

Project specific notes should always be kept under the working directory of
Codex CLI. Follow conventions for projects if they exist. If there are no
conventions defined, use following guidelines:

- Create a folder `docs/agents`. Keep project specific notes here.
- Never commit or git ignore this folder.
- Keep project specific memories, decisions, facts, and notes here.
- Aim to make project context independent so that other developers can use these
  notes to work on the project with their AI agents, without any previous chat
  history or context.
