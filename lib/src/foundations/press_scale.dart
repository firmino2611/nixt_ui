import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Wraps [child] with the design system's tactile press feedback: scale to 0.97
/// and a slight dim on pointer-down (the DS's `:active { scale(.97) }`), with an
/// optional haptic tick — together they read as a real, physical button.
///
/// Purely visual — it forwards taps to [onTap] and adds no navigation or state.
class NixtPressScale extends StatefulWidget {
  /// Creates a press-scale wrapper.
  const NixtPressScale({
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.pressedOpacity = 0.92,
    this.haptic = true,
    this.duration = const Duration(milliseconds: 110),
    this.enabled = true,
    super.key,
  });

  /// The widget to scale.
  final Widget child;

  /// Tap callback. When null and [enabled] is false, no feedback is shown.
  final VoidCallback? onTap;

  /// Pressed scale factor.
  final double scale;

  /// Opacity while pressed (1.0 disables the dim). Defaults to 0.92.
  final double pressedOpacity;

  /// Fire a light haptic tick on press-down. Defaults to true (no-op where the
  /// platform has no haptics).
  final bool haptic;

  /// Animation duration.
  final Duration duration;

  /// Whether press feedback is active.
  final bool enabled;

  @override
  State<NixtPressScale> createState() => _NixtPressScaleState();
}

class _NixtPressScaleState extends State<NixtPressScale> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  void _down() {
    _set(true);
    if (widget.haptic) HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && (widget.onTap != null);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: active ? (_) => _down() : null,
      onTapUp: active ? (_) => _set(false) : null,
      onTapCancel: active ? () => _set(false) : null,
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _pressed ? widget.pressedOpacity : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
