import 'package:flutter_starter/models/url_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class StorageController extends GetxController {
  final box = GetStorage();
  RxBool isDataLoaded = false.obs;
  UrlModelList _urlModelList = UrlModelList(urls: []); // Initialize with empty UrlModelList


  Future<void> initStorage() async {
    await GetStorage.init();
  }

  UrlModelList get urlModelList { // Getter for urlModelList
    if (!isDataLoaded.value) {
      _urlModelList = restoreUrlModelList();
    }
    return _urlModelList;
  }

  int get length {
    if (!isDataLoaded.value) {
      _urlModelList = restoreUrlModelList();
    }
    return _urlModelList.urls.length;
  }

  bool get isEmpty {
    //if (!isDataLoaded.value) {
   //   _urlModelList = restoreUrlModelList();
   // }
    return _urlModelList.urls.isEmpty;
  }

  void storePriceModel(UrlModel model) {
    box.write('model', model.toMap());
  }

  UrlModel restoreModel() {
    final map = box.read('model') ?? {};
    return UrlModel.fromMap(map);
  }

  void storeUrlModelList(UrlModelList urls) {
    final map = urls.toMap();
    box.write('urlList', map);
  }

  UrlModelList restoreUrlModelList() {
    final map = box.read('urlList') ?? {}; // Read the stored data from GetStorage
    final List<Map<String, dynamic>> dataList = (map['urls'] ?? []) as List<Map<String, dynamic>>;
    _urlModelList = UrlModelList.fromList(dataList); // Initialize UrlModelList with dataList
    isDataLoaded.value = _urlModelList.isNotEmpty;
    return _urlModelList;
  }
  /////////////TEST////////////////
  void createAndStoreTestData() {
    // Create test UrlModel objects
    UrlModel urlModel1 = UrlModel(
      uid: '1',
      email: 'test1@example.com',
      name: 'Test 1',
      url: 'https://example.com/test1',
      imageUrl: 'https://example.com/images/test1.jpg',
      address: 'Test Address 1',
      quality: 5,
      distance: 10,
      value: 8,
      size: 500,
      note: 'Test Note 1',
      features: 'Test Features 1',
      phoneNumber: '1234567890',
      price: '10 USD',
      category: 'Test Category 1',
    );

    UrlModel urlModel2 = UrlModel(
      uid: '2',
      email: 'test2@example.com',
      name: 'Test 2',
      url: 'https://example.com/test2',
      imageUrl: 'https://example.com/images/test2.jpg',
      address: 'Test Address 2',
      quality: 3,
      distance: 15,
      value: 6,
      size: 250,
      note: 'Test Note 2',
      features: 'Test Features 2',
      phoneNumber: '9876543210',
      price: '20 USD',
      category: 'Test Category 2',
    );

    UrlModel urlModel3 = UrlModel(
      uid: '3',
      email: 'test3@example.com',
      name: 'Test 3',
      url: 'https://example.com/test3',
      imageUrl: 'https://example.com/images/test3.jpg',
      address: 'Test Address 3',
      quality: 4,
      distance: 20,
      value: 7,
      size: 400,
      note: 'Test Note 3',
      features: 'Test Features 3',
      phoneNumber: '4561237890',
      price: '15 USD',
      category: 'Test Category 3',
    );

    // Create UrlModelList with test data
    UrlModelList testDataList = UrlModelList(urls: [urlModel1, urlModel2, urlModel3]);

    // Store the UrlModelList
    storeUrlModelList(testDataList);
  }
}