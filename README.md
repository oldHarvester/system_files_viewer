# system_files_viewer

A package that allows navigating between directories within the application.

## SystemFilesViewer

A `class` that allows calling methods to navigate to `Directory` or `File` details.

```dart
final directory = await getApplicationDocumentsDirectory();
SystemFilesViewer.openDirectoryPage(
    context: context,
    directory: directory,
);

final file = File('file_path');
SystemFilesViewer.openFileDetailsPage(
    context: context,
    file: file,
);
```

You can also use `DirectoryPage` to access `Directory` or `FileDetailsPage` to access `File`

```dart
Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DirectoryPage(
                      directory: directory,
                    );
                  },
                ),
              );

Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FileDetailsPage(
                      file: file,
                    );
                  },
                ),
              );
```
