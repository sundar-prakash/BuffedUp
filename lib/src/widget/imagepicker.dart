import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<XFile?> pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 30,
  );
  return pickedFile;
}
