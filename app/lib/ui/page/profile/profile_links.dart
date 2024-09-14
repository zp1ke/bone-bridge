import 'package:flutter/material.dart';

import '../../../model/profile.dart';
import '../../common/icon.dart';
import '../../widget/brand_icon_select.dart';

class ProfileLinksWidget extends StatelessWidget {
  final bool enabled;
  final Set<ProfileLink> links;
  final Function(ProfileLink) onSaved;

  const ProfileLinksWidget({
    super.key,
    required this.enabled,
    required this.links,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...links.map((item) => _ProfileLinkEdit(
              enabled: enabled,
              link: item,
              onSaved: onSaved,
            )),
        _ProfileLinkEdit(enabled: enabled, onSaved: onSaved),
      ],
    );
  }
}

class _ProfileLinkEdit extends StatefulWidget {
  final bool enabled;
  final ProfileLink? link;
  final Function(ProfileLink) onSaved;

  const _ProfileLinkEdit({
    required this.enabled,
    this.link,
    required this.onSaved,
  });

  @override
  State<StatefulWidget> createState() => _ProfileLinkEditState();
}

class _ProfileLinkEditState extends State<_ProfileLinkEdit> {
  final linkController = TextEditingController();

  IconData? iconData;
  bool canSave = false;

  @override
  void initState() {
    super.initState();
    linkController.text = widget.link?.link ?? '';
    iconData = widget.link?.iconData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          IconButton(
              onPressed: canSave ? save : null,
              icon: const Icon(AppIcons.save)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: BrandIconSelectWidget(
              enabled: widget.enabled,
              icons: AppIcons.brandIconsMap,
              selected: iconData,
              onChanged: (value) {
                iconData = value;
                checkCanSave();
                setState(() {});
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: TextFormField(
              enabled: widget.enabled,
              controller: linkController,
              onChanged: (_) {
                checkCanSave();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void checkCanSave() {
    canSave = iconData != null &&
        linkController.text.length > 3 &&
        (widget.link == null ||
            iconData != widget.link?.iconData ||
            linkController.text != widget.link?.link);
  }

  void save() {
    if (iconData != null && linkController.text.length > 3) {
      // TODO: proper validation
      final link = ProfileLink(
        id: widget.link?.id ?? '',
        link: linkController.text,
        iconData: iconData!,
      );
      widget.onSaved(link);
      setState(() {
        canSave = false;
      });
    }
  }
}
