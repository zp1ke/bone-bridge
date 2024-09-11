import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/locator.dart';
import '../../model/profile.dart';
import '../../service/storage_service.dart';
import '../../state/auth.dart';

class ProfileImageWidget extends StatelessWidget {
  final Profile? profile;
  final String? username;
  final double radius;

  const ProfileImageWidget({
    super.key,
    this.profile,
    this.username,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      return FutureBuilder<Uint8List?>(
        future: _imageLoader(authState),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return _bytesImage(snapshot.data!);
          }
          return _iconImage();
        },
      );
    });
  }

  Future<Uint8List?> _imageLoader(AuthState authState) async {
    final storageService = getService<StorageService>();
    final imageKey = Profile.imageKey(profile?.userId ?? authState.auth!.id);
    return storageService.getFile(key: imageKey);
  }

  Widget _iconImage() {
    return CircleAvatar(
      radius: radius,
      backgroundImage: Image.network(
        Profile.imageUrl(
          profile: profile,
          username: username,
          radius: radius,
        ),
        fit: BoxFit.cover,
      ).image,
    );
  }

  Widget _bytesImage(Uint8List bytes) {
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.memory(
          bytes,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
