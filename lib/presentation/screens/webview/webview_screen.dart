import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:big_boss_fishing/core/theme/app_colors.dart';
import 'package:big_boss_fishing/core/theme/text_styles.dart';

/// WebView Screen for displaying web content in-app
class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.heading5.copyWith(
            color: AppColors.textLight,
          ),
        ),
        bottom: _progress < 1.0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: AppColors.deepNavy,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.bossAqua),
                ),
              )
            : null,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
        initialSettings: InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllow: "camera; microphone",
          iframeAllowFullscreen: true,
        ),
        onLoadStart: (controller, url) {
          setState(() {
            _progress = 0;
          });
        },
        onProgressChanged: (controller, progress) {
          setState(() {
            _progress = progress / 100;
          });
        },
        onLoadStop: (controller, url) {
          setState(() {
            _progress = 1.0;
          });
        },
        onReceivedError: (controller, request, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load page: ${error.description}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
      ),
    );
  }
}
