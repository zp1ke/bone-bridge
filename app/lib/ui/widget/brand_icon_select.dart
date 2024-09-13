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
        searchFieldProps: TextFieldProps(
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.selectIcon,
            enabled: enabled,
          ),
          maxLength: 50,
          textInputAction: TextInputAction.search,
        ),
        itemBuilder: itemBuilder,
      ),
      compareFn: (iconData1, iconData2) {
        return iconData1 == iconData2;
      },
      dropdownBuilder: selected != null
          ? (context, value) => itemBuilder(context, value!, true)
          : null,
      items: icons.keys.toList(),
      selectedItem: selected,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: selected == null ? l10n.selectIcon : null,
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

  Widget itemBuilder(BuildContext context, IconData value, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            value,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              icons[value] ?? '',
              style: TextStyle(
                fontWeight: value == selected ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
