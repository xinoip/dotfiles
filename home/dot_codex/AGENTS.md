# Shared Brain for Agents

The user's shared notes are at `~/sync/brain`. Resolve relative paths below from
there, regardless of the current project.

- When prior preferences, decisions, or project history could help, follow
  `INDEX.md` to find and navigate only the relevant information. Read only what
  the task needs. If a remembered fact materially affects the work, identify its
  note path.
- Record confirmed, reusable facts and preferences, decisions with reasons, and
  project status with a next action and any blocker in this brain. Do not save
  chat transcripts or treat guesses as facts.
- Include a source for new facts and a date when they may change. Put uncertain
  items in `inbox.md` until verified.
- Update existing pages instead of duplicating them. Link new pages from
  `INDEX.md`; keep each page brief.
- If a note conflicts with the user's current statement, follow the user and
  update the note when the correction is clear.
- Keep project specific notes and instructions under `projects/` folder. Each
  project gets its own file.
- Keep session specific notes under `sessions/` folder, as subfolders. State
  goal, status, next actions, decisions, and blockers of the session. Link to
  the project repository or source documents when available.
- Memories are kept under `memories/`. Memories are the notes that can affect
  all kinds of sessions and projects. Record memories that future agents can
  benefit from.
- This is a git repository and it won't ever use Git LFS. Keep files small. Do
  not keep large archives, binaries, build trees, bulk logs, or exhaustive
  copies of temporary workspaces.
