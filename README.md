# Scroll Restoration

- Inspired by [scroll_restore](https://pub.dev/packages/scroll_restore)

## Features

Automatically saves and restores the scroll position of any scrollable widget.

## Usage

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: ScrollRestore(
        id: 'my_restorable_list_id',  // unique key per scrollable
        builder: (context, controller) {
          return ListView.builder(
            controller: controller,
            itemCount: messages.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(messages[index].text),
              );
            },
          );
        },
      ),
    );
  }
}
```
