import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_files_viewer/src/pages/directory_page.dart';
import 'package:system_files_viewer/src/pages/file_details_page.dart';

export 'package:system_files_viewer/src/pages/directory_page.dart';
export 'package:system_files_viewer/src/pages/file_details_page.dart';
export 'package:system_files_viewer/src/utils/file_utils.dart';
export 'package:system_files_viewer/src/widgets/directory_file.dart';
export 'package:system_files_viewer/src/widgets/file_tile.dart';

class SystemFilesViewer {
  static Future<T?> openDirectoryPage<T>(
      {required BuildContext context, required Directory directory}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DirectoryPage(directory: directory);
        },
      ),
    );
  }

  static Future<T?> openFileDetailsPage<T>({
    required BuildContext context,
    required File file,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FileDetailsPage(file: file);
        },
      ),
    );
  }
}
