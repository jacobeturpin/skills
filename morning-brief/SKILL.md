---
name: morning-brief
description: >
  Synthesize a daily briefing from the user's connected tools — chat (Slack, Teams),
  project management (Linear, GitHub Issues, Jira, Asana), and calendar (Google Calendar,
  Outlook). Use this skill whenever the user asks for a morning brief, daily summary,
  daily standup prep, "what's on my plate today", "catch me up", "what did I miss",
  "what do I need to know today", or any request to summarize their day's priorities
  across work tools. Also trigger when the user says "brief me", "daily digest",
  "morning update", "start my day", or asks what meetings, messages, or tasks they
  should focus on today. Even casual phrasing like "what's going on today" or
  "anything important I should know" should trigger this skill.
---

# Morning Brief

Generate a concise, actionable daily briefing by pulling data from the user's connected
integrations and synthesizing it into a single prioritized view of their day.

## Step 1: Determine which sources to scan

The user may specify which tools to check (e.g., "just Slack and Calendar") or leave it
open. Handle both cases:

**If the user specifies sources**, map their request to tool categories and skip discovery
for categories they didn't mention.

**If the user doesn't specify**, auto-discover by running `tool_search` for each category
below. Try all of them — the user benefits most when you cast a wide net:

| Category            | tool_search queries to try                                          |
|---------------------|---------------------------------------------------------------------|
| Chat                | `"slack messages"`, `"teams messages"`, `"chat messages"`           |
| Project Management  | `"linear issues"`, `"github issues"`, `"jira issues"`, `"asana tasks"` |
| Calendar            | `"calendar events"`, `"google calendar"`, `"outlook calendar"`      |
| Email               | `"gmail"`, `"email messages"`, `"outlook email"`                    |

Also check `search_mcp_registry` if `tool_search` comes back empty for a category — there
may be a connector the user hasn't enabled yet that would be useful. If you find one,
mention it briefly at the end of the brief (e.g., "I noticed you could connect Linear to
get task data in future briefs — want me to set that up?"). Don't derail the brief to
suggest connectors; keep it as a footnote.

**Important**: Run the `tool_search` calls efficiently. You can batch several in quick
succession. Don't ask the user "should I check Slack?" — just check what's available and
use it. The goal is zero-friction: the user says "morning brief" and gets results.

## Step 2: Gather data from each available source

For each source you found tools for, pull the relevant data. Focus on **today and the
immediate context window** (last 24 hours for messages, today + tomorrow for calendar,
active/due-soon for tasks).

### Calendar

Calendar is the backbone of the brief — it defines the shape of the day.

- Fetch today's events (and tomorrow's if the user asks for a broader view)
- Note start times, durations, attendees, and any attached agendas or documents
- Flag conflicts (overlapping events) and unusually long blocks
- Identify prep windows — gaps before important meetings where the user could prepare

### Chat (Slack, Teams, etc.)

Focus on signal, not noise. The user doesn't need a rehash of every channel.

- Look for direct messages and mentions from the last 24 hours
- Prioritize: DMs > @-mentions > channels the user is active in
- Identify threads that need a response (someone asked a question, tagged the user)
- Look for decisions made, announcements, or asks that landed while the user was away
- Summarize by theme, not by channel — group related items together

### Project Management (Linear, GitHub, Jira, Asana, etc.)

Focus on what's actionable today.

- Pull issues/tasks assigned to the user
- Prioritize by: overdue > due today > due this week > in-progress with no due date
- Note blockers — tasks where someone is waiting on the user
- Check for recently assigned items the user may not have seen yet
- If available, check sprint/cycle status for context on velocity
- **Always include the issue title alongside the ID.** A bare ID like `ABC-123` is
  meaningless without context. Format every issue/task reference as a markdown link with
  both the ID and title: `[ABC-123: Fix login timeout](https://...)`. If the tool provides
  a URL, use it; if not, still include the title inline: `ABC-123: Fix login timeout`.

### Email (Gmail, Outlook, etc.)

If email tools are available, treat them as a supplement to chat.

