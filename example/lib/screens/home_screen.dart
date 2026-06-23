import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../registry.dart';
import '../widgets/gallery_scaffold.dart';

/// The catalog home — a grid of component cards.
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Nixt UI',
      showNeutralSwitcher: true,
      scrollable: false,
      body: GridView.builder(
        padding: const EdgeInsets.all(NixtSpacing.screenGutter),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisExtent: 120,
          crossAxisSpacing: NixtSpacing.s3,
          mainAxisSpacing: NixtSpacing.s3,
        ),
        itemCount: kComponents.length,
        itemBuilder: (context, i) => _ComponentCard(entry: kComponents[i]),
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  const _ComponentCard({required this.entry});

  final ComponentEntry entry;

  @override
  Widget build(BuildContext context) {
    final t = context.nixt;
    final c = t.colors;
    return Opacity(
      opacity: entry.ready ? 1 : 0.45,
      child: NixtPressScale(
        onTap: entry.ready
            ? () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: entry.builder),
                )
            : null,
        child: Container(
          padding: const EdgeInsets.all(NixtSpacing.s4),
          decoration: BoxDecoration(
            color: c.bgElevated,
            borderRadius: t.radius.brLg,
            border: Border.all(color: c.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(NixtSpacing.s2),
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: t.radius.brMd,
                ),
                child: Icon(entry.icon, size: 20, color: c.textInverted),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.name,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontSans,
                        fontWeight: NixtTypography.weightSemibold,
                        fontSize: NixtTypography.textBase,
                        color: c.textHighlighted,
                      ),
                    ),
                  ),
                  if (!entry.ready)
                    Text(
                      'soon',
                      style: TextStyle(
                        fontFamily: NixtTypography.fontMono,
                        fontSize: NixtTypography.text2xs,
                        color: c.textDimmed,
                      ),
                    )
                  else
                    Icon(NixtIcons.chevronRight, size: 18, color: c.textMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
