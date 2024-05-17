import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_files_viewer/system_files_viewer.dart';

class DirectoryTile extends StatelessWidget {
  const DirectoryTile({
    super.key,
    required this.directory,
    this.isSelected = false,
    this.onLongPress,
    this.onPressed,
  });

  final Directory directory;
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
                  Icons.folder,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    FileUtils.getCurrentPath(directory, directory.path),
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
