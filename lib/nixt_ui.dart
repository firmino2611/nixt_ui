/// Nixt UI — a faithful Flutter port of the Nuxt UI v4 mobile design system.
///
/// Signature green, seven semantic color roles, switchable neutral palettes,
/// light/dark via [ThemeExtension], Lucide icons, and Poppins type. Zero
/// third-party dependencies — Flutter SDK only.
///
/// Register a theme and start building:
///
/// ```dart
/// import 'package:nixt_ui/nixt_ui.dart';
///
/// MaterialApp(
///   theme: ThemeData(extensions: [NixtTheme.light()]),
///   darkTheme: ThemeData(extensions: [NixtTheme.dark()]),
///   home: const MyHome(),
/// );
/// ```
library nixt_ui;

// ---- Tokens ----
export 'src/tokens/palette.dart';
export 'src/tokens/color_roles.dart';
export 'src/tokens/typography_tokens.dart';
export 'src/tokens/spacing_tokens.dart';
export 'src/tokens/radius_tokens.dart';
export 'src/tokens/shadow_tokens.dart';

// ---- Theme ----
export 'src/theme/neutral_palette.dart';
export 'src/theme/nixt_colors.dart';
export 'src/theme/variant_resolver.dart';
export 'src/theme/nixt_theme.dart';
export 'src/theme/component_themes/nixt_button_theme.dart';

// ---- Foundations ----
export 'src/foundations/nixt_icons.dart';
export 'src/foundations/press_scale.dart';
export 'src/foundations/focus_ring.dart';

// ---- Components ----
export 'src/components/icon/nixt_icon.dart';
export 'src/components/buttons/nixt_button.dart';
export 'src/components/buttons/nixt_icon_button.dart';
export 'src/components/buttons/nixt_fab.dart';
export 'src/components/forms/field_shell.dart';
export 'src/components/forms/control_common.dart';
export 'src/components/forms/nixt_input.dart';
export 'src/components/forms/nixt_textarea.dart';
export 'src/components/forms/nixt_select.dart';
export 'src/components/forms/nixt_checkbox.dart';
export 'src/components/forms/nixt_radio.dart';
export 'src/components/forms/nixt_switch.dart';
export 'src/components/forms/nixt_slider.dart';
export 'src/components/forms/nixt_stepper.dart';
export 'src/components/forms/nixt_rating.dart';
export 'src/components/forms/nixt_pin_input.dart';
export 'src/components/forms/nixt_search_bar.dart';
export 'src/components/data/nixt_card.dart';
export 'src/components/data/nixt_badge.dart';
export 'src/components/data/nixt_chip.dart';
export 'src/components/data/nixt_divider.dart';
export 'src/components/data/nixt_progress.dart';
export 'src/components/data/nixt_avatar.dart';
export 'src/components/data/nixt_avatar_group.dart';
export 'src/components/data/nixt_list_item.dart';
export 'src/components/data/nixt_accordion.dart';
export 'src/components/feedback/nixt_alert.dart';
export 'src/components/feedback/nixt_empty_state.dart';
export 'src/components/feedback/nixt_skeleton.dart';
export 'src/components/feedback/nixt_toast.dart';
export 'src/components/navigation/nixt_app_bar.dart';
export 'src/components/navigation/nixt_bottom_nav.dart';
export 'src/components/navigation/nixt_tabs.dart';
export 'src/components/navigation/nixt_page_indicator.dart';
export 'src/components/overlay/nixt_sheet.dart';
export 'src/components/overlay/nixt_action_sheet.dart';
export 'src/components/overlay/nixt_dialog.dart';
export 'src/components/overlay/nixt_menu.dart';
export 'src/app/nixt_app.dart';
