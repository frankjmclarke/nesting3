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
              if (_storageController.isEmpty) {
                _storageController.createAndStoreTestData(); // Create and store test data
                _storageController.restoreUrlModelList(); // Reload the stored data
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
              if (!_storageController.isDataLoaded.value) {
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

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required StorageController storageController,
  }) : _storageController = storageController;

  final StorageController _storageController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: _storageController.length,
        itemBuilder: (context, index) {
          UrlModel urlModel = _storageController.urlModelList.urls[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(urlModel.imageUrl),
            ),
            title: Text(urlModel.name),
            subtitle: Text(urlModel.address),
            onTap: () {
              // Handle onTap event
            },
          );
        },
      ),
    );
  }
}