- Check for unread/recent messages that look time-sensitive
- Flag anything that requires a response or has a deadline
- Skip newsletters, notifications, and automated emails — focus on human-sent messages

## Step 3: Synthesize into the briefing

After gathering data, synthesize everything into the output format below. The goal is to
transform raw data from multiple tools into a **coherent narrative about the user's day**.
This means:

- **Cross-reference sources.** If there's a meeting about "Q3 planning" on the calendar
  AND a Slack thread about Q3 priorities, connect them. If a task is due today AND someone
  pinged about it in chat, surface that context together.
- **Prioritize ruthlessly.** Not everything is worth mentioning. A "Key Thing to Know" should
  be something that would change how the user approaches their day. A routine standup
  doesn't need to be called out unless there's something unusual about it.
- **Be specific about time.** "You have a 1:1 with Sarah at 2pm" is better than "you have
  meetings today." Include the actual times and deadlines.
- **Surface the implicit.** If the user has 6 hours of meetings and a task due EOD, that's
  worth flagging — they'll need to find time somewhere. If two meetings overlap, say so.

### Formatting issue and task references

Across the entire brief — not just the project management section — every issue or task
reference must include the title and link, not just the ID. Users don't have IDs memorized.

- **With URL available**: `[ABC-123: Fix login timeout](https://linear.app/team/ABC-123)`
- **Without URL**: `ABC-123: Fix login timeout`

Never output a bare ID like `ABC-123` anywhere in the brief.

### Output Format

Structure the brief exactly like this:

---

**Key Things to Know:**

- [Important item — lead with the most impactful. These are things that would change how
  the user plans their day: a deadline, a decision that was made overnight, a conflict, a
  meeting with unusual stakes, etc.]
- [Each bullet should be self-contained and actionable. Include enough context that the
  user doesn't need to go look it up.]
- [3–7 items is the sweet spot. Fewer means nothing noteworthy; more means you're not
  filtering enough.]

**Recommended TODOs for Today:**

- [Concrete action — include context like deadlines, who's waiting, and why it matters
  today specifically. e.g., "Respond to Alex's PR review on auth-service (requested
  yesterday, blocking their sprint work)"]
- [Order by a blend of urgency and impact, not by source]
- [If a task has a hard deadline, say so: "(due by EOD)", "(meeting at 2pm — prep before
  then)"]
- [5–10 items. If there are more, group lower-priority ones or mention them as a batch.]

**Recommended Next Steps:**

- Offer to take action: "Want me to draft a response to [person]'s Slack message about
  [topic]?"
- Offer to go deeper: "I can pull up the details on [task/issue] if you want to review
  before your 2pm meeting."
- Offer to start threads: "I can open a new thread to help you [prepare talking points /
  draft that document / review that PR] — want me to?"
- Keep this to 2–4 concrete offers, directly tied to the items above.

---

## Handling partial data

Not every source will be available. That's fine — deliver the best brief you can with
what you have.

- If only calendar is available, lead with the day's schedule and derive TODOs from meeting
  prep needs.
- If only project management is available, focus on task prioritization.
- If nothing is available, tell the user clearly what you tried and couldn't access, and
  suggest connecting the relevant tools. Don't fabricate a brief from nothing.

At the end of the brief, if any major category was missing (e.g., no chat tool connected),
add a brief note: "Note: I didn't have access to Slack/Teams, so chat activity isn't
reflected above. You can connect it under your integrations for future briefs."

## Tone and style

- Be direct and efficient. This is a working document, not a newsletter.
- Use the user's name if you know it.
- Don't editorialize or add motivational fluff ("You've got a busy day ahead! 💪"). Just
  present the information clearly.
- If there's genuinely nothing urgent, say so — "Light day today" is a valid brief.
- No emoji unless the user's style preferences call for them.

## Interaction model

After presenting the brief, wait for the user to respond. They might:
- Ask you to drill into a specific item
- Ask you to take one of the suggested next steps
- Ask you to adjust the brief (more/less detail, different sources)
- Just say thanks and move on

All of these are fine. The brief is a starting point for the user's day, not a final
deliverable.