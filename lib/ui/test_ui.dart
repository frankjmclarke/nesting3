import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/controllers/storage_controller.dart';
import 'package:flutter_starter/models/url_model.dart';

class StoredListScreen extends StatelessWidget {
  final StorageController _storageController = Get.find<StorageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored List'),
      ),
      body: Column(
        children: [
          GetBuilder<StorageController>(
            init: _storageController,
            builder: (_) {
              _storageController.restoreUrlModelList(); // Reload the stored data
              if (_storageController.isEmpty) {
                _storageController.createAndStoreTestData(); // Create and store test data
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

  @override
  void initState() {
    super.initState();
    selectedList = List.generate(
      widget.storageController.length,
          (_) => RxBool(false),
    );
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
                for (int i = 0; i < selectedList.length; i++) {
                  selectedList[i].value = i == index;
                }
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Handle edit action
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
