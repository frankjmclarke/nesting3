import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/url_controller.dart';
import '../models/url_model.dart';

class EditUrlShopUI extends StatefulWidget {
  final UrlModel urlModel;
  final UrlController urlController;

  EditUrlShopUI({required this.urlModel, required this.urlController});

  @override
  State<EditUrlShopUI> createState() => _EditUrlShopUIState();
}


class _EditUrlShopUIState extends State<EditUrlShopUI> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.urlModel.url),
      );
  }

  //garbage test code
  Future<void> _fetchHtmlText() async {
    try {
    } catch (error) {
      print('Error fetching HTML: $error');
    }
  }

  @override
  void dispose() {

    super.dispose();
  }

  void _onUrlChanged() {
    setState(() {
      //  controller.loadRequest(_urlController.text as Uri);
    });
  }
  List<String> canceledFields = [];

  Future<void> _saveChanges() async {
    // Validate if all fields have values


    // All fields have values, save changes

    UrlModel updatedUrlModel = UrlModel(
      uid: widget.urlModel.uid,
      email: "_emailController.text.trim()",
      name: "_nameController.text.trim()",
      url: widget.urlModel.url,
      imageUrl: widget.urlModel.imageUrl,
      address: '',
      quality: 0,
      distance: 0,
      value: 0,
      size: 0,
      note: "_noteController.text.trim()",
      features: '',
      phoneNumber: "_phoneController.text.trim()",
      price: "_priceController.text.trim()",
      category: "cat != null ? cat : ''",
    );
    if (widget.urlController.saveChanges(updatedUrlModel)) {
      Get.back();
    }
  }


  Map<String, String> createEmptyMap() {
    return {
      'All items': '07hVeZyY2PM7VK8DC5QX',
    };
  }



  Future<void> _showInputDialog(BuildContext context, String fieldName, TextEditingController controller) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter $fieldName'),
          content: TextFormField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                canceledFields.add(fieldName);
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (controller.text.isNotEmpty) {
                  _saveChanges();
                  Get.back();
                } else {
                  _showInputDialog(context, fieldName, controller);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Url'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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