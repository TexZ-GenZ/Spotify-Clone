import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (filePickerRes != null) {
      final path = filePickerRes.files.single.path;
      if (path != null) {
        return File(path);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (filePickerRes != null) {
      final path = filePickerRes.files.single.path;
      if (path != null) {
        return File(path);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

String rgbToHex(Color color) {
  final red = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
  final green = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
  final blue = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');

  return '$red$green$blue';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
