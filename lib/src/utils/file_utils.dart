import 'dart:io';

class FileUtils {
  static String getCurrentPath(Directory directory, String path) {
    final pathSegments = path.split('/');
    final includedDirectories = <String>[];
    var findDirectory = false;
    final directoryName = directory.path.split('/').last;

    if (directory.path == path) {
      return directoryName;
    }

    for (final path in pathSegments) {
      if (findDirectory) {
        includedDirectories.add(path);
      }
      if (path == directoryName) {
        findDirectory = true;
      }
    }

    return includedDirectories.join('/');
  }
}
