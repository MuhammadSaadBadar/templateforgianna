import "package:flutter/material.dart";
import "package:visibility_detector/visibility_detector.dart";

import "app.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Make scroll-reveal animations feel responsive.
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 100);
  runApp(const PortfolioApp());
}
