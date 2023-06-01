import 'package:flutter/material.dart';
import 'package:flutter_starter/ui/webview_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/controllers/storage_controller.dart';
import 'package:flutter_starter/models/url_model.dart';
import '../controllers/url_controller.dart';
import 'edit_url_ui.dart';

class StoredListUI extends StatelessWidget {
  final StorageController _storageController = Get.find<StorageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored List'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Second icon
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
        ], // Add your desired icon here
      ),
      body: Column(
        children: [
          GetBuilder<StorageController>(
            init: _storageController,
            builder: (_) {
              _storageController
                  .restoreUrlModelList(); // Reload the stored data
              if (_storageController.isEmpty) {
                _storageController
                    .createAndStoreTestData(); // Create and store test data
                return Center(
                  child: Text('No data stored. Test data created.'),
                );
              }
              return SizedBox.shrink();
            },
          ),
          GetBuilder<StorageController>(
            init: _storageController,
            builder: (_) {
              if (_storageController.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return CardItem(storageController: _storageController);
            },
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  const CardItem({
    Key? key,
    required this.storageController,
  }) : super(key: key);

  final StorageController storageController;

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  late List<RxBool> selectedList;
  final UrlController urlController = Get.put(UrlController());

  @override
  void initState() {
    super.initState();
    selectedList = List.generate(
      widget.storageController.length,
      (_) => RxBool(false),
    );
  }

  void _editUrlModel(UrlModel urlModel) {
    Get.to(//SHOP
        () => WebviewUI(urlModel: urlModel, urlController: urlController));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.storageController.length,
        itemBuilder: (context, index) {
          UrlModel urlModel = widget.storageController.urlModelList.urls[index];
          return InkWell(
            onTap: () {
              setState(() {
                _editUrlModel(urlModel);
              });
            },
            child: Card(
              color: selectedList[index].value ? Colors.blue : null,
              child: ListTile(
                leading: SizedBox(
                  height: 96,
                  width: 96.0, // Set the width equal to the height of the card
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      // Adjust the border radius as needed
                      bottomLeft: Radius.circular(4.0),
                    ),
                    child: Image.network(
                      urlModel.imageUrl,
                      fit: BoxFit.cover, // Crop and center the image
                      errorBuilder: (context, error, stackTrace) {
                        // Handle image loading error
                        return Center(
                          child: Text('Image not found'),
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  urlModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  urlModel.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
