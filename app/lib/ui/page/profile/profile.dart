import 'package:annotations/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../../app/route_path.dart';
import '../../../common/locator.dart';
import '../../../common/string.dart';
import '../../../config.dart';
import '../../../model/profile.dart';
import '../../../service/profile_service.dart';
import '../../../service/storage_service.dart';
import '../../../state/auth.dart';
import '../../../state/route.dart';
import '../../common/alert.dart';
import '../../common/file.dart';
import '../../common/icon.dart';
import '../../shell/page_state.dart';
import '../../widget/profile_image.dart';
import 'profile_links.dart';

@AppPageRoute(path: '/profile', label: 'profile', iconCode: 'profile')
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends PageState<ProfilePage> {
  static const leadingPadding = 42.0;

  final formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final nameFocus = FocusNode();
  final summaryCtrl = TextEditingController();
  final summaryFocus = FocusNode();

  final links = <ProfileLink>{};

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
    if (profile != null) {
      usernameCtrl.text = profile!.username;
      isPublic = profile!.isPublic;
      nameCtrl.text = profile!.name;
      summaryCtrl.text = profile!.summary;
    }
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
        final isEnabled = enabled(routeState);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title:
                profile == null && isEnabled ? Text(l10n.noProfileSaved) : null,
            actions: [
              if (profile?.isPublic ?? false) shareAction(isEnabled),
              saveAction(isEnabled),
            ],
          ),
          body: body(isEnabled),
        );
      },
    );
  }

  Widget body(bool isEnabled) {
    final items = <Widget>[
      usernameField(isEnabled),
      isPublicField(isEnabled),
      imageField(isEnabled),
      nameField(isEnabled),
      summaryField(isEnabled),
      linksField(isEnabled),
    ];
    const verticalSeparatorSize = 16.0;
    return Form(
      key: formKey,
      autovalidateMode: formAutovalidateMode,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 10, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (item) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: verticalSeparatorSize),
                    child: item,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget shareAction(bool enabled) {
    return TextButton.icon(
      icon: const Icon(AppIcons.share),
      label: Text(L10n.of(context).share),
      onPressed: enabled ? onShare : null,
    );
  }

  Widget saveAction(bool enabled) {
    return TextButton.icon(
      icon: processing ? AppIcons.loadingSmall : const Icon(AppIcons.save),
      label: Text(L10n.of(context).save),
      onPressed: enabled ? onSave : null,
    );
  }

  Widget usernameField(bool enabled) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TextFormField(
        enabled: enabled,
        controller: usernameCtrl,
        autofocus: profile == null,
        autocorrect: false,
        maxLength: 50,
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
          nameFocus.requestFocus();
        },
      ),
    );
  }

  Widget isPublicField(bool enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: leadingPadding),
        Text(
          L10n.of(context).profileIsPublic,
          textAlign: TextAlign.start,
        ),
        Checkbox(
          value: isPublic,
          onChanged: enabled
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

  Widget imageField(bool enabled) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: leadingPadding),
        ProfileImageWidget(
          radius: 40.0,
          profile: profile,
          username: usernameCtrl.text,
        ),
        if (hasService<StorageService>())
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
              onPressed: enabled ? uploadImage : null,
              child: Text(L10n.of(context).uploadImage),
            ),
          ),
      ],
    );
  }

  Widget nameField(bool enabled) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TextFormField(
        enabled: enabled,
        controller: nameCtrl,
        autocorrect: false,
        maxLength: 150,
        decoration: InputDecoration(
          labelText: L10n.of(context).name,
          icon: const Icon(AppIcons.name),
        ),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          summaryFocus.requestFocus();
        },
      ),
    );
  }

  Widget summaryField(bool enabled) {
    return TextFormField(
      enabled: enabled,
      controller: summaryCtrl,
      autocorrect: false,
      maxLength: 500,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: L10n.of(context).summary,
        icon: const Icon(AppIcons.summary),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        // .requestFocus();
      },
    );
  }

  Widget linksField(bool enabled) {
    const emptyIconData = AppIcons.emptyIcon;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: ProfileLinksWidget(
        enabled: enabled,
        links: links,
        onSaved: (link) {
          if (link.link.length > 3 && link.iconData != emptyIconData) {
            final profileLink = ProfileLink(
              id: link.id.isNotEmpty ? link.id : randomUID(),
              link: link.link,
              iconData: link.iconData,
            );
            setState(() {
              links.add(profileLink);
            });
          }
        },
      ),
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

  void uploadImage() async {
    final file = await pickImage();
    if (file != null && mounted) {
      processing = true;
      final routeState = RouteState.of(context);
      routeState.fetching = true;

      final auth = AuthState.of(context).auth!;
      final imageKey = Profile.imageKey(auth.id);
      await getService<StorageService>().saveFile(
        auth,
        key: imageKey,
        name: '$imageKey.${file.extension}',
        bytes: file.bytes,
      );
      processing = false;
      routeState.fetching = false;
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
      profile = profile!.copyWith(
        username: usernameCtrl.text,
        isPublic: isPublic,
        name: nameCtrl.text,
        summary: summaryCtrl.text,
      );
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
