---
name: release
description: >-
  Cut a release of the nixt_ui package: pick the next version, update the
  CHANGELOG from the changes since the last release, commit, tag, push to
  GitHub, and publish to pub.dev. Use this whenever the user asks to release,
  ship, cut a version, bump the version, publish to pub.dev, or run "the final
  release process" for this package. Invoked as `/release` (optionally with a
  bump type or explicit version, e.g. `/release minor` or `/release 0.6.0`).
---

# Release nixt_ui

A guided runbook to ship a new version of `nixt_ui` to GitHub + pub.dev. Publishing
is **public and irreversible** (pub.dev has no unpublish, only a 7-day retract),
so validate first and confirm before the upload.

`$ARGUMENTS` may be a bump type (`patch` | `minor` | `major`) or an explicit
version (`0.6.0`). If empty, infer the bump from the changes (see step 2).

## Steps

### 1. Establish the baseline
- Confirm the repo root is the package (a `pubspec.yaml` with `name: nixt_ui`).
- Read the current version: `grep '^version:' pubspec.yaml`.
- See what's shipping: `git log --oneline "$(git describe --tags --abbrev=0)"..HEAD`
  (or the diff against the last `Release` commit) plus `git status --short` for
  uncommitted work. You need this to write the changelog and pick the bump.

### 2. Pick the next version (semver, pre-1.0 aware)
If `$ARGUMENTS` gives a version, use it. If it gives a bump type, apply it.
Otherwise infer from the changes — and **state your reasoning and the chosen
version to the user before bumping**:
- **Breaking change** (removed/renamed/retyped public API) → bump **minor** while
  `0.x` (e.g. `0.4.0 → 0.5.0`); bump **major** once `>= 1.0.0`.
- **New feature / additive public API** (new component, new optional param) →
  bump **minor**.
- **Bug fix / docs / internal only** → bump **patch**.

### 3. Validate — abort the release if anything fails
```bash
dart analyze lib example
(cd example && flutter test)
```
Both must be clean. If not, stop and report — do not bump or publish a red build.

### 4. Bump the version
Edit `version:` in `pubspec.yaml` to the chosen `X.Y.Z`.

### 5. Update CHANGELOG.md
Prepend a new `## X.Y.Z` section above the previous one. Summarize the actual
changes from step 1, grouped under `### Added` / `### Changed` / `### Fixed` /
`### Breaking` (only the groups that apply), referencing the public API by name
(`NixtChipIndicator`, `NixtInput.label`, …). Keep it consumer-focused — what a
package user gains or must migrate — not internal refactors. Match the terse,
wrapped prose style of the existing entries. Always call out breaking changes in
a `### Breaking` block with the migration.

### 6. Commit + tag
Stage everything and commit (subject `Release X.Y.Z — <one-line summary>`, body
with bullet highlights). End the commit message with:
```
Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
```
Then annotate a tag: `git tag -a vX.Y.Z -m "Release X.Y.Z"`.

Release commits go to the default branch (`main`) — that matches the existing
`Release 0.x` history; don't branch for a release.

### 7. Push
```bash
git push origin main
git push origin vX.Y.Z
```

### 8. Dry-run, then publish
```bash
dart pub publish --dry-run
```
Expect only the "uncommitted files" warning to be gone (you just committed) and
no other issues. Then publish:
```bash
dart pub publish --force
```
`--force` is required because the agent shell is non-interactive (the normal
y/N prompt can't be answered). Only run it after the dry-run is clean and the
user has authorized the release. Auth uses the existing pub.dev OAuth credential
(`~/Library/Application Support/dart/pub-credentials.json`); if it's missing, the
upload fails and the user must run `dart pub login` once in a real terminal.

### 9. Report
Confirm: new version, the `Release X.Y.Z` commit hash + tag, the GitHub push, and
the pub.dev "Successfully uploaded" message with the
https://pub.dev/packages/nixt_ui link.

## Guardrails
- Never publish on a failing `analyze`/`test` (step 3).
- Never bump or publish if the working tree contains unrelated changes you didn't
  account for in the changelog — surface them first.
- Publishing is irreversible; if anything in steps 1–7 looks off, stop and ask.
- If the package version already exists on pub.dev, the upload is rejected — pick
  a higher version.
