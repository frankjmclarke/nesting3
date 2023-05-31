import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/string_util.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Rxn<CategoryModel> firebaseCategory = Rxn<CategoryModel>();
  final Rxn<CategoryModelList> firestoreCategoryList = Rxn<CategoryModelList>();

  final RxBool admin = false.obs;

  static CategoryController get to => Get.find();

  String? _uidCurrent;
  String? get uidCurrent => _uidCurrent;
  set uidCurrent(String? uidCurrent) {
    _uidCurrent = uidCurrent;
  }

  @override
  void onInit() {
    super.onInit();
    //fetchCategoryList();
  }

  @override
  void onReady() async {
    super.onReady();
    fetchCategoryList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Stream<CategoryModelList> get CategoryList => firestoreCategoryList.map(
        (CategoryList) => CategoryModelList(categories: CategoryList?.categories ?? []),
      );

  bool containsText(String text) {
    final List<CategoryModel>? CategoryList = firestoreCategoryList.value?.categories;
    if (CategoryList != null) {
      return CategoryList.any((CategoryModel) => CategoryModel.getTitle() == text);
    }
    return false;
  }

  Future<void> fetchCategoryList() async {
    try {
      final snapshot = await _db.collection('category').get();
      final cats =
          snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data())).toList();
      firestoreCategoryList.value = CategoryModelList(categories: cats);

      _db.collection('category').snapshots().listen((snapshot) {
        final cats =
            snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data())).toList();
        firestoreCategoryList.value = CategoryModelList(categories: cats);
        print("Firestore fetchCategoryList");
      });

      print("fetchCategoryList SUCCESS ");
    } catch (error) {
      print("Error fetching Category list: $error");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

// Insert a test CategoryModel into Firestore
  CategoryModel testCategory = CategoryModel(
    uid: StringUtil.generateRandomId(15),
    title: 'title',
    parent: '07hVeZyY2PM7VK8DC5QX',
    icon: 1,
    color:1,
    flag:1,
    imageUrl: 'https://cdn.onlinewebfonts.com/svg/img_259453.png',
    numItems:0,
  );

  Future<void> insertTestCategory() async {
    insertCategory(testCategory);
  }

  Future<void> insertCategoryName(String title) async {
    try {
      // Create a new category model
      CategoryModel category = CategoryModel(
        uid: StringUtil.generateRandomId(15),
        title: title,
        parent: '07hVeZyY2PM7VK8DC5QX',
        icon: 1,
        color: 1,
        flag: 1,
        imageUrl: 'https://cdn.onlinewebfonts.com/svg/img_259453.png',
        numItems: 0,
      );
      // Convert the CategoryModel to a JSON map
      Map<String, dynamic> jsonData = category.toJson();
      // Insert the new category into Firestore
      await _db.collection('category').doc(category.uid).set(jsonData);
      print('New category inserted successfully');
    } catch (error) {
      print('Error inserting new category: $error');
    }
  }

  Future<void> insertCategory(CategoryModel testCategory) async {
    try {
      // Convert the CategoryModel to a JSON map
      Map<String, dynamic> jsonData = testCategory.toJson();

      // Insert the test CategoryModel into Firestore
      await _db.collection('category').doc(testCategory.uid).set(jsonData);

      print('Test Category inserted successfully');
    } catch (error) {
      print('Error inserting test Category: $error');
    }
  }

  Future<void> deleteCategory(CategoryModel CategoryModel) async {
    try {
      // Delete the CategoryModel from Firestore
      await _db.collection('category').doc(CategoryModel.uid).delete();
      print('CategoryModel deleted successfully');
    } catch (error) {
      print('Error deleting CategoryModel: $error');
    }
  }

  Future<void> updateCategory(CategoryModel updatedCategory) async {
    try {
      // Convert the updated CategoryModel to a JSON map
      final jsonData = updatedCategory.toJson();

      // Update the Category document in Firestore
      await _db.collection('category').doc(updatedCategory.uid).update(jsonData);

      print('Category updated successfully!');
    } catch (error) {
      print('Error updating Category: $error');
    }
  }

  bool saveChanges(CategoryModel updatedCategoryModel) {
    if (updatedCategoryModel.title.isEmpty) {
      // Display an error message or show a snackbar indicating missing fields
      return false;
    }
    updateCategory(updatedCategoryModel);
    return true;
  }

  void saverChanges(CategoryModel updatedCategoryModel) async {
    try {
      // Convert the updated CategoryModel to a JSON map
      final jsonData = updatedCategoryModel.toJson();

      // Update the Category document in Firestore
      await _db.collection('category').doc(updatedCategoryModel.uid).update(jsonData);

      print('Category updated successfully');
    } catch (error) {
      print('Error updating Category: $error');
    }
  }

  void updateNumItems(String uid, int items) {
    final List<CategoryModel>? categoryList = firestoreCategoryList.value?.categories;
    if (categoryList != null) {
      final int index = categoryList.indexWhere((category) => category.uid == uid);
      if (index != -1) {
        CategoryModel updatedCategory = categoryList[index];
        updatedCategory = updatedCategory.copyWith(numItems: items);
        categoryList[index] = updatedCategory;
        firestoreCategoryList.value = CategoryModelList(categories: categoryList);
        updateCategory(updatedCategory);
      }
    }
  }

  void incrementNumItems(int itemsToAdd) {
    final CategoryModelList currentList = firestoreCategoryList.value ?? CategoryModelList(categories: []);
    for (int i = 0; i < currentList.categories.length; i++) {
      CategoryModel category = currentList.categories[i];
      CategoryModel updatedCategory = category.copyWith(numItems: category.numItems + itemsToAdd);
      currentList.categories[i] = updatedCategory;
    }
    firestoreCategoryList.value = currentList;
    updateCategoryListInFirestore(currentList);
  }

  Future<void> updateCategoryListInFirestore(CategoryModelList updatedList) async {
    try {
      final jsonData = {'category': updatedList.toMap()};
      await _db.collection('category').doc('your_document_id').update(jsonData);
      print('Category list updated successfully');
    } catch (error) {
      print('Error updating category list: $error');
    }
  }

  List<Map<String, String>> getCategories() {
    final List<CategoryModel>? categoryList = firestoreCategoryList.value?.categories;
    if (categoryList != null) {
      return categoryList
          .map((category) => {'title': category.title, 'uid': category.uid})
          .toList();
    }
    return [];
  }
}
