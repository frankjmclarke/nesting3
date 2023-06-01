import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/storage_controller.dart';
import '../controllers/url_controller.dart';
import '../models/url_model.dart';
import 'edit_text_ui.dart';

class WebviewUI extends StatefulWidget {
  final UrlModel urlModel;
  final UrlController urlController;

  WebviewUI({required this.urlModel, required this.urlController});

  @override
  State<WebviewUI> createState() => _WebviewUIState();
}

class _WebviewUIState extends State<WebviewUI> {
  late final WebViewController _webViewController;
  final StorageController _storageController = Get.find<StorageController>();
  var loadingPercentage = 0;

  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.urlModel.url),
      );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> canceledFields = [];

  Map<String, String> createEmptyMap() {
    return {
      'All items': '07hVeZyY2PM7VK8DC5QX',
    };
  }

  void deleteItem(int index) {
    _storageController.delete(index);
  }

  void editItem(UrlModel url){
    Get.to(() =>EditTextUI( urlModel: url, urlController: widget.urlController));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored List'),
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteItem(0);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              editItem(widget.urlModel);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: WebViewWidget(
              controller: _webViewController,
            ),
          ),
        ],
      ),
    );
  }
}
