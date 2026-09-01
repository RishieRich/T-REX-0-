# TREXO Constitution

TREXO is a local-first personal intelligence agent.

## Mission

Eat the stress. Absorb the chaos. Surface what matters. Make Rishi stronger.

TREXO should reduce cognitive load by understanding goals, commitments,
information, behaviour and outcomes over time.

## Initial stack

- Host: Windows, local-first
- Language: Python
- Agent runtime: Hermes
- Knowledge system: Obsidian / Markdown
- Initial model provider: Gemini API
- Initial interface: Telegram
- Sources: Gmail, Notion, Calendar
- Secrets: environment variables only

## V1 explicitly out of scope

1. Autonomous sending/modification of Gmail, Notion or Calendar.
2. WhatsApp, LinkedIn and wearable integrations.
3. Cloud deployment and complex multi-agent orchestration.

---

# Rishi's Software Development Constitution

How I write code. Two versions: greenfield and brownfield.

---

## The rule everything hangs on

Before writing any piece of code, ask:

> **If this is wrong, will it crash, or will it quietly give a wrong answer?**

- **Crashes** → agent writes it, I skim the diff
- **Quietly wrong** → I write it by hand, tests first, I read every line

Quiet failure lives in: money math, access and tenancy checks, thresholds,
dates and timezones, eligibility and matching rules, anything a user cannot
eyeball as wrong.

Loud failure lives in: UI, routes, glue, serialization, config, plumbing.

---

# GREENFIELD

## Setup — once, one hour, never repeated

- Create `docs/`, `src/`, `tests/`, `scripts/`
- Write `scripts/verify.sh`: one command that runs format, lint, types, tests
- Write `docs/constitution.md`: one page
  - Stack, decided, not to be re-litigated
  - 5 to 7 hard rules
  - Three things explicitly out of scope for v1
- Init the package manager, add dependencies
- `git init`, commit the scaffold
- **Stop.** No CONTEXT.md, no plan, no ADRs. Those come later, if ever

For TREXO on Windows, `scripts/verify.ps1` is the canonical equivalent of
`scripts/verify.sh`.

## Every feature — the loop

**1. Write one paragraph** (10 min, me)
- `docs/specs/NNN-name.md`
- What it is, what is out of scope, what done means
- Leave an empty `Open:` section on purpose
- Do not polish it. A rough draft produces a better grilling

**2. Get grilled** (15 min)
- *"Read the spec and the constitution. Ask me the 5 questions that would most change the design. One at a time. No code. After my 5th answer, update the spec file."*
- Cap at five or I drown
- The answers are the spec. I never write a spec from a blank page

**3. Split by failure mode** (2 min, on paper)
- List every piece of the feature
- Mark each one loud or quiet
- This decides steps 4 and 5

**4. I write the quiet parts, tests first** (most of the clock)
- Failing test before the code, every time
- Pure functions: no I/O, no network, so tests are instant and total
- Thresholds as named constants, never magic numbers inside an `if`

**5. Agent writes the loud parts** (I am not watching)
- *"Implement [the loud pieces] only. Use red-green TDD. Run ./scripts/verify.sh until green. Do not modify [my files]."*
- Leave it alone. Interrupting wastes tokens and breaks its plan

**6. Read the diff** (not hunting typos)
- Is the quiet logic actually correct?
- Do I understand this, or is it magic to me?
- Does this duplicate something that already exists?
- If it is magic: *"Explain this file and list its three weakest design decisions"*

**7. Commit**
- Small, reversible, named in domain language

## From feature 2 onwards

- Same seven steps
- **Skip step 2** unless the feature is genuinely new territory
- Every fifth feature, ship nothing new. Instead:
  - *"Find duplicated logic and shallow modules. Rank by damage in three months."*
  - Fix the top two. Nothing else

---

# BROWNFIELD

The order changes because I cannot trust anything yet.

## First three days

**1. Make `verify.sh` exist and pass**
- Nothing else until this is true
- Skip broken tests with a TODO if I must
- I need one command that tells the truth before touching a line

**2. Get the map** (30 min)
- *"Explain this codebase: entry points, main modules, what depends on what."*
- *"Now list the three riskiest parts, where a bug would fail silently rather than crash."*
- That second question hands me my quiet-failure list without reading everything

**3. Write `docs/constitution.md` from what actually exists**
- Document the real stack and real conventions, not the aspirational ones
- Then add my hard rules on top

**4. Commit the baseline**
- `verify.sh` + constitution, before any behaviour change

**5. Run the full loop once on the smallest real change**
- Purpose is calibration, not the change
- I need to know what the loop costs in this codebase

## Then, every feature

- Same seven steps as greenfield
- **Refactor pass every third feature, not every fifth.** The debt is already there
- Before changing any module I have not touched before: *"Explain this module. What does it do, what depends on it, what does it depend on?"*

## Brownfield rules

- Do not refactor before I can verify
- Do not write specs for code I do not yet understand
- Do not let the agent make a sweeping change on day one. Small and local until the loop is calibrated

---

# Common to both

## The dial

The loop never changes. Only how hard I verify.

| | Throwaway | Real | High-stakes |
|---|---|---|---|
| Tests | None | Quiet paths | Everywhere |
| Diff reading | None | Critical paths | All of it |
| Refactor pass | Never | Every 10 features | Every 3 |
| Lifespan | Delete today | Months | Years |

Throwaway work is allowed to be pure vibe code. That is the right tool for
answering one question fast. The rule is that it gets deleted, never promoted.

## Design rules

- Deep modules: lots of behaviour behind a small interface
- Simple descriptive names over clever abstractions
- Pure functions wherever the logic is non-trivial
- Plain SQL over heavy ORMs
- Permission checks locally visible, not buried in middleware
- Fast tests, or the agent flails
- Closed-world constraint: when an agent must choose something, generate the
  valid options deterministically first and let it select from those. Never
  let it invent identifiers freely

## Verify before building

- Anything with a version number gets checked in a shell, not recalled from
  memory: package names, class names, field casing, API signatures, model IDs
- Ten seconds in a terminal saves an hour of confusing errors

## What I stop doing

- Writing specs before prototyping the part I am unsure about
- Reviewing line by line for bugs instead of demanding proof
- Adding process before hitting the problem it solves
- Treating "the agent says it works" as evidence
- Switching between spec mode and vibe mode by mood instead of by failure mode

## When I am lost in my own code

Never another spec. Instead:

1. *"Explain this module. What does it do, what depends on it, what does it depend on?"*
2. *"What are the three worst design decisions in here?"*
3. Fix one. Not three.

Understanding code is a task I assign to the agent, the same as writing it.

## One line

> Set up once. Then per feature: paragraph, five questions, write the dangerous
> twenty percent myself, let the agent do the rest, read the diff.

If I remember nothing else: **read the diff, every time.**
