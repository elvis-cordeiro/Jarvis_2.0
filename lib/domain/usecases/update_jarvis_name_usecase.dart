import 'package:jarvis_pessoal/data/repositories/settings_repository.dart';

class UpdateJarvisNameUseCase {
  final SettingsRepository repository;

  UpdateJarvisNameUseCase(this.repository);

  Future<void> call(String newName) async {
    if (newName.trim().isEmpty) {
      throw Exception("Nome não pode ser vazio");
    }
    await repository.updateJarvisName(newName);
  }
}