import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/bloc/auth/auth_bloc.dart';
import 'package:messenger/features/settings_drawer/bloc/settings_bloc.dart';
import 'package:messenger/generated/l10n.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  final photoURL = context.select(
                      (AuthBloc value) => value.state.currentUser.photoURL);
                  return GestureDetector(
                    onTap: () async => await _changeAvatar(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: photoURL != null
                          ? Image.network(photoURL, fit: BoxFit.cover)
                          : SvgPicture.asset(
                              'assets/svg/person.svg',
                              colorFilter: ColorFilter.mode(
                                theme.colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            context.read<AuthBloc>().state.currentUser.name ??
                S.of(context).loadingError,
            style: theme.textTheme.labelMedium,
          )
        ],
      ),
    );
  }

  Future<void> _changeAvatar() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null && mounted) {
      context.read<SettingsBloc>().add(AvatarDeleteEvent());
      return;
    }
    final file = File(pickedImage!.path);
    if (mounted) {
      context.read<SettingsBloc>().add(AvatarUploadEvent(file: file));
    }
    setState(() {});
  }
}
