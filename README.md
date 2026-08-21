# Skills

A collection of personal agent skills for use with Codex, Claude Code, OpenCode, and other tools that support the Agent Skills format.

## Link Skills

Run the included script to make every skill in this repository available to supported tools on your machine:

```bash
./link-skills.sh
```

By default, the script creates symlinks in:

- `~/.agents/skills` for Codex, OpenCode, and other Agent Skills-compatible tools
- `~/.claude/skills` for Claude Code

The repository remains the source of truth, so changes made here are immediately available through the symlinks. Running the script repeatedly is safe: links that already point to the correct skill are left unchanged. Existing files, directories, or symlinks that point elsewhere are reported as conflicts and are never overwritten.

Only immediate child directories containing a `SKILL.md` file are linked. Repository metadata and unrelated files such as `.git`, `.gitignore`, `README.md`, and `LICENSE` are ignored.

Preview changes without creating links:

```bash
./link-skills.sh --dry-run
```

Use one or more custom destinations instead of the defaults:

```bash
./link-skills.sh --target ~/.config/opencode/skills
./link-skills.sh --target /path/to/tool-one/skills --target /path/to/tool-two/skills
```

View all available options:

```bash
./link-skills.sh --help
```

## Included Skills

| Skill | Description |
|-------|-------------|
| [morning-brief](morning-brief/morning-brief.md) | Synthesizes a daily briefing from connected tools (Slack, Linear, Google Calendar, etc.) into a prioritized view of meetings, tasks, and messages. |
