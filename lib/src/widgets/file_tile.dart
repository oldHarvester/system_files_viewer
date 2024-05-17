import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_files_viewer/system_files_viewer.dart';

class FileTile extends StatelessWidget {
  const FileTile({
    super.key,
    required this.file,
    required this.currentDirectory,
    this.onLongPress,
    this.onPressed,
    this.isSelected = false,
  });

  final File file;
  final Directory currentDirectory;
  final VoidCallback? onLongPress;
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          child: Ink(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey.shade300 : Colors.transparent,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.file_open_rounded,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    FileUtils.getCurrentPath(
                      currentDirectory,
                      file.path,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
