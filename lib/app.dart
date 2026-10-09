import "package:flutter/material.dart";

import "config/site_config.dart";
import "core/app_theme.dart";
import "pages/home_page.dart";

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: "${siteConfig.editor.name} | Video Editor",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.mode,
        home: const HomePage(),
      ),
    );
  }
}
