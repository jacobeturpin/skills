---
name: generate-job-pipeline
description: Find, verify, deduplicate, rank, and optionally write back high-quality job leads from public job boards, portfolio talent networks, employer career sites, and ATS platforms. Use when asked to generate a job-search pipeline, run a recurring lead search, source roles from a specific board or URL, refresh a tracker with newly discovered openings, find roles matching a candidate profile and constraints, or reproduce a prior job-discovery workflow without resurfacing existing leads.
---

# Generate Job Pipeline

Build a small, evidence-backed set of current openings that a candidate could realistically pursue. Favor verified fit over list length.

## Expected inputs

Collect or infer the following runtime inputs:

1. **Candidate evidence**: a resume, career profile, or concise summary of supported skills, leadership scope, domains, and accomplishments.
2. **Target roles and domains**: desired titles, seniority, functions, industries, and technical themes.
3. **Hard constraints**: required geography, work model, compensation floor, sponsorship or work-authorization needs, travel limits, and mandatory exclusions.
4. **Discovery sources**: one or more public job-board URLs, employer lists, portfolio networks, ATS domains, or search targets.
5. **Deduplication source**: an existing tracker, prior-results file, database, or pasted list of companies, titles, stable job IDs, and posting URLs.
6. **Output contract**: maximum lead count, required fields, ranking labels, and whether results should be written to a destination.

Optional inputs include a freshness window, preferred company stages, excluded employers, allowed adjacent roles, acceptable qualification risks, and a destination table schema.

If candidate evidence, a material hard constraint, or the intended discovery source is missing, ask for it. If write-back is requested but the destination or schema is missing, ask for those details before editing. Ask no more than three concise questions at once, and proceed with explicit assumptions when the missing detail would not materially change the result.

Never hard-code or retain a person's name, private document URL, source ID, resume link, compensation target, location, or tracker schema. Treat all such values as runtime inputs.

## Workflow

### 1. Establish the search contract

Summarize the following before searching:

- target titles and acceptable adjacent titles
- technical or industry themes
- geography and work-model requirements
- compensation rule
- maximum results
- deduplication rule
- requested destination and whether edits are authorized

Distinguish hard gates from preferences. A preference influences ranking; a hard gate excludes a role.

### 2. Read candidate and deduplication evidence

Extract only claims supported by the supplied candidate evidence:

- leadership and organizational scope
- manager-of-managers experience
- hands-on technical depth and recency
- platform, product, data, AI/ML, security, infrastructure, or services experience
- industry and regulated-domain experience
- measurable outcomes

Do not inflate years, titles, team size, domain expertise, or hands-on depth. Treat adjacent experience as adjacent, not direct.

Read the deduplication source before discovery when available. Build canonical keys from, in priority order:

1. stable employer or ATS job ID
2. normalized direct posting URL
3. normalized company plus title plus location

Support both exact-posting deduplication and company-level deduplication. Use the user's stated rule. If none is supplied, deduplicate exact postings and flag multiple openings at one company rather than silently dropping them.

### 3. Discover candidates efficiently

Use live internet or browser access because job availability is time-sensitive.

- Start with the user-supplied board or portfolio network.
- Use its visible search, filters, sorting, or category pages when available.
- Search several narrow title/domain combinations instead of one broad query.
- For ATS discovery, use focused domain filters for relevant public systems such as Greenhouse, Lever, Ashby, Workday, and Rippling.
- Prefer newly posted, remote-compatible, and compensation-visible results when those match the search contract.
- Record the discovery URL separately from the canonical employer application URL.

Do not treat a portfolio board, aggregator, search snippet, or social post as final evidence.

### 4. Verify every shortlisted opening

Open the primary employer careers page or direct ATS posting for each candidate. Confirm:

- the posting is still accessible and accepts applications
- exact company and title
- stable posting ID when available
- employment type
- location and remote scope
- compensation range or `not disclosed`
- reporting line and organizational scope when stated
- required and preferred qualifications
- direct application URL

Remote does not automatically mean every country or state. When the candidate must be eligible from a particular place, require posting evidence that permits that place. Exclude ambiguous listings when location is a hard gate unless authoritative employer evidence resolves the ambiguity.

Prefer current first-party evidence. Use secondary evidence only when the employer page is inaccessible, label the limitation, and do not invent missing requirements or compensation.

### 5. Apply hard gates

Exclude openings that fail any stated hard constraint, including:

- incompatible country, state, onsite, travel, citizenship, clearance, or sponsorship requirements
- compensation whose disclosed range cannot meet the required floor
- a materially different function
- mandatory expertise unsupported by the candidate profile
- materially excessive scope or experience requirements
- closed, stale, duplicated, or unverifiable postings

Treat preferred qualifications as risks rather than automatic exclusions. Keep an otherwise exceptional role with one material gap only when the overall fit is unusually compelling, and label it as a reach.

For undisclosed compensation, never invent a range. Include the role only if it remains plausibly aligned with the requested level and explicitly state compensation uncertainty as a risk.

### 6. Evaluate and rank

Compare each surviving role against candidate evidence across:

- direct technical and domain overlap
- leadership scope and seniority
- required qualification coverage
- compensation and location confidence
- product and company-stage relevance
- hands-on expectations
- posting freshness and evidence quality

Use simple labels unless the user requests numeric scoring:

- **High**: strong direct fit with no material screening risk
- **Medium**: credible fit with one or two manageable risks
- **Reach**: unusually compelling but contains a material seniority, domain, compensation, location, or qualification risk

Rank strongest first. Do not pad the output to reach the maximum.

### 7. Present the results

For every lead include:

- company
- exact title
- location and remote status
- posted base range or `not disclosed`
- direct employer application link
- concise evidence-backed fit rationale
- most important qualification risk
- priority rating

Also report material exclusion categories and any provisional evidence. Avoid large comparison tables unless the user requests one.

### 8. Write back only when authorized

Discovery and ranking do not automatically authorize tracker edits.

When the user explicitly requests write-back:

1. inspect the live destination schema and validation rules
2. re-run deduplication against the live destination immediately before writing
3. map only supported fields
4. preserve unrelated values, formulas, links, validation, and formatting
5. use stable posting IDs and direct application URLs
6. write the smallest coherent batch
7. reread the exact written rows and verify values, links, dates, and formats

Do not redesign a destination schema without approval. Leave unavailable compensation blank or use the destination's established representation for `not disclosed`. Do not submit applications, contact employers, or change application statuses unless explicitly authorized.

## Verification boundaries

State what was actually verified:

- discovery-board presence
- live employer or ATS availability
- location eligibility
- posted compensation
- destination write-back and exact readback

Do not claim rendered visual verification from a data-only connector read. If the native destination cannot be visually inspected, report structured readback as the verification performed.

## Privacy and public-skill safety

- Keep this skill generic and reusable.
- Do not place runtime candidate data, private URLs, document IDs, email addresses, employer conversations, or tracker contents in the skill directory.
- Do not persist search history or prior leads inside the skill unless the user explicitly supplies a public, intended data artifact.
- Redact sensitive query parameters when reporting examples.
- Use synthetic placeholders in examples and documentation.
