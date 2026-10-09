import "package:url_launcher/url_launcher.dart";

/// Opens http(s), mailto: or tel: links. Ignores empty or placeholder ("#") links.
Future<void> openLink(String url) async {
  if (url.isEmpty || url == "#") return;
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
