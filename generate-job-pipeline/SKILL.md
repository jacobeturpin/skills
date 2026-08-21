---
name: generate-job-pipeline
description: Find, verify, deduplicate, rank, and optionally write back high-quality job leads from indexed ATS searches, supplied job or portfolio boards, and company career sites checked on configurable cadences. Use when asked to generate or schedule a job-search pipeline, crawl specified sources, refresh a tracker with newly discovered openings, or find current roles matching a candidate profile without resurfacing existing leads.
---

# Generate Job Pipeline

Build a small, evidence-backed set of current openings that a candidate could realistically pursue. Favor verified fit over list length.

## Expected inputs

Collect or infer the following runtime inputs:

1. **Candidate evidence**: a resume, career profile, or concise summary of supported skills, leadership scope, domains, and accomplishments.
2. **Target roles and domains**: desired titles, seniority, functions, industries, and technical themes.
3. **Hard constraints**: required geography, work model, compensation floor, sponsorship or work-authorization needs, travel limits, and mandatory exclusions.
4. **Discovery sources**: one or more indexed-ATS search targets, public job-board URLs, portfolio networks, or company career sites. A source can include a stable source name, URL or search pattern, source type, and cadence such as daily, weekly, or monthly.
5. **Deduplication source**: an existing tracker, prior-results file, database, or pasted list of companies, titles, stable job IDs, and posting URLs.
6. **Output contract**: maximum lead count, required fields, ranking labels, and whether results should be written to a destination.

Optional inputs include a freshness window, preferred company stages, excluded employers, allowed adjacent roles, acceptable qualification risks, a destination table schema, and persistent run state containing source-level last-attempted and last-successfully-checked timestamps.

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
- source types, cadences, and which sources are due this run
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

### 3. Build the source plan

Normalize the supplied discovery inputs into a runtime source manifest. Each source should have:

- a stable source key and human-readable name
- one of these types: `indexed-ats-search`, `job-board`, or `company-careers`
- a URL, domain, company career page, or search pattern
- a cadence such as `daily`, `weekly`, or `monthly`
- last attempted, last successfully checked, and next-due timestamps when persistent run state is available

Use the user's cadence when supplied. If a company-specific source has no cadence, default to weekly rather than inventing a priority tier. On a bootstrap run, or when explicitly asked to ignore cadence, check every in-scope source. Otherwise, check only sources that are due. Base the next due date on the last successful check, not merely an attempted visit. Record an inaccessible or incomplete source as attempted but not successfully checked.

Keep the source manifest and run state outside the skill directory. They may live in a tracker, task memory, database, or user-supplied file.

### 4. Discover candidates by source type

Use live internet or browser access because job availability is time-sensitive.

- **Indexed ATS searches**: use several narrow search-engine queries that combine relevant titles or themes with ATS domains. Rotate combinations when useful rather than relying on one broad Boolean query. Search results and snippets are discovery evidence only.
- **Supplied job boards**: start with the user's provided URLs. Use visible filters, sorting, taxonomies, and new-since-last-run views when available. Portfolio and venture-capital boards can improve company coverage, but their classifications may be noisy and their listings may overlap ATS results.
- **Company career sites**: visit each due company's official careers page or linked job board. Search the whole board for relevant openings instead of assuming the supplied landing page is a complete listing. Use daily, weekly, or monthly cadence from the source manifest to distribute checks across recurring runs.

Across all source types, prefer newly posted, location-compatible, and compensation-visible results when those match the contract. Record the discovery source and URL separately from the canonical employer application URL. Do not let one high-volume board crowd out the other due source types; complete reasonable coverage of each due source group before expanding a single source.

Do not treat a portfolio board, aggregator, search snippet, or social post as final evidence.

### 5. Verify every shortlisted opening

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

### 6. Apply hard gates

Exclude openings that fail any stated hard constraint, including:

- incompatible country, state, onsite, travel, citizenship, clearance, or sponsorship requirements
- compensation whose disclosed range cannot meet the required floor
- a materially different function
- mandatory expertise unsupported by the candidate profile
- materially excessive scope or experience requirements
- closed, stale, duplicated, or unverifiable postings

Treat preferred qualifications as risks rather than automatic exclusions. Keep an otherwise exceptional role with one material gap only when the overall fit is unusually compelling, and label it as a reach.

For undisclosed compensation, never invent a range. Include the role only if it remains plausibly aligned with the requested level and explicitly state compensation uncertainty as a risk.

### 7. Evaluate and rank

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

### 8. Present the results

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

For recurring runs, also provide a concise coverage summary:

- which source groups were checked
- which scheduled sources were due, successful, incomplete, or inaccessible
- whether zero viable leads is the genuine result after applying the filters

Do not lower the quality threshold to produce a non-empty result.

### 9. Persist results and write back only when authorized

Discovery and ranking do not automatically authorize tracker edits.

When the user explicitly requests write-back:

1. inspect the live destination schema and validation rules
2. re-run deduplication against the live destination immediately before writing
3. map only supported fields
4. preserve unrelated values, formulas, links, validation, and formatting
5. use stable posting IDs and direct application URLs
6. write the smallest coherent batch
7. reread the exact written rows and verify values, links, dates, and formats

When persistent run state is available and updating it is authorized, record source-level last-attempted, last-successfully-checked, next-due, and outcome values. Advance `last successfully checked` only after reasonable coverage of that source completes. Keep lead deduplication keys canonical across every discovery mode so the same posting found through search, a portfolio board, and an employer site is presented only once.

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
