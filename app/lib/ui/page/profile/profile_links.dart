import 'package:flutter/material.dart';

import '../../common/icon.dart';
import '../../widget/brand_icon_select.dart';

class ProfileLinksWidget extends StatelessWidget {
  final bool enabled;
  final Map<String, IconData> links;

  const ProfileLinksWidget({
    super.key,
    required this.enabled,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...links.entries.map(_entryItem),
        _entryItem(null),
      ],
    );
  }

  Widget _entryItem(MapEntry<String, IconData>? entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: BrandIconSelectWidget(
              enabled: enabled,
              icons: AppIcons.brandIconsMap,
              selected: entry?.value,
              onChanged: (_) {},
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: TextFormField(
              enabled: enabled,
              controller: TextEditingController(text: entry?.key),
            ),
          ),
        ],
      ),
    );
  }
}
