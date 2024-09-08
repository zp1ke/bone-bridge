import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../common/logger.dart';
import '../../../model/http_error.dart';
import '../../../model/todo.dart';
import '../../common/alert.dart';
import '../../common/icon.dart';

typedef OnDone = Future Function(Todo);

class TodosEditWidget extends StatefulWidget {
  final Todo todo;
  final OnDone onDone;

  const TodosEditWidget({
    super.key,
    required this.todo,
    required this.onDone,
  });

  @override
  State<StatefulWidget> createState() => _TodosEditState();
}

class _TodosEditState extends State<TodosEditWidget> {
  final descriptionCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AutovalidateMode formAutovalidateMode = AutovalidateMode.disabled;
  bool isCompleted = false;
  bool processing = false;

  @override
  void initState() {
    super.initState();
    descriptionCtrl.text = widget.todo.description;
    isCompleted = widget.todo.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    const verticalSeparatorSize = 12.0;
    return Form(
      key: formKey,
      autovalidateMode: formAutovalidateMode,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        children: [
          title(),
          const SizedBox(height: verticalSeparatorSize),
          descriptionField(),
          const SizedBox(height: verticalSeparatorSize),
          isCompletedField(),
          const SizedBox(height: verticalSeparatorSize),
          actionButton(),
        ],
      ),
    );
  }

  Widget title() {
    final l10n = L10n.of(context);
    final item = l10n.todos;
    return Text(
      widget.todo.isNew ? l10n.createItem(item) : l10n.editItem(item),
      textAlign: TextAlign.center,
      textScaler: const TextScaler.linear(1.2),
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget descriptionField() {
    return TextFormField(
      enabled: !processing,
      controller: descriptionCtrl,
      autofocus: true,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: L10n.of(context).todoDescription,
        icon: const Icon(AppIcons.todoDescription),
      ),
      textInputAction: TextInputAction.done,
      maxLines: 3,
      maxLength: 255,
      validator: (value) {
        if (value == null || value.length < 2) {
          return L10n.of(context).invalidTextLength(2);
        }
        return null;
      },
      onFieldSubmitted: (_) {
        onAction(context);
      },
    );
  }

  Widget isCompletedField() {
    return Row(
      children: [
        Expanded(
            child: Text(
          L10n.of(context).todoIsCompleted,
          textAlign: TextAlign.end,
        )),
        Checkbox(
          value: isCompleted,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                isCompleted = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget actionButton() {
    return Center(
      child: ElevatedButton(
        onPressed: !processing
            ? () {
                onAction(context);
              }
            : null,
        child:
            !processing ? Text(L10n.of(context).save) : AppIcons.loadingSmall,
      ),
    );
  }

  void onAction(BuildContext context) {
    setState(() {
      formAutovalidateMode = AutovalidateMode.onUserInteraction;
    });
    if (formKey.currentState!.validate()) {
      doAction(context);
    }
  }

  void doAction(BuildContext context) async {
    setState(() {
      processing = true;
    });
    final todo = widget.todo
      ..description = descriptionCtrl.text
      ..isCompleted = isCompleted;
    try {
      await widget.onDone(todo);
    } on HttpError catch (e) {
      if (context.mounted) {
        showError(context, e.message ?? L10n.of(context).errorSaving);
      }
      setState(() {
        processing = false;
      });
    } catch (e, stack) {
      logError(
        'Error saving todo',
        name: 'ui/page/todos/todos_edit',
        error: e,
        stack: stack,
      );
      if (context.mounted) {
        showError(context, L10n.of(context).errorSaving);
      }
      setState(() {
        processing = false;
      });
    }
  }
}
