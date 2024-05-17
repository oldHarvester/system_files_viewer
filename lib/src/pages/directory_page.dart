import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:system_files_viewer/system_files_viewer.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({
    super.key,
    required this.directory,
    this.onHlsPlayPressed,
  });

  final Directory directory;
  final void Function(File hlsFile)? onHlsPlayPressed;

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  bool isSelectMode = false;
  Set<int> selectedIndexes = {};
  bool selectAll = false;
  List<FileSystemEntity> directoryFiles = [];

  int? findFirstNumberInText(String text) {
    final RegExp numRegExp = RegExp(r'\d+');
    final Match? match = numRegExp.firstMatch(text);

    if (match != null) {
      return int.parse(match.group(0)!);
    } else {
      return null;
    }
  }

  int compare(FileSystemEntity a, FileSystemEntity b) {
    final firstPath = a.path.split('/').last;
    final nextPath = b.path.split('/').last;
    final firstNum = findFirstNumberInText(firstPath);
    final nextNum = findFirstNumberInText(nextPath);
    if (firstNum != null && nextNum != null) {
      return firstNum.compareTo(nextNum);
    }
    return firstPath.compareTo(nextPath);
  }

  @override
  void initState() {
    final filesOrDirectories = widget.directory.listSync();

    final directories = filesOrDirectories.whereType<Directory>().toList()
      ..sort(compare);
    final files = filesOrDirectories.whereType<File>().toList()..sort(compare);

    directoryFiles = [...directories, ...files];

    super.initState();
  }

  void onLongPress(int index) {
    if (!isSelectMode) {
      setState(() {
        isSelectMode = true;
        selectedIndexes.add(index);
      });
    }
  }

  void onSelectAll(bool select) {
    if (select) {
      selectAll = true;
      selectedIndexes = {};
      for (var i = 0; i < directoryFiles.length; i++) {
        selectedIndexes.add(i);
      }
    } else {
      selectAll = false;
      selectedIndexes = {};
    }
    setState(() {});
  }

  void onPressedInSelectMode(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  Future<void> onRemove() async {
    final sortedIndexes = selectedIndexes.toList()..sort();
    for (var i = sortedIndexes.length - 1; i >= 0; i--) {
      final index = sortedIndexes.elementAt(i);
      await directoryFiles[index].delete(recursive: true);
      directoryFiles.removeAt(index);
    }
    setState(() {
      isSelectMode = false;
      selectAll = false;
      selectedIndexes = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: isSelectMode ? false : true,
          flexibleSpace: FlexibleSpaceBar(
            background: isSelectMode
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectAll,
                            onChanged: (value) {
                              if (value != null) {
                                onSelectAll(value);
                              }
                            },
                          ),
                          Center(
                            child: Text(
                              selectedIndexes.length.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
          centerTitle: isSelectMode ? true : false,
          title: Text(
            FileUtils.getCurrentPath(widget.directory, widget.directory.path),
          ),
          actions: [
            if (isSelectMode)
              IconButton(
                onPressed: onRemove,
                icon: const Icon(
                  Icons.delete_outline_outlined,
                ),
              ),
            if (isSelectMode)
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedIndexes.clear();
                    isSelectMode = false;
                  });
                },
                icon: const Icon(Icons.cancel),
              ),
          ],
        ),
        body: ListView.builder(
          itemCount: directoryFiles.length,
          itemBuilder: (context, index) {
            final fileEntity = directoryFiles[index];
            if (fileEntity is File) {
              return FileTile(
                file: fileEntity,
                currentDirectory: widget.directory,
                isSelected: isSelectMode && selectedIndexes.contains(index),
                onLongPress: () => onLongPress(index),
                onPressed: isSelectMode
                    ? () => onPressedInSelectMode(index)
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FileDetailsPage(
                              file: fileEntity,
                              onHlsPlayPressed: () {
                                widget.onHlsPlayPressed?.call(fileEntity);
                              },
                            ),
                          ),
                        );
                      },
              );
            }
            return DirectoryTile(
              directory: fileEntity as Directory,
              isSelected: isSelectMode && selectedIndexes.contains(index),
              onLongPress: () => onLongPress(index),
              onPressed: isSelectMode
                  ? () => onPressedInSelectMode(index)
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DirectoryPage(
                            directory: fileEntity,
                            onHlsPlayPressed: widget.onHlsPlayPressed,
                          ),
                        ),
                      );
                    },
            );
          },
        ),
      ),
    );
  }
}
