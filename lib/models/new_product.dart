class NewProduct{

  String? id;
  String? name;
  String? image;
  double? price;
  double? discount;
  String? info;
  int quantity =0;
  String myimage='';
  int img_id = 0;

  NewProduct(this.id,this.name,this.image,this.price,this.discount,this.info,this.quantity,this.myimage,this.img_id);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    return data;
  }

  NewProduct.fromJson(Map<String, dynamic> json) {
    //this.id       = json['id'];
    this.name     = json['name'];
    this.image    = json['image'];
    this.quantity = json['quantity'];
  }
}