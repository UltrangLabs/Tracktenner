import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/pet_avatar.dart';
import '../widgets/pet_progress_section.dart';
import '../widgets/profile_top_bar.dart';

class MyProfileScreen extends StatelessWidget {
  static final EdgeInsets _screenPadding = EdgeInsets.symmetric(
    horizontal: kProfileLayoutDimensions.screenHorizontalPadding,
    vertical: kProfileLayoutDimensions.screenVerticalPadding,
  );

  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surfaceBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: _screenPadding,
          child: Column(
            children: [
              const ProfileTopBar(),
              SizedBox(height: kProfileLayoutDimensions.spacingMedium),
              const _ProfileHeader(),
              SizedBox(height: kProfileLayoutDimensions.spacingDefault),
              const PetAvatar(),
              SizedBox(height: kProfileLayoutDimensions.spacingSmall),
              const PetProgressSection(),
              SizedBox(height: kProfileLayoutDimensions.spacingLarge),
              const DailyMissionCard(),
              SizedBox(height: kProfileLayoutDimensions.spacingCompact),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  static const TextStyle _subtitleStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: tertiaryColor,
  );

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          kProfileStrings.companionSubtitle,
          style: _subtitleStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: kProfileLayoutDimensions.spacingTiny),
        Text(
          kProfileStrings.greetingTitle,
          style: _titleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
