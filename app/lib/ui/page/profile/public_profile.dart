import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../../common/locator.dart';
import '../../../model/profile.dart';
import '../../../service/profile_service.dart';

class PublicProfilePage extends StatefulWidget {
  final String username;

  const PublicProfilePage({
    super.key,
    required this.username,
  });

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  var loading = true;
  Profile? profile;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initProfile();
    });
  }

  void initProfile() async {
    if (hasService<ProfileService>()) {
      final profileService = getService<ProfileService>();
      profile = await profileService.fetchPublicProfile(widget.username);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 850),
            child: body(),
          ),
        ),
      ),
    );
  }

  Widget? title() {
    if (profile != null) {
      return Text(
        widget.username,
        textScaler: const TextScaler.linear(0.6),
        style: TextStyle(
          color: Theme.of(context).disabledColor,
          fontWeight: FontWeight.w300,
        ),
      );
    }
    return null;
  }

  Widget body() {
    if (loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (profile != null) {
      return ListView(
        children: [
          headerCard(),
        ].map((item) => card(child: item)).toList(),
      );
    }
    return nothingHereBody();
  }

  Widget headerCard() {
    return Text(profile!.username);
  }

  Widget nothingHereBody() {
    return Center(
      child: Text(
        L10n.of(context).nothingHere,
        textScaler: const TextScaler.linear(1.5),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget card({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: child,
        ),
      ),
    );
  }
}
