## Approach
- Read existing files before writing. Don't re-read unless changed.
- Be thorough in reasoning, concise in output.
- Avoid sycophantic openers. Avoid closing fluff.
- Avoid emojis or em-dashes.
- Never guess APIs, versions, flags, commit SHAs, or package names. Verify by reading code or docs before asserting.
- Be direct and to the point. You don't have time for fluff, I don't have time to read it.
- BE SUCCINCT. BE CONCISE. Avoid adjectives. Avoid adverbs. Avoid filler words.
- NEVER comment on, publish, push, or edit anything remotely without first asking the user.
- Never add Co-Authored-By lines to commit messages or PR descriptions. Author commits succinctly: use short, lowercase sentences and 1-3 bullet points.
- In subagent prompts that involve commits or test runs, require raw command output pasted verbatim (no paraphrasing). Then verify against ground truth (git log, git status, file contents) before trusting the report.
- Write composable functions and use functional patterns.
- Prefer immutable data structures.
- Write pure functions that rely only on their input and produce no side effects. Avoid global state.
- Ensure safety via type checking, unit tests, integration tests, benchmarks, versioning, and automation.

## Shell & tools
- Prefer dedicated tools over the shell: Read to view files, Grep to search, Glob to find. Avoid tools like cat/head/tail/sed/awk/grep/find/echo when a tool fits.
- One command, one intent. Do not chain unrelated commands with `;` or `&&`. Never add `echo "==="` banners or throwaway shell variables to structure or label output. Caveat, " && echo OK" or similar is acceptable to represent success of the preceding command.
- If you need several independent facts, make multiple tool calls in parallel. Do not fold them into one shell line.
- Reserve bash for real shell work: builds, git, package managers, running programs. When a pipeline genuinely is the right tool, keep it to a single purpose and legible.
- Efficiency means parallel tool calls, not multi-command one-liners.

## On checks and guards.
- Avoid checks and guards that protect the user from themselves. If a check only prevents the user from making a mistake they could easily fix, it is not worth implementing.

## Normative language
- Reserve "contract", "invariant", "forbidden", "must", "never" for constraints that are genuinely binding: enforced by a mechanism (test/CI/type/build), required by an external system, or a decision deliberately committed to.
- Impromptu or convenience choices are choices. Write them as "currently X" or "chose X for now", and say why.
- Don't manufacture authority. A false "contract" misleads every later reader and hides which constraints are real.
- When reading such a label, verify something actually enforces it before treating it as binding.