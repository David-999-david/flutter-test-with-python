import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testflutt/data/model/category_sub_cate.dart';
import 'package:testflutt/data/service/cat_sub.dart';

final categoryProvider =
    StateNotifierProvider.family<
      CategoryNotifier,
      AsyncValue<List<Category>>,
      String?
    >((ref, query) => CategoryNotifier(ref, query));

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  CategoryNotifier(this.ref, this.query) : super(AsyncValue.loading()) {
    getAllCategory(query);
  }

  final Ref ref;
  String? query;

  Future<void> getAllCategory(String? query) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CatSub().getCategory(query));
  }
}

final SubProvider =
    StateNotifierProvider.family<
      SubCategoryNotifier,
      AsyncValue<List<SubCategory>>,
      String?
    >((ref, query) => SubCategoryNotifier(ref, query));

class SubCategoryNotifier extends StateNotifier<AsyncValue<List<SubCategory>>> {
  SubCategoryNotifier(this.ref, this.query) : super(AsyncValue.loading()) {
    get();
  }

  final Ref ref;
  final String? query;

  Future<void> get() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CatSub().getSUb(query));
  }
}

final ImagePickerProvider = StateNotifierProvider<ImagePickerNotifier, XFile?>(
  (ref) => ImagePickerNotifier(),
);

class ImagePickerNotifier extends StateNotifier<XFile?> {
  ImagePickerNotifier() : super(null);

  Future<bool> requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;

      if (status.isGranted) return true;

      final result = await Permission.camera.request();

      if (result.isGranted) return true;

      if (result.isPermanentlyDenied == true) {
        return openAppSettings();
      }

      return false;
    } else {
      if (Platform.isAndroid) {
        final status = await Permission.storage.status;

        if (status.isGranted) return true;

        final result = await Permission.storage.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          return openAppSettings();
        }
        return false;
      } else {
        final status = await Permission.photos.status;

        if (status.isGranted) return true;

        final result = await Permission.photos.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          return openAppSettings();
        }
        return false;
      }
    }
  }

  Future<void> onPickImage(ImageSource source) async {
    if (!await requestPermission(source)) return;

    final picked = await ImagePicker().pickImage(source: source);

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      maxHeight: 800,
      maxWidth: 800,
      uiSettings: [
        IOSUiSettings(title: 'Crop Image'),
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
      ],
    );

    if (cropped == null) return;

    state = XFile(cropped.path);
  }
}
