# best_solo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Deployment & Build

For optimal rendering performance on the web, this project uses the **CanvasKit** renderer. CanvasKit provides better graphics performance, smoother animations, and consistent text rendering across all browsers.

To build the project for production, use the following command:

```bash
flutter build web --web-renderer canvaskit
```

> [!NOTE]
> CanvasKit increases the initial download size slightly compared to HTML rendering but significantly improves the runtime experience and visual fidelity for complex UIs like the BEST SOLO dashboard.
