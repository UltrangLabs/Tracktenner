import '../../../../core/domain/types/unknown_type.dart';
import '../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../../../core/presentation/controllers/base_controller.dart';
import '../../application/use_cases/create_user_use_case.dart';
import '../../application/use_cases/get_user_already_have_an_account_use_case.dart';
import '../../domain/entities/user_entity.dart';

class ProfileController extends BaseController<User> {
  final ExecuteGetUserAlreadyHaveAnAccountUseCase _getUserAction;
  final ExecuteCreateUserUseCase _createUserAction;

  ProfileController({
    required this._getUserAction,
    required this._createUserAction,
  });

  Future<void> checkExistingAccount() async {
    setLoading(isLoading: true);

    try {
      final user = await _getUserAction(const NoParams());
      if (user != null) {
        setData(user);
      } else {
        setLoading(isLoading: false);
      }
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> createUser(Unknown rawData) async {
    setLoading(isLoading: true);
    try {
      await _createUserAction(rawData);

      await checkExistingAccount();
    } catch (e) {
      setError(e.toString());
    }
  }
}
