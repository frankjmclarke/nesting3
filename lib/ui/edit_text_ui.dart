import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/category_controller.dart';
import '../controllers/url_controller.dart';
import '../models/url_model.dart';

class EditTextUI extends StatefulWidget {
  final UrlModel urlModel;
  final UrlController urlController;

  EditTextUI({required this.urlModel, required this.urlController});

  @override
  State<EditTextUI> createState() => _EditTextUIState();
}

class _EditTextUIState extends State<EditTextUI> {
  late final WebViewController controller;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  String selectedCategory = 'Category A';
  List<Map<String, String>> categoryList = [];

  @override
  void initState() {
    super.initState();
    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              // loadingPercentage = 0;
            });
          },
          onPageFinished: (url) {
            setState(() {
              //  loadingPercentage = 100;
            });
          },
        ));

      // Load the URL
      final uri = Uri.parse(widget.urlModel.url);
      if (uri.scheme != null && uri.host != null) {
        controller.loadRequest(uri);
        print("!!!!!!!!!!!!!" +widget.urlModel.url);
      } else {
        throw Exception('Invalid URL');
      }
    } catch (e) {
      print('Error loading URL: $e');
      // Handle the error (e.g., show an error message)
    }
    _addressController = TextEditingController(text: widget.urlModel.address);
    _priceController = TextEditingController(text: widget.urlModel.price);
    _phoneController = TextEditingController(text: widget.urlModel.phoneNumber);
    _emailController = TextEditingController(text: widget.urlModel.email);
    _nameController = TextEditingController(text: widget.urlModel.name);
    _noteController = TextEditingController(text: widget.urlModel.note);
    _priceController.addListener(_onUrlChanged);

    categoryList = CategoryController.to.getCategories();
    selectedCategory = (categoryList.isNotEmpty ? categoryList[0]['title']! : null)!;
  }


  @override
  void dispose() {
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onUrlChanged() {
    setState(() {
      //  controller.loadRequest(_urlController.text as Uri);
    });
  }
  List<String> canceledFields = [];

  Future<void> _saveChanges() async {
    // All fields have values, save changes
    String? cat = getUidFromName(selectedCategory);
    UrlModel updatedUrlModel = UrlModel(
      uid: widget.urlModel.uid,
      email: _emailController.text.trim(),
      name: _nameController.text.trim(),
      url: widget.urlModel.url,
      imageUrl: widget.urlModel.imageUrl,
      address: '',
      quality: 0,
      distance: 0,
      value: 0,
      size: 0,
      note: _noteController.text.trim(),
      features: '',
      phoneNumber: _phoneController.text.trim(),
      price: _priceController.text.trim(),
      category: cat != null ? cat : '',
    );
    if (widget.urlController.saveChanges(updatedUrlModel)) {
      Get.back();
    }
  }

  String? getValueFromKey(String key) {
    Map<String, String>? map = categoryList.firstWhereOrNull((map) => map.containsKey(key));
    return map != null ? map[key] : null;
  }

  Map<String, String> createEmptyMap() {
    return {
      'All items': '07hVeZyY2PM7VK8DC5QX',
    };
  }

  String? getUidFromName(String aname) {
    final category = categoryList.firstWhere((category) => category['title'] == aname, orElse: () => createEmptyMap());
    return category != null ? category['uid'] : null;
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price:'),
                    TextFormField(
                      controller: _priceController,
                    ),
                    SizedBox(height: 16.0),
                    Text('Phone:'),
                    TextFormField(
                      controller: _phoneController,
                    ),
                    SizedBox(height: 16.0),
                    Text('Email:'),
                    TextFormField(
                      controller: _emailController,
                    ),
                    Text('Name:'),
                    TextFormField(
                      controller: _nameController,
                    ),
                    Text('Address:'),
                    TextFormField(
                      controller: _addressController,
                    ),
                    SizedBox(height: 16.0),
                    Text('Category:'),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categoryList.map<DropdownMenuItem<String>>((Map<String, String> category) {
                        return DropdownMenuItem<String>(
                          value: category['title']!,
                          child: Text(category['title']!),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
