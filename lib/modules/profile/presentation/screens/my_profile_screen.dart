import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/window_modal.dart';
import '../constants/profile_constants.dart';
import '../controllers/profile_controller.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/pet_avatar.dart';
import '../widgets/pet_progress_section.dart';
import '../widgets/profile_top_bar.dart';
import '../widgets/user_form.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: _createController,
      child: const Scaffold(
        backgroundColor: surfaceBackgroundColor,
        body: SafeArea(child: _ProfileBody()),
      ),
    );
  }

  ProfileController _createController(BuildContext context) {
    final controller = sl<ProfileController>();
    // Se difiere para no notificar listeners durante la fase de build.
    Future<void>.microtask(controller.checkExistingAccount);
    return controller;
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  static const double _modalWidth = 360.0;
  static const double _modalHeight = 640.0;

  // Evita abrir modales duplicados en cada redibujado.
  bool _isModalOpen = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (controller.errorMessage != null) {
      return _ProfileError(message: controller.errorMessage!);
    }

    if (controller.data == null) {
      _scheduleUserFormModal(controller);
      return const SizedBox.expand();
    }

    return const _ProfileContent();
  }

  void _scheduleUserFormModal(ProfileController controller) {
    if (_isModalOpen) {
      return;
    }
    _isModalOpen = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      WindowModal.show<void>(
        context: context,
        width: _modalWidth,
        height: _modalHeight,
        barrierDismissible: false,
        child: SingleChildScrollView(
          child: UserForm(
            onUserCreated: (String userName) =>
                _onUserCreated(controller: controller, userName: userName),
          ),
        ),
      ).whenComplete(() => _isModalOpen = false);
    });
  }

  Future<void> _onUserCreated({
    required ProfileController controller,
    required String userName,
  }) async {
    // showDialog usa el navigator raíz por defecto (fuera del ShellRoute).
    Navigator.of(context, rootNavigator: true).pop();
    await controller.createUser({'name': userName});
  }
}

class _ProfileError extends StatelessWidget {
  static const TextStyle _errorStyle = TextStyle(color: inputErrorColor);

  final String message;

  const _ProfileError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: _errorStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  static final EdgeInsets _screenPadding = EdgeInsets.symmetric(
    horizontal: kProfileLayoutDimensions.screenHorizontalPadding,
    vertical: kProfileLayoutDimensions.screenVerticalPadding,
  );

  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
