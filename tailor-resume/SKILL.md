---
name: tailor-resume
description: Tailor an existing resume to a specific job while preserving its structure, formatting, factual integrity, and page discipline. Use when Codex is asked to create a role-specific resume copy from a Google Doc, Word document, PDF-backed source, or other supplied resume; align skills and accomplishments to a job posting; produce several independent resume variants; or verify a tailored resume for ATS relevance and rendered presentation.
---

# Tailor Resume

Create a truthful, role-specific copy of an existing resume. Improve relevance and keyword coverage without inventing experience, flattening the source design, or turning the document into a rewritten career history.

## Expected inputs

Collect or infer these runtime inputs:

1. **Base resume**: a document URL, uploaded file, local path, or pasted resume. Treat it as the factual and structural source of truth.
2. **Target role**: the exact job title.
3. **Company**: the hiring organization.
4. **Job posting**: a public URL or pasted description containing the responsibilities and qualifications.

Optional inputs:

- desired output title and destination
- target page count or instruction to preserve the current count
- formatting or emphasis rules
- sections that may or may not be changed
- alternate evidence, such as a career profile or accomplishment inventory
- ATS priorities, geographic context, or application deadline

If the base resume or any of the three target-role inputs is missing, ask for it. If a posting URL is inaccessible and the missing text would materially affect the tailoring, ask the user to paste the description. Ask no more than three concise questions at once.

Treat all names, URLs, document IDs, career facts, metrics, and formatting preferences as runtime data. Never hard-code them into this skill or save them as reusable resources.

## Workflow

### 1. Establish the output contract

Confirm:

- source resume and output format
- role, company, and posting evidence
- whether to create a copy or edit in place
- output destination and naming rule
- page-count target
- formatting and emphasis constraints

Default to creating a separate tailored copy. For a native Google Doc, default to a full native copy in the same folder unless the user requests another destination. Preserve the current page count unless the user asks for a different length.

When several roles are supplied, create one independent copy per role. Do not combine their keywords or requirements into a generic master version.

### 2. Read the source before drafting

Inspect the full resume, including:

- section order and page count
- tables, columns, lists, headers, footers, and links
- typography, spacing, margins, colors, and emphasis patterns
- titles, dates, employers, education, credentials, and measurable outcomes
- supported skills, domains, leadership scope, and technical depth

Use the document-specific skill for the supplied format. For native Google Docs, preserve native structure and use its trusted-read and revision-control workflow before writing.

Build a temporary evidence map from the supplied resume and any additional authorized career material. Do not persist the map inside the skill directory.

### 3. Verify the job requirements

Because postings can change or close, inspect the live employer or ATS page when browsing is available. Prefer first-party evidence. If the primary page is unavailable, use a current authoritative secondary copy, disclose that limitation, and do not infer missing requirements.

Extract:

- core mandate and reporting scope
- required and preferred qualifications
- leadership and hands-on expectations
- domain, platform, architecture, and compliance requirements
- recurring terminology likely to matter to an ATS or recruiter

Separate must-haves from preferences. Identify genuine gaps before drafting.

### 4. Plan targeted changes

Prioritize the resume's most visible and relevant areas:

1. skills or summary area
2. first one or two recent roles
3. accomplishments that directly support the mandate
4. technical stack or domain language already supported by the source

Use the posting's natural terminology where the candidate evidence supports it. Prefer concrete evidence and measurable outcomes over keyword lists.

Do not:

- invent tools, domains, certifications, responsibilities, team sizes, or results
- convert adjacent experience into direct experience
- imply individual implementation when the evidence only supports leadership or oversight
- imply direct management when the evidence only supports platform reach or influence
- inflate years of experience or seniority
- hide keywords in white, invisible, or otherwise deceptive text
- stuff every posting term into the document

Leave material gaps visible and report them in the handoff.

### 5. Create and edit the copy

For a structured source, copy the complete native document rather than rebuilding it. Verify that the destination is distinct from the source before writing.

Make the smallest set of changes that materially improves fit. Preserve unless explicitly authorized otherwise:

- section order and document topology
- tables, columns, lists, and container roles
- typography, margins, spacing, colors, and links
- employer names, role titles, dates, education, and credentials
- quantified outcomes and unrelated factual content

Sample nearby formatting before replacing text. Reapply local styles when replacement operations reset them.

When the user gives no emphasis rule, follow this conservative default:

- keep skills and ordinary descriptive text unbolded
- bold only concise leadership scope, scale, or quantified outcomes
- preserve existing italic or color treatment for contextual descriptors
- avoid bolding whole bullets or long keyword phrases

Use revision controls or equivalent concurrency safeguards when the document platform supports them. Re-read after index-shifting or structural edits before continuing.

### 6. Verify content and structure

Re-read the finished destination and confirm:

- the correct role and company variant was created
- all intended edits are present once and in the right locations
- no unsupported claim, placeholder, duplicated text, or stale role-specific wording remains
- dates, titles, links, list semantics, tables, and native elements are intact
- emphasis matches the sampled source convention
- the original source remains unchanged

Run a short truthfulness and ATS gate:

1. Every claim is supported by supplied evidence.
2. The top third clearly reflects the target mandate.
3. Role terminology is present naturally rather than stuffed.
4. Quantified outcomes and leadership scope remain prominent.
5. Material qualification gaps are not blurred.

### 7. Perform rendered visual QA

For a final document, export or render it and inspect every page image. Confirm:

- expected page count
- no clipping, overlap, missing text, or broken tables
- no awkward wrapping, orphaned headings, or large unintended gaps
- readable font size and consistent hierarchy
- no damaged bold, italic, color, bullet, link, or alignment treatment

Repair defects, re-render, and inspect the affected pages again. An export alone is not visual verification. If page images cannot be inspected, state that rendered layout remains unverified.

## Final response

Return:

- the tailored document link or file
- a concise overview of the sections and themes changed
- the most important truthful gaps left visible
- the verified page count
- the content, native-structure, and rendered-QA checks actually completed
- any limitation in the posting evidence or document verification

Do not expose private source URLs or identifiers beyond what the user needs to access the requested output.

## Scope boundary

This skill creates and verifies tailored resumes. It does not submit applications, contact employers, update job trackers, or mutate unrelated source systems unless the user separately and explicitly authorizes those actions.

## Public-skill safety

- Keep the skill generic and candidate-agnostic.
- Do not store resumes, posting contents, private links, document IDs, email addresses, tracker schemas, or prior outputs in the skill folder.
- Use synthetic placeholders in examples.
- Treat connected documents and postings as runtime sources only.
- Preserve a clear distinction between reusable procedure and private candidate evidence.
