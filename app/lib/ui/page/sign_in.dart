import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../app/route_path.dart';
import '../../app/router.dart';
import '../../common/logger.dart';
import '../../state/auth.dart';
import '../../model/http_error.dart';
import '../../service/auth_service.dart';
import '../common/alert.dart';
import '../common/icon.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final passwordFocus = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool passwordHidden = true;
  AutovalidateMode formAutovalidateMode = AutovalidateMode.disabled;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).appTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 450),
            child: body(context),
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    const verticalSeparatorSize = 16.0;
    return Form(
      key: formKey,
      autovalidateMode: formAutovalidateMode,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        children: [
          usernameField(context),
          const SizedBox(height: verticalSeparatorSize),
          passwordField(context),
          const SizedBox(height: verticalSeparatorSize),
          actionButton(context),
        ],
      ),
    );
  }

  Widget usernameField(BuildContext context) {
    return TextFormField(
      enabled: !processing,
      controller: usernameCtrl,
      autofocus: true,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: L10n.of(context).username,
        icon: const Icon(AppIcons.username),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.length < 2) {
          return L10n.of(context).invalidTextLength(2);
        }
        return null;
      },
      onFieldSubmitted: (_) {
        passwordFocus.requestFocus();
      },
    );
  }

  Widget passwordField(BuildContext context) {
    return TextFormField(
      enabled: !processing,
      controller: passwordCtrl,
      autocorrect: false,
      obscureText: passwordHidden,
      decoration: InputDecoration(
        labelText: L10n.of(context).password,
        icon: const Icon(AppIcons.password),
        suffixIcon: togglePasswordButton(context),
      ),
      textInputAction: TextInputAction.go,
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

  Widget togglePasswordButton(BuildContext context) {
    return IconButton(
      icon:
          Icon(passwordHidden ? AppIcons.showPassword : AppIcons.hidePassword),
      onPressed: () {
        setState(() {
          passwordHidden = !passwordHidden;
        });
      },
    );
  }

  Widget actionButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: !processing
            ? () {
                onAction(context);
              }
            : null,
        child:
            !processing ? Text(L10n.of(context).signIn) : AppIcons.loadingSmall,
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
    final credentials = UsernamePasswordCredentials(
      username: usernameCtrl.text,
      password: passwordCtrl.text,
    );
    try {
      await AuthState.of(context).authenticate(credentials);
      if (context.mounted) {
        context.navToPath(RoutePath.home);
      }
    } on HttpError catch (e) {
      if (context.mounted) {
        showError(context, e.message ?? L10n.of(context).errorSigningIn);
      }
      setState(() {
        processing = false;
      });
    } catch (e, stack) {
      logError(
        'Error signing in',
        name: 'ui/page/sign_in',
        error: e,
        stack: stack,
      );
      if (context.mounted) {
        showError(context, L10n.of(context).errorSigningIn);
      }
      setState(() {
        processing = false;
      });
    }
  }
}
