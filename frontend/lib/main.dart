// Main Entry Point
// Purpose: Application bootstrap and initialization.
// Usage: Entry point for Flutter web application.
// Expected: App initialization, dependency injection setup, MaterialApp run.

import 'package:flutter/material.dart';
import 'app.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await initializeDependencies();
  
  runApp(const BestSoloApp());
}