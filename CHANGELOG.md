# Changelog

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
