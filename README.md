# Scroll Restoration

- Inspired by [scroll_restore](https://pub.dev/packages/scroll_restore)

## Features

Automatically saves and restores the scroll position of any scrollable widget.

## Usage

Wrap your scrollable in ScrollRestoration, giving it a unique id:

```dart
class MyScreen extends StatelessWidget {
  List<String> get items => List.generate(200, (i) => '$i');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: ScrollRestoration(
        id: 'my_restorable_list_id',  // unique key per scrollable
        builder: (context, controller) {
          return ListView.builder(
            controller: controller,
            itemCount: items.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Text(items[index]),
              );
            },
          );
        },
      ),
    );
  }
}
```
