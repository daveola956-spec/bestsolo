import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef DeferredWidgetBuilder = Widget Function();

class DeferredWidget extends StatefulWidget {
  final LibraryLoader loader;
  final DeferredWidgetBuilder builder;
  final Widget? placeholder;

  const DeferredWidget({
    super.key,
    required this.loader,
    required this.builder,
    this.placeholder,
  });

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  bool _isLoaded = false;
  Future<void>? _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = widget.loader().then((_) {
      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded) {
      return widget.builder();
    }
    return widget.placeholder ??
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1FAF5A),
          ),
        );
  }
}
