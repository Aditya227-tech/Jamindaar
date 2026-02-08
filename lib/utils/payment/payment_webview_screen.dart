//
// ignore_for_file: depend_on_referenced_packages

import 'package:ebroker/exports/main_export.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    required this.url,
    required this.gateway,
    super.key,
  });

  final String url;
  final String gateway;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _initializeWebView();
    });
  }

  Future<void> _initializeWebView() async {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          // Optional: Log or handle start
        },
        onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        },
        onWebResourceError: (WebResourceError error) {
          // Handle resource errors if necessary
        },
        onUrlChange: (UrlChange change) {
          _handleUrlChange(change.url);
        },
      ),
    );
    // Enable debugging for Android
    if (controller.platform is AndroidWebViewController) {
      await AndroidWebViewController.enableDebugging(true);
      await (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    await controller.loadRequest(Uri.parse(widget.url));
    _controller = controller;
  }

  void _handleUrlChange(String? urlString) {
    if (urlString == null) return;
    final uri = Uri.parse(urlString);

    // Logic based on previous gateway implementations
    // PayPal: HOST/app_payment_status?error=false&PayerID=...
    // Flutterwave: HOST/flutterwave-payment-status?status=successful...
    // We can also look for general "success" or "fail" indicators if we want to be generic,
    // but mimicking the exact behavior is safer as per prompt.

    // Check if it's a redirect to our own backend
    // Assuming backend returns success/fail on specific paths or query params

    // Using a more generic approach coupled with specific checks finding in previous code
    final isBackendHost = uri.host == Uri.parse(Constant.baseUrl).host;

    if (isBackendHost ||
        widget.gateway.toLowerCase() == 'paypal' ||
        widget.gateway.toLowerCase() == 'flutterwave') {
      if (urlString.contains('app_payment_status')) {
        // PayPal Logic
        final error = uri.queryParameters['error'];
        final payerId = uri.queryParameters['PayerID'];
        if (error == 'false' && payerId != null) {
          Navigator.pop(context, true); // Success
        } else {
          Navigator.pop(context, false); // Fail
        }
      } else if (urlString.contains('flutterwave-payment-status')) {
        // Flutterwave Logic
        final status = uri.queryParameters['status'];
        if (status == 'successful') {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
      } else if (urlString.contains('success') ||
          uri.queryParameters['status'] == 'success') {
        // General Fallback
        Navigator.pop(context, true);
      } else if (urlString.contains('fail') ||
          uri.queryParameters['status'] == 'failed') {
        // General Fallback
        Navigator.pop(context, false);
      }
    }
  }

  Future<void> _handleBackPress() async {
    final now = DateTime.now();
    final timeDifference = _lastBackPressTime == null
        ? const Duration(seconds: 3)
        : now.difference(_lastBackPressTime!);

    if (timeDifference > const Duration(seconds: 2)) {
      // First back press - show warning toast
      _lastBackPressTime = now;
      await Fluttertoast.showToast(
        msg:
            'If you go back, payment will be cancelled. Press back again to exit.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      // Second back press within 2 seconds - exit with false (payment cancelled)
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.gateway.toUpperCase(),
          showBackButton: false,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: context.color.tertiaryColor,
                ),
              )
            : WebViewWidget(controller: _controller),
      ),
    );
  }
}
