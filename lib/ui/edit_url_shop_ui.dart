import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/url_controller.dart';
import '../models/url_model.dart';

class EditUrlShopUI extends StatefulWidget {
  final UrlModel urlModel;
  final UrlController urlController;

  EditUrlShopUI({required this.urlModel, required this.urlController});

  @override
  State<EditUrlShopUI> createState() => _WebViewAppState();
}
class _WebViewAppState extends State<EditUrlShopUI> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
class _EditUrlShopUIState extends State<EditUrlShopUI> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    try {
      controller = WebViewController()
        ..loadRequest(
          Uri.parse('https://flutter.dev'),
        );

      /* Load the URL
      final uri = Uri.parse(widget.urlModel.url);
      if (uri.scheme != null && uri.host != null) {
        controller.loadRequest(uri);
        print("!!!!!!!!!!!!!" +widget.urlModel.url);
      } else {
        throw Exception('Invalid URL');
      }*/
    } catch (e) {
      print('Error loading URL: $e');
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Url'),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
