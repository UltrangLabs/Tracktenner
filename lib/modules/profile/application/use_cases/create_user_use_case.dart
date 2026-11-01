import '../../../../core/domain/errors/custom_error.dart';
import '../../../../core/domain/types/unknown_type.dart';
import '../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../../../core/infrastructure/adapters/validator_adapter.dart';

import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/dtos/in/looking_user_exist_dto.dart';
import '../../domain/repositories/mutation_user_repository.dart';
import '../../domain/repositories/query_user_repository.dart';
import '../dtos/in/create_user_dto.dart';
import '../dtos/in/looking_user_exists_dto.dart';

typedef ExecuteCreateUserUseCase = Future<void> Function(Unknown rawData);

typedef DtosCreated = ({
  CreateUserDto createUserDto,
  LookingUserDto lookingForUserExist,
});

class CreateUserUseCase implements UseCaseStructure<void, Unknown> {
  final MutationUserRepository _mutationUserRepository;
  final QueryUserRepository _queryUserRepository;
  final ValidatorAdapter<CreateUserDto> _userValidator;
  final ValidatorAdapter<LookingUserDto> _userExistValidator;

  CreateUserUseCase({
    required this._mutationUserRepository,
    required this._queryUserRepository,
    required this._userValidator,
    required this._userExistValidator,
  });

  @override
  Future<void> execute(Unknown rawData) async {
    final (:createUserDto, :lookingForUserExist) = _createDtos(rawData);

    await _verifyUserExist(lookingForUserExist);

    await _mutationUserRepository.createUser(dto: createUserDto);
  }

  DtosCreated _createDtos(Unknown rawData) {
    final createUserDto = CreateUserDtoImpl.create(
      rawData: rawData,
      validator: _userValidator,
    );

    final Unknown rawDataUserExist = {'name': createUserDto.name};

    final dtoUserExist = LookingUserExistsDto.create(
      rawData: rawDataUserExist,
      validator: _userExistValidator,
    );

    return (createUserDto: createUserDto, lookingForUserExist: dtoUserExist);
  }

  Future<void> _verifyUserExist(LookingUserDto lookingForUserExist) async {
    final userFound = await _queryUserRepository.lookingForUserExist(
      lookingForUserExist,
    );

    if (userFound != null) {
      throw CustomError.badRequest(
        payload: [
          (message: "There is an user with that name", path: "create user"),
        ],
        path: "CreateUser",
      );
    }
  }
}
