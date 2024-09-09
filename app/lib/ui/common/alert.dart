import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:share_plus/share_plus.dart';

void showError(BuildContext context, String text) {
  final color = Theme.of(context).colorScheme.onErrorContainer;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      showCloseIcon: true,
      closeIconColor: color,
    ),
  );
}

void showConfirmation(
  BuildContext context, {
  required String title,
  required String description,
  required VoidCallback onOk,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            child: Text(L10n.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(L10n.of(context).ok),
            onPressed: () {
              Navigator.of(context).pop();
              onOk();
            },
          ),
        ],
      );
    },
  );
}

Future<bool> shareContent({required String subject, required String content}) async {
  final result = await Share.share(content, subject: subject);
  return Future.value(result.status == ShareResultStatus.success);
}
