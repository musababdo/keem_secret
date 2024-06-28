import 'package:panorama_home/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier{

  List<Product> products=[];
  int? qua;
  String? image,mimage,mname,mprice;
  int? img_id;
  addProduct(Product product,int qu){
    products.add(product);
    qua=qu;
    notifyListeners();
  }
  addProductwithImage(Product product,int qu,String img,int myid){
    products.add(product);
    qua=qu;
    image=img;
    img_id=myid;
    notifyListeners();
  }

  addNew(String name,String price,int qu,String img,int myid){
    mname = name;
    mprice = price;
    qua=qu;
    image=img;
    img_id=myid;
    notifyListeners();
  }

  deleteProduct(Product product) {
    products.remove(product);
    notifyListeners();
  }

  deleteAll(){
    products.clear();
    notifyListeners();
  }

}