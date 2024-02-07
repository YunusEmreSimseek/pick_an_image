import 'package:app_settings/app_settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pick_an_image/services/permission_chech_service.dart';
import 'package:pick_an_image/services/pick_image_service.dart';

abstract class IPickManager {
  final IPermissionCheckService permissionCheckService = PermissionCheckService();
  final IPickImageService pickImageService = PickImageService();
  Future<PickImageModel?> fetchMediaImage();
}

class PickManager extends IPickManager {
  @override
  Future<PickImageModel?> fetchMediaImage() async {
    if (!await permissionCheckService.checkPhotoStatus()) {
      await AppSettings.openAppSettings();
      return PickImageModel(file: null);
    }
    final model = await pickImageService.pickImageFromGallery();
    return PickImageModel(file: model, status: true);
  }
}

class PickImageModel {
  PickImageModel({required this.file, this.status = false});

  final XFile? file;
  final bool status;
}
