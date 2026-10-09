/// Helpers that turn ONE Cloudinary video link into a full video, a short
/// preview loop and a poster image, using Cloudinary URL transformations.
/// Non-Cloudinary links (any direct .mp4 URL) are passed through unchanged.
class Cloudinary {
  const Cloudinary._();

  static const _marker = "/video/upload/";

  static bool isCloudinary(String url) =>
      url.contains("res.cloudinary.com") && url.contains(_marker);

  static String _insert(String url, String transformation) =>
      url.replaceFirst(_marker, "$_marker$transformation/");

  /// Optimised full video (auto quality, MP4).
  static String full(String url) =>
      isCloudinary(url) ? _insert(url, "q_auto,f_mp4") : url;

  /// First [seconds] seconds, small and light: used for hover/stage previews.
  static String preview(String url, {int seconds = 8, int width = 640}) =>
      isCloudinary(url)
      ? _insert(url, "du_$seconds,w_$width,q_auto,f_mp4")
      : url;

  /// A JPG frame taken from the video. Empty string if not a Cloudinary link.
  static String poster(String url, {int width = 1280, int atSecond = 1}) {
    if (!isCloudinary(url)) return "";
    final withTransform = _insert(url, "so_$atSecond,w_$width,q_auto,f_jpg");
    return withTransform.replaceFirst(RegExp(r"\.[A-Za-z0-9]+$"), ".jpg");
  }
}
