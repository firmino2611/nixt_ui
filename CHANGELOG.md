# Changelog

## 0.5.0

Optional field labels across the form family.

### Added
- **`label`** on every form-field component that lacked one: `NixtInput`
  (already had it), `NixtTextarea`, `NixtSearchBar`, `NixtSelect`,
  `NixtMultiSelect`, `NixtStepper`, `NixtRating`, `NixtPinInput`, and
  `NixtCalendar`. The label renders above the control, paints in the error color
  when the field is errored, and scales with the field/control size where one
  exists.
- **`NixtFieldLabel`** — the shared widget behind the `label` parameter,
  exported for building custom labeled controls.

Toggle controls (`NixtCheckbox`, `NixtRadio`, `NixtSwitch`) and `NixtSlider`
already expose their own `label`/`description` and are unchanged.

## 0.4.0

Color-system overhaul, automatic contrast, and a new indicator component.

### Added
- **`NixtChipIndicator`** — a dot/count indicator overlaid on any child (the
  mobile port of Nuxt UI's Chip): status dots, unread counts (`max` clamps to
  `N+`), `position`, `inset` for circular children, `standalone`, and `show`.
- **Palette from a single color** — configure a role from one brand color and
  get the whole `50…950` scale automatically: `NixtRoleColor(seed, {shades})`
  plus a `palette:` parameter on `NixtApp` / `NixtTheme.light|dark`. The seed
  becomes shade `500`; individual shades can be overridden.
- **`NixtShade` enum** (`s50…s950`) — type-safe shade steps; an invalid step is
  now a compile error instead of a runtime crash.
- **Named shade accessors** — `colors.primary600`, `colors.error100`, … for
  every role × shade, plus `colors.shade(role, NixtShade)` and
  `NixtColors.copyWith`.
- **`nixtOnColor(background)`** — contrast-safe foreground (near-black or white)
  picked by luminance.
- **`NixtInput.label`** — optional label that scales with the field size.
- **`NixtAppBar.backgroundColor`** — custom bar fill; text and icons adapt for
  contrast automatically.

### Changed
- **Automatic contrast everywhere** — solid-fill components (button, icon
  button, FAB, badge, checkbox, select check, bottom-nav badge, chip indicator,
  app bar) now pick their foreground from the fill's luminance, so a light brand
  color (bright cyan, amber) gets dark glyphs instead of unreadable white.
- **Tabs (pill)** — stronger selected emphasis: accent label, accent border, and
  a deeper shadow on the sliding pill (fixes the washed-out look in dark mode).

### Breaking
- `NixtColorScale.shade` and `NixtColorScale.fromSeed(overrides:)` now take
  `NixtShade` instead of raw `int` (e.g. `scale.shade(NixtShade.s700)`,
  `overrides: {NixtShade.s900: …}`). Migrate `int` step literals to the enum.

## 0.3.0

Seven new components, all theme-driven and light/dark aware.

### Components
- **Forms** — `NixtCalendar` (month-grid date picker with prev/next paging) and
  `NixtNumberPad` (3-column numeric keypad for PINs and amounts).
- **Data** — `NixtStat` (metric + delta with inferred trend arrow), `NixtTimeline`
  (vertical status feed with filled/dashed markers), and `NixtCarousel`
  (swipeable full-width pager with synced page dots).
- **Feedback** — `NixtSpinner` (standalone loading ring; slows for reduced motion).
- **Navigation** — `NixtSteps` (horizontal step indicator for multi-step flows).

## 0.2.0

Maintenance release.

## 0.1.0

Initial release — a Flutter port of the Nuxt UI v4 mobile design system.

### Theming
- 3-layer token model: raw palette → semantic colors → `NixtTheme`
  (`ThemeExtension`), with `NixtTheme.of(context)` / `context.nixt`.
- 7 semantic color roles, switchable neutral palettes (slate / zinc / neutral /
  stone), single-token radius scale, elevation shadows.
- Per-app brand-color overrides via `NixtColorScale.fromSeed`.
- Native light/dark support.
- `NixtApp` — a drop-in `MaterialApp` replacement that configures the whole
  design system in one place (and forwards every `MaterialApp` property);
  `NixtApp.router` variant included.

### Components
- **Buttons** — `NixtButton`, `NixtIconButton`, `NixtFab`.
- **Icon** — `NixtIcon` with the bundled Lucide set (`NixtIcons`, 1,986 glyphs).
- **Forms** — `NixtInput`, `NixtTextarea`, `NixtSelect`, `NixtMultiSelect`,
  `NixtCheckbox`, `NixtRadio`, `NixtSwitch`, `NixtSlider`, `NixtStepper`,
  `NixtRating`, `NixtPinInput`, `NixtSearchBar`.
- **Data** — `NixtCard`, `NixtBadge`, `NixtChip`, `NixtDivider`, `NixtProgress`,
  `NixtAvatar`, `NixtAvatarGroup`, `NixtListItem`, `NixtAccordion`.
- **Feedback** — `NixtAlert`, `NixtEmptyState`, `NixtSkeleton`, `NixtToast`.
- **Navigation** — `NixtAppBar`, `NixtBottomNav`, `NixtTabs`,
  `NixtPageIndicator`.
- **Overlay** — `showNixtSheet`, `showNixtActionSheet`, `showNixtDialog`,
  `NixtMenu`.

### Assets
- Bundled Poppins, JetBrains Mono, and Lucide fonts.

Zero third-party dependencies. Requires Flutter 3.19 / Dart 3.3 or newer.
