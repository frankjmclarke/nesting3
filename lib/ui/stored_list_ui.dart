import 'package:flutter/material.dart';
import 'package:flutter_starter/ui/webview_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_starter/controllers/storage_controller.dart';
import 'package:flutter_starter/models/url_model.dart';
import 'package:sizer/sizer.dart';
import '../controllers/url_controller.dart';

class StoredListUI extends StatelessWidget {
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

  void _editUrlModel(UrlModel urlModel) {//SHOP
    Get.to(() => WebviewUI(urlModel: urlModel, urlController: urlController));
  }

  Future<void> _deleteUrlModel(int index) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      widget.storageController.delete(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    double min = 95.h;
    var max = screenHeight / 6;
    if (max < min) {
      max = min;
    }
    return Expanded(
      child: ListView.builder(
        itemCount: widget.storageController.length,
        itemBuilder: (context, index) {
          UrlModel urlModel = widget.storageController.urlModelList.urls[index];
          return InkWell(
            onTap: () {
              setState(() {
               // _editUrlModel(urlModel);
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.94,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                color: Colors.white70,
                elevation: 10,
                child: Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 33.w,//MediaQuery.of(context).size.width * 0.28,
                              maxHeight: 33.h,//MediaQuery.of(context).size.width * 0.28,
                            ),
                            child: Image.network(
                              urlModel.imageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  urlModel.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  urlModel.note,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 5.0,
                      child: GestureDetector(
                        onTap: () {
                          _editUrlModel(urlModel);
                        },
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                        ),
                      ),
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
