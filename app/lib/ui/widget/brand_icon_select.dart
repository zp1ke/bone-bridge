import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../common/string.dart';

class BrandIconSelectWidget extends StatelessWidget {
  final bool enabled;
  final Map<IconData, String> icons;
  final IconData? selected;
  final Function(IconData) onChanged;

  const BrandIconSelectWidget({
    super.key,
    required this.enabled,
    required this.icons,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return DropdownSearch<IconData>(
      enabled: enabled,
      popupProps: PopupProps.menu(
        showSelectedItems: selected != null,
        showSearchBox: true,
        searchDelay: const Duration(milliseconds: 500),
        itemBuilder: (context, value, isSelected) {
          return Icon(
            value,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          );
        },
      ),
      items: icons.keys.toList(),
      selectedItem: selected,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: l10n.selectIcon,
          hintText: l10n.selectIcon,
        ),
      ),
      filterFn: (value, text) {
        if (text.length > 2) {
          final valueText = icons[value]!;
          return valueText.hasSimilarityTo(text);
        }
        return true;
      },
      onChanged: enabled
          ? (value) {
              if (value != null) {
                onChanged(value);
              }
            }
          : null,
    );
  }
}
