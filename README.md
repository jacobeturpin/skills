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

### [Generate Job Pipeline](generate-job-pipeline/SKILL.md)

Builds a small, evidence-backed set of current job openings that match a supplied candidate profile and search contract.

Capabilities:

- Searches indexed ATS results, supplied job or portfolio boards, and company career sites on configurable cadences
- Verifies shortlisted roles against first-party employer or ATS postings, including availability, location, compensation, requirements, and direct application links
- Applies hard constraints, distinguishes preferences from screening risks, and avoids padding results with weak matches
- Deduplicates against an existing tracker or prior results using stable job IDs, canonical URLs, or normalized role details
- Ranks viable leads as High, Medium, or Reach with evidence-backed fit and risk explanations
- Can write verified results and source-run state to a destination when explicitly authorized, with schema inspection and exact readback

### [Morning Brief](morning-brief/SKILL.md)

Synthesizes connected work tools into a concise, prioritized view of the user's day.

Capabilities:

- Discovers and reads available calendar, chat, project-management, and email integrations, or limits the scan to sources requested by the user
- Reviews today's schedule, recent messages, assigned work, deadlines, blockers, unread requests, and tomorrow's relevant context
- Detects meeting conflicts, preparation windows, overdue work, newly assigned tasks, and conversations awaiting a response
- Cross-references related information across tools instead of producing separate source-by-source summaries
- Produces prioritized key information, actionable TODOs, and concrete offers for follow-up work
- Degrades gracefully when only some integrations are available and clearly identifies missing coverage

### [Rank Job Pipeline](rank-job-pipeline/SKILL.md)

Turns active job leads into a highest-first application queue based on expected application return.

Capabilities:

- Reads spreadsheets, databases, ATS exports, CSV files, workbooks, pasted tables, or role lists without modifying them by default
- Filters on an exact pipeline status, deduplicates openings, and separates referral or networking paths when requested
- Evaluates candidate evidence, must-have qualifications, leadership scope, compensation, location, freshness, referral leverage, and tailoring effort
- Verifies current postings against employer or ATS sources when live access is available and labels provisional evidence when it is not
- Applies hard screening gates before using a weighted ranking rubric and evidence-based tie breakers
- Recommends application tiers, time-boxed execution batches, and stopping rules; writes rankings back only when explicitly authorized

### [Tailor Resume](tailor-resume/SKILL.md)

Creates a truthful, role-specific resume copy while preserving the source document's structure, formatting, and page discipline.

Capabilities:

- Works from supplied Google Docs, Word documents, PDF-backed sources, local files, or pasted resumes
- Analyzes the target posting, separates must-haves from preferences, and identifies genuine qualification gaps
- Aligns summaries, skills, recent experience, accomplishments, and supported terminology without inventing or inflating claims
- Creates independent variants for multiple roles and defaults to preserving native document structure, formatting, links, and page count
- Verifies content, factual support, ATS relevance, document structure, and preservation of the original source
- Renders and visually inspects final pages when supported, repairing clipping, wrapping, spacing, or formatting defects before delivery
