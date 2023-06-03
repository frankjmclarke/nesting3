import 'package:flutter_starter/models/url_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class StorageController extends GetxController {
  final box = GetStorage();

  final Rx<UrlModelList> _urlModelList = UrlModelList(urls: []).obs;
  final RxInt _selectedIndex = RxInt(-1);

  RxBool isDataLoaded = false.obs;

  int get selectedIndex => _selectedIndex.value;
  void setSelectedIndex(int index) {
    _selectedIndex.value = index;
  }

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  UrlModelList get urlModelList => _urlModelList.value;

  int get length => _urlModelList.value.length;

  bool get isEmpty => _urlModelList.value.length == 0;

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

  Rx<UrlModelList> restoreUrlModelList() {
    final map = box.read('urlList') ?? {};
    final List<Map<String, dynamic>> urlMaps = (map['urls'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>() // Cast the List<dynamic> to List<Map<String, dynamic>>
        ?? []; // Set default value to an empty list if map['urls'] is null
    _urlModelList.value = UrlModelList.fromList(urlMaps);
    isDataLoaded.value = length > 0;
    return _urlModelList;
  }

  void delete(int index) {
    _urlModelList.update((urlModelList) {
      urlModelList?.urls.removeAt(index);
    });
    storeUrlModelList(_urlModelList.value);
    update(); // Notify listeners of the changes
  }

  void empty() {
    _urlModelList.value = UrlModelList(urls: []);
  }
  /////////////TEST////////////////
  void createAndStoreTestData() {
    // Create test UrlModel objects
    UrlModel urlModel1 = UrlModel(
      uid: '1',
      email: 'test1@example.com',
      name: 'Gibson Les Paul Cherry Sunburst Classic',
      url: 'https://vancouver.craigslist.org/rds/msg/d/white-rock-gibson-les-paul-cherry/7625381420.html',
      imageUrl: 'https://images.craigslist.org/00404_a72iXCulVC_0CI0t2_600x450.jpg',
      address: 'Test Address 1',
      quality: 5,
      distance: 10,
      value: 8,
      size: 500,
      note: 'White Rock',
      features: 'Test Features 1',
      phoneNumber: '1234567890',
      price: '2,100',
      category: 'Test Category 1',
    );

    UrlModel urlModel2 = UrlModel(
      uid: '2',
      email: 'test2@example.com',
      name: 'Novelty Place Drinking Helmet - Can Holder Drinker Hat Cap',
      url: 'https://www.amazon.ca/Novelty-Place-Guzzler-Drinking-Helmet/dp/B01KHOQ26Y/ref=sr_1_7?crid=M5UP0WKLWSF5&keywords=beer+hat&qid=1685665693&sprefix=beer+hat%2Caps%2C157&sr=8-7',
      imageUrl: 'https://m.media-amazon.com/images/I/61bukzq027L._AC_SL1500_.jpg',
      address: 'Test Address 2',
      quality: 3,
      distance: 15,
      value: 6,
      size: 250,
      note: ' Novelty Place Drinking Helmet - Can Holder Drinker Hat Cap with Straw for Beer and Soda - Party Fun - Red',      features: 'COOL PARTY WEAR - Just like all crazy parties you have seen in movies, Wearing this cool novelty drinking hat will bring you lots of fun!',
      phoneNumber: '9876543210',
      price: '21.95',
      category: 'My lovely folder',
    );
    UrlModel urlModel3 = UrlModel(
      uid: '3',
      email: 'test2@example.com',
      name: 'Test 2',
      url: 'https://example.com/test2',
      imageUrl: 'https://images.craigslist.org/00x0x_4Mxosrb1GCh_0CI0t2_600x450.jpg',
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
    UrlModel urlModel4 = UrlModel(
      uid: '4',
      email: 'test4@example.com',
      name: 'Test 4',
      url: 'https://example.com/test2',
      imageUrl: 'https://images.craigslist.org/00x0x_4Mxosrb1GCh_0CI0t2_600x450.jpg',
      address: 'Test Address 4',
      quality: 3,
      distance: 15,
      value: 6,
      size: 250,
      note: 'Test Note 4',
      features: 'Test Features 4',
      phoneNumber: '9876543210',
      price: '20 USD',
      category: 'Test Category 4',
    );
    UrlModel urlModel5 = UrlModel(
      uid: '5',
      email: 'test5@example.com',
      name: 'Test 5',
      url: 'https://example.com/test2',
      imageUrl: 'https://images.craigslist.org/00x0x_4Mxosrb1GCh_0CI0t2_600x450.jpg',
      address: 'Test Address 5',
      quality: 3,
      distance: 15,
      value: 6,
      size: 250,
      note: 'Test Note 2',
      features: 'Test Features 5',
      phoneNumber: '9876543210',
      price: '20 USD',
      category: 'Test Category 5',
    );

    UrlModel urlModel6 = UrlModel(
      uid: '6',
      email: 'test3@example.com',
      name: 'flutter',
      url: 'https://flutter.dev',
      imageUrl: 'https://images.craigslist.org/01212_f3nNBSut0MV_0CI0t2_600x450.jpg',
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
    UrlModelList testDataList = UrlModelList(urls: [urlModel1, urlModel2, urlModel3, urlModel4, urlModel5, urlModel6]);

    // Store the UrlModelList
    storeUrlModelList(testDataList);
  }
}