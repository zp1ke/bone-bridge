import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../../app/route_path.dart';
import '../../../common/locator.dart';
import '../../../config.dart';
import '../../../model/profile.dart';
import '../../../service/profile_service.dart';
import '../../../state/auth.dart';
import '../../../state/route.dart';
import '../../common/alert.dart';
import '../../common/icon.dart';
import '../../shell/page_state.dart';

@AppPageRoute(path: '/profile', label: 'profile', iconCode: 'profile')
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends PageState<ProfilePage> {
  final usernameCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var active = false;
  Profile? profile;
  var isPublic = false;
  AutovalidateMode formAutovalidateMode = AutovalidateMode.disabled;
  var processing = false;

  @override
  void initState() {
    super.initState();
    active = hasService<ProfileService>();
    Future.delayed(Duration.zero, () {
      initRoute();
      if (active) {
        initProfile();
      }
    });
  }

  void initRoute() {
    if (mounted) {
      RouteState.of(context).setFeatures(canAdd: false, canReload: active);
    }
  }

  void initProfile() async {
    profile = await fetchData();
    usernameCtrl.text = profile?.username ?? '';
    isPublic = profile?.isPublic ?? false;
  }

  bool enabled(RouteState routeState) => !processing && !routeState.fetching;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    if (!active) {
      return Center(
        child: Text(
          l10n.featureNotAvailable,
          textScaler: const TextScaler.linear(1.5),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return Consumer<RouteState>(
      builder: (context, routeState, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: profile == null && enabled(routeState)
                ? Text(l10n.noProfileSaved)
                : null,
            actions: [
              if (profile?.isPublic ?? false) shareAction(routeState),
              saveAction(routeState),
            ],
          ),
          body: body(routeState),
        );
      },
    );
  }

  Widget body(RouteState routeState) {
    const verticalSeparatorSize = 16.0;
    return Form(
      key: formKey,
      autovalidateMode: formAutovalidateMode,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              usernameField(routeState),
              const SizedBox(height: verticalSeparatorSize),
              isPublicField(routeState),
            ],
          ),
        ),
      ),
    );
  }

  Widget shareAction(RouteState routeState) {
    return TextButton.icon(
      icon: const Icon(AppIcons.share),
      label: Text(L10n.of(context).share),
      onPressed: enabled(routeState) ? onShare : null,
    );
  }

  Widget saveAction(RouteState routeState) {
    return TextButton.icon(
      icon: processing ? AppIcons.loadingSmall : const Icon(AppIcons.save),
      label: Text(L10n.of(context).save),
      onPressed: enabled(routeState) ? onSave : null,
    );
  }

  Widget usernameField(RouteState routeState) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TextFormField(
        enabled: enabled(routeState),
        controller: usernameCtrl,
        autofocus: profile == null,
        autocorrect: false,
        maxLength: 100,
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
          // .requestFocus();
        },
      ),
    );
  }

  Widget isPublicField(RouteState routeState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          L10n.of(context).profileIsPublic,
          textAlign: TextAlign.start,
        ),
        Checkbox(
          value: isPublic,
          onChanged: enabled(routeState)
              ? (value) {
                  if (value != null) {
                    setState(() {
                      isPublic = value;
                    });
                  }
                }
              : null,
        ),
      ],
    );
  }

  Future fetchData() async {
    final routeState = RouteState.of(context);
    if (enabled(routeState)) {
      routeState.fetching = true;
      final auth = AuthState.of(context).auth!;
      final profileService = getService<ProfileService>();
      profile = await profileService.fetchProfile(auth);
      routeState.fetching = false;
      return profile;
    }
    return null;
  }

  void onShare() {
    final url =
        '${AppConfig.webBaseUrl}${RoutePath.profile.path}/${profile!.username}';
    shareContent(
      subject: L10n.of(context).profileOf(profile!.username),
      content: url,
    );
  }

  void onSave() {
    setState(() {
      formAutovalidateMode = AutovalidateMode.onUserInteraction;
    });
    if (formKey.currentState!.validate()) {
      saveData();
    }
  }

  void saveData() async {
    final routeState = RouteState.of(context);
    if (enabled(routeState)) {
      processing = true;
      routeState.fetching = true;

      final auth = AuthState.of(context).auth!;
      final profileService = getService<ProfileService>();
      profile ??= profileService.createProfile();
      profile!.username = usernameCtrl.text;
      profile!.isPublic = isPublic;
      profile = await profileService.saveProfile(auth, profile!);
      processing = false;
      routeState.fetching = false;
    }
  }

  @override
  void onAdd() {}

  @override
  void onReload() {
    fetchData();
  }
}
