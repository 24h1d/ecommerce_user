import 'package:ecom_user/db/db_helper.dart';
import 'package:ecom_user/models/order_constant_model.dart';
import 'package:flutter/widgets.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();

  getOrderConstants() {
    DbHelper.getOrderSnapshots().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
      }
    });
  }

  Future<void> updateOrderConstants(OrderConstantModel model) {
    return DbHelper.updateOrderConstants(model);
  }
}
