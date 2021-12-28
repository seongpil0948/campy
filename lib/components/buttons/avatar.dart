import 'package:cached_network_image/cached_network_image.dart';
import 'package:campy/models/state.dart';
import 'package:campy/models/user.dart';
import 'package:campy/repositories/init.dart';
import 'package:campy/repositories/upload_file.dart';
import 'package:campy/utils/io.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

Widget getAvatar(double? radius, String imgUrl) => CircleAvatar(
    radius: radius, backgroundImage: CachedNetworkImageProvider(imgUrl));

class GoMyAvatar extends StatelessWidget {
  final double? radius;
  final PyUser user;
  const GoMyAvatar({Key? key, required this.user, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
      onTap: () {
        final state = ctx.read<PyState>();
        state.selectedUser = user;
        state.currPageAction = PageAction.my(user.userId);
      },
      child: getAvatar(radius, user.photoURL),
    );
  }
}

class PyUserAvatar extends StatelessWidget {
  final String imgUrl;
  final double? radius;
  final bool profileEditable;
  final String? userId;
  const PyUserAvatar({
    Key? key,
    this.radius,
    this.profileEditable = false,
    this.userId,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext ctx) {
    final avatar = getAvatar(radius, imgUrl);
    var state = ctx.read<PyState>();
    return profileEditable && userId != null
        ? InkWell(
            onTap: () async {
              final doc =
                  await getCollection(c: Collections.Users).doc(userId!).get();
              final user = PyUser.fromJson(doc.data() as Map<String, dynamic>);

              final _picker = ImagePicker();
              final f = await _picker.pickImage(source: ImageSource.gallery);
              if (f == null) return;
              state.isLoading = true;
              final pyfile = PyFile.fromXfile(f: f, ftype: PyFileType.Image);
              final uploaded = await uploadFilePathsToFirebase(
                  f: pyfile, path: 'userProfile/$userId');
              if (uploaded != null) {
                user.photoURL = uploaded.url!;
                await user.update();
                state.isLoading = false;
              } else {
                state.isLoading = false;
              }
            },
            child: avatar)
        : avatar;
  }
}
