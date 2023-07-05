import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isHoldingContainer = false;
  OverlayEntry? floatingContentOverlayEntry;

  @override
  void initState() {
    super.initState();
    floatingContentOverlayEntry = createFloatingContentOverlayEntry();
  }

  OverlayEntry createFloatingContentOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 100,
          left: 50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Floating Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showFloatingContent() {
    Overlay.of(context).insert(floatingContentOverlayEntry!);
  }

  void hideFloatingContent() {
    floatingContentOverlayEntry?.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: GestureDetector(
        onLongPress: () {
          setState(() {
            isHoldingContainer = true;
            showFloatingContent();
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            isHoldingContainer = false;
            hideFloatingContent();
          });
        },
        child: Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: const Text('Hold to Show Floating Content'),
        ),
      ),
    );
  }
}
