import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';
import '../widgets/user_form.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: kProfileLayoutDimensions.screenHorizontalPadding,
            vertical: kProfileLayoutDimensions.screenVerticalPadding,
          ),
          child: const UserForm(),
        ),
      ),
    );
  }
}
