---
name: rank-job-pipeline
description: Rank active job-search pipeline roles into a highest-first application queue using candidate evidence, job requirements, compensation, location, freshness, screening risk, referral paths, and application effort. Use when asked to prioritize jobs or leads from a spreadsheet, database, ATS export, CSV, pasted table, or list; refresh roles in a particular pipeline status such as Found, Sourced, or To Apply; decide which applications to complete first; or re-rank a pipeline after statuses or preferences change.
---

# Rank Job Pipeline

Produce an evidence-backed application order that maximizes expected return rather than merely repeating an existing match score.

## Expected inputs

Collect or infer these inputs before ranking:

1. **Pipeline source**: a connected spreadsheet/database, uploaded CSV or workbook, or pasted role list.
2. **Target state**: the exact status to include, such as `Found` or `To Apply`.
3. **Candidate evidence**: a résumé, career profile, or concise summary of supported skills, leadership scope, domains, and accomplishments.
4. **Preferences and constraints**: desired seniority, location/work model, compensation expectations, sponsorship needs, travel limits, target industries, and application horizon.
5. **Exceptions**: roles to exclude, defer, treat as referrals, or preserve in a separate path.

Optional inputs include an existing match rating, available application time, preferred application volume, and whether current job postings should be verified online.

If the pipeline source or target state is missing, ask for it. If candidate evidence is missing, explain that the ranking can only be pipeline-based and ask for a résumé or profile when fit-based prioritization is expected. Ask at most the few questions that would materially change the order; otherwise state reasonable assumptions and proceed.

Never hard-code a person's name, private source URL, document ID, résumé link, compensation target, or other user-specific detail into this skill. Treat all such values as runtime inputs.

## Workflow

### 1. Read the pipeline safely

- Treat the source as read-only unless the user explicitly requests edits.
- Resolve the exact table, sheet, or view and inspect its headers before reading records.
- Use bounded reads appropriate to the actual table size.
- Filter on the exact status-cell value. Do not use a substring search that can match headers such as `Date Found` or unrelated notes.
- Exclude every non-target status, including Applied, Interview, Closed, Rejected, Withdrawn, and Duplicate, unless the user explicitly requests otherwise.
- Preserve referral or networking opportunities as a separate path when instructed; do not silently mix them into the direct-application queue.
- Deduplicate by canonical posting URL or stable job identifier. Preserve useful source provenance without ranking the same opening twice.
- Report the count of included roles and all material exclusions.

### 2. Establish the candidate baseline

Extract only claims supported by the supplied résumé or profile:

- leadership scope and organizational level
- technical and functional strengths
- industries and regulated-domain experience
- product, platform, data, AI/ML, security, infrastructure, or services experience
- hands-on recency and depth
- measurable outcomes
- explicit location, compensation, and work-model constraints

Do not inflate years of experience, title level, domain expertise, technical depth, or team size. Distinguish adjacent experience from direct experience.

### 3. Validate current role evidence

Job postings, compensation, locations, and availability are time-sensitive.

- When live verification is allowed and available, open the primary employer or ATS posting.
- Prefer the employer's careers site or direct ATS page over aggregators and search snippets.
- Confirm that the posting is still available and capture must-haves, preferred qualifications, compensation, location, work model, and application questions.
- Use secondary sources only when the primary page is inaccessible, and label the evidence accordingly.
- If a listing cannot be viewed, rank provisionally from supplied data and state what remains unverified. Ask for the listing text when its missing details could materially change the order.
- Never infer undisclosed compensation or silently substitute a similarly titled role.

### 4. Apply hard gates before scoring

Identify requirements likely to cause immediate screening failure, including:

- a materially different function, such as product management instead of engineering leadership
- mandatory location, onsite, travel, sponsorship, citizenship, or clearance constraints
- required domain expertise with no supported analogue
- required hands-on depth in a specific language, platform, architecture, or discipline
- minimum years, prior title, organization scale, or manager-of-managers experience
- compensation that cannot plausibly meet the stated floor

Treat preferred qualifications as risks, not automatic disqualifiers. A prestigious company or high salary must not override a clear must-have gap.

### 5. Rank by expected application return

Use the following default rubric, adapting weights when the user supplies different priorities:

| Dimension | Default weight | Considerations |
| --- | ---: | --- |
| Evidence-backed role fit | 30% | Direct overlap with supported experience and accomplishments |
| Must-have coverage | 20% | Likelihood of passing recruiter and hiring-manager screens |
| Scope and seniority | 15% | Team size, mandate, reporting line, and career alignment |
| Compensation and location | 15% | Stated range, remote/onsite model, geography, travel |
| Posting quality and freshness | 10% | Current availability, direct ATS evidence, posting age |
| Application leverage | 10% | Referral path, competition, tailoring cost, reusable materials |

Use the rubric as a decision aid, not false precision. Override a numerical score when a hard gate makes the application unrealistic. Break close ties in this order:

1. stronger must-have coverage
2. higher interview probability
3. better compensation and work-model alignment
4. fresher posting
5. lower tailoring cost

Do not rank solely from the tracker's existing match label.

### 6. Allocate application effort

Recommend effort proportional to expected return:

- **Priority tier**: substantial résumé tailoring and targeted application answers
- **Strong secondary tier**: focused keyword and summary adjustments
- **Efficient/reach tier**: reuse the closest résumé version and avoid excessive customization

When the user provides a deadline or time budget, convert the ranking into a feasible queue. Include a stopping rule when the lower-ranked applications have sharply diminishing returns. Do not recommend broad low-quality applying merely to fill a quota.

## Output format

Lead with the exact number of roles in the target state and note excluded or separately routed roles.

Provide a numbered, highest-first list. For every role include:

- role and company, linked to the canonical posting when available
- location/work model
- compensation or `not disclosed`
- concise fit rationale
- most important qualification risk
- recommended effort or tier

After the list, provide a short execution recommendation such as day-by-day batches, priority tiers, or a stopping rule. State whether the source was changed; the default should be `unchanged`.

Keep the explanation decisive. Avoid large scoring tables unless the user asks for numeric scoring or a comparison matrix.

## Write-back rules

Ranking alone does not authorize pipeline edits.

If the user explicitly asks for updates:

1. identify exact target rows and validation constraints
2. preserve existing values not requested for change
3. make the smallest structured update
4. reread the exact written range
5. report what changed

Never submit applications, contact employers, or change external statuses without explicit authorization.
