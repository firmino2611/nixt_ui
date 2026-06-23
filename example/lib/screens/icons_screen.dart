import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Browser for the full Lucide set (1,986 icons) with a name filter.
class IconsScreen extends StatefulWidget {
  /// Creates the icons screen.
  const IconsScreen({super.key});

  @override
  State<IconsScreen> createState() => _IconsScreenState();
}

class _IconsScreenState extends State<IconsScreen> {
  final _all = NixtIcons.allNames;
  String _query = '';

  List<String> get _filtered {
    if (_query.isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all.where((n) => n.contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.nixt.colors;
    final items = _filtered;

    return GalleryScaffold(
      title: 'Icons',
      showBack: true,
      scrollable: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NixtSpacing.screenGutter,
              NixtSpacing.s3,
              NixtSpacing.screenGutter,
              NixtSpacing.s2,
            ),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style:
                  TextStyle(color: c.text, fontFamily: NixtTypography.fontSans),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Filter ${_all.length} icons…',
                hintStyle: TextStyle(color: c.textDimmed),
                prefixIcon:
                    Icon(NixtIcons.search, size: 18, color: c.textMuted),
                filled: true,
                fillColor: c.bgElevated,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: context.nixt.radius.brMd,
                  borderSide: BorderSide(color: c.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: context.nixt.radius.brMd,
                  borderSide: BorderSide(color: c.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: context.nixt.radius.brMd,
                  borderSide: BorderSide(color: c.primary, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(NixtSpacing.s3),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 84,
                mainAxisExtent: 76,
                crossAxisSpacing: NixtSpacing.s2,
                mainAxisSpacing: NixtSpacing.s2,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final name = items[i];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NixtIcon(NixtIcons.byName(name), size: 22, color: c.text),
                    const SizedBox(height: NixtSpacing.s1),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontMono,
                        fontSize: NixtTypography.text2xs,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
