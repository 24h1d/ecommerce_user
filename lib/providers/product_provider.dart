import 'dart:io';

import 'package:ecom_user/db/db_helper.dart';
import 'package:ecom_user/models/category_model.dart';
import 'package:ecom_user/models/purchase_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  Future<void> addNewCategory(String category) {
    final categoryModel = CategoryModel(categoryName: category);
    return DbHelper.addCategory(categoryModel);
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList
          .sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
      notifyListeners();
    });
  }

  List<CategoryModel> getCategoryListForFiltering() {
    return [CategoryModel(categoryName: 'All'), ...categoryList];
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(CategoryModel categoryModel) {
    DbHelper.getAllProductsByCategory(categoryModel).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> repurchase(
      PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  Future<List<PurchaseModel>> getAllPurchaseByProductId(
      String productId) async {
    final snapshot = await DbHelper.getAllPurchaseByProductId(productId);
    return List.generate(snapshot.docs.length,
        (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DbHelper.addNewProduct(productModel, purchaseModel);
  }

  Future<void> deleteImage(String downloadUrl) {
    return FirebaseStorage.instance.refFromURL(downloadUrl).delete();
  }

  Future<void> updateProductField(
      String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field: value});
  }

  void getOrderConstants() {}
}
