import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final usernameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 400,
            ),
            child: body(context),
          ),
        ),
      ),
    );
  }

  Widget body(context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      children: [
        usernameField(context),
      ],
    );
  }

  Widget usernameField(context) {
    return TextFormField(
      controller: usernameCtrl,
      autofocus: true,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: L10n.of(context).username,
        icon: const Icon(Icons.abc_sharp),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.length < 2) {
          return L10n.of(context).invalidSignInUsername;
        }
        return null;
      },
    );
  }
}
