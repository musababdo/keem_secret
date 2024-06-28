
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/done.dart';
import 'package:panorama_home/screens/home.dart';
import 'package:panorama_home/screens/cart_screen.dart';
import 'package:panorama_home/screens/tabby_page/chechout_page.dart';
import 'package:panorama_home/screens/tamara_pages/checkouturl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:tamara_flutter_sdk/tamara_checkout.dart';
import 'package:tamara_flutter_sdk/tamara_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {

  List<Product> products = [];

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String? id,name,phone,lang,token,payment_mthod;
  int? value,food_id,quantity;
  double? price,quant;
  DateTime currentdate=new DateTime.now();
  String? formatdate;
  final formatter = new NumberFormat("###,###");
  int selectedOption = 0;
  int _state=0;
  String uid = '1';
  String country = 'uae';

  //Tabby
  String? thstatus;
  TabbySession? session;
  late Lang mylang;
   _setStatus(String newStatus) {
    setState(() {
      thstatus = newStatus;
    });
  }
  //End Tabby

  Map<String, dynamic>? paymentIntent;

  TextEditingController _username = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _area = TextEditingController();

  //String t = 'tmra';
  Future save() async{
    var url = Uri.parse('${api}order_store');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'lang': '$lang',
    };
    final data = {
      //"user_id" : id,
      "name" : _username.text,
      "phone" : _phone.text,
      "email" : _email.text,
      "total_amount" : price,
      "sub_total" : price,
      "quantity" : quant,
      "payment_method" : payment_mthod,
      "city" : _city.text,
      "area" : _area.text,
      "country" : country,
    };
    final jsonData = jsonEncode(data);
    print(jsonData);
    var response=await http.post(url,headers:headers,body: jsonData);
    final jsonresponse = json.decode(response.body);
    // var jsonresponse;
    // if(response.body.isNotEmpty) {
    //   jsonresponse = json.decode(response.body);
    // }
    // print('=====================');
    // print('order id : ${jsonresponse['order']}');
    // print('=====================');
    final Map<String, String> order_headers = {
      'Accept': 'application/json',
      'lang': '$lang',
      'order_id': jsonresponse['order'].toString(),
    };
    final apiUrl = Uri.parse('${api}order_details_store');
    //List<String> order_data = [];
    //var order_data;
    List<Map<String, dynamic>> keyValueList = [];
    for (final product in widget.products) {
      //quantity = product.quantity;
      Map<String, dynamic> keyValue = {
        'order_id': jsonresponse['order'].toString(),
        'product_id': product.id.toString(),
        'quantity': product.quantity.toString(),
      };
      keyValueList.add(keyValue);
      //order_data.add(dd);
      // order_data = {
      //   "order_id": jsonresponse['order'].toString(),
      //   "product_id": product.id.toString(),
      //   "quantity": product.quantity.toString(),
      // };
      // order_data = {
      //   "order_id" : jsonresponse['order'].toString(),
      //   //"product_id" :product.id.toString(),
      //   //"quantity" : product.quantity.toString(),
      // };
    }
      print(keyValueList);
    String incode = jsonEncode(keyValueList);
      final order_response = await http.post(
        apiUrl,
        headers: order_headers,
        body: {
        'data' : incode,
        }
        //body: json.encode(keyValueList),
        //body: jsonEncode(keyValueList),// Convert Item to JSON
      );
      // if(order_response.body.isNotEmpty) {
      //   json.decode(order_response.body);
      // }
      final myresponse = json.decode(order_response.body);
      print('=====================');
      //print('url : ${keyValueList}');
      print('myresponse : ${json.decode(order_response.body)}');
      print('=====================');
      //final Uri _url = Uri.parse(myresponse['url']);
      if (order_response.statusCode == 200) {
        // print('=====================');
        // print('myresponse : ${order_response.statusCode}');
        // print('=====================');
        // Successfully inserted item
        //print('Item ${product.id} inserted successfully');
        //Get.to(Done());
        if (selectedOption == 1) {
          showStripe();
        } else if (selectedOption == 2) {
          openInAppBrowser();
          //openCheckOutPage();
        } else if (selectedOption == 3) {
          //print('it tamara');
          //tamaraPayment(myresponse['url']);
          //launchUrl(_url);
        } else if (selectedOption == 4) {
          widget.products.clear();
          Get.to(Done());
        }
      } else {
        // Handle errors here
        //print('Failed to insert item ${product.id}');
        print('fi : ${order_response.body}');
        print(order_response.statusCode);
      }
    //widget.products.clear();
  }

  Future newsave() async{
    var url = Uri.parse('${api}order_store');
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'lang': '$lang',
    };
    List<Map<String, dynamic>> keyValueList = [];
    for (final product in widget.products) {
      Map<String, dynamic> keyValue = {
        'product_id': product.id.toString(),
        'quantity': product.quantity.toString(),
      };
      keyValueList.add(keyValue);
    }
    //print(keyValueList);
    String incode = jsonEncode(keyValueList);
    final data = {
      //"user_id" : id,
      "name" : _username.text,
      "phone" : _phone.text,
      "email" : _email.text,
      "total_amount" : price,
      "sub_total" : price,
      "quantity" : quant,
      "payment_method" : payment_mthod,
      "city" : _city.text,
      "area" : _area.text,
      "country" : country,
      "order_list" : incode,
    };
    final jsonData = jsonEncode(data);
    //print(jsonData);
    var response=await http.post(url,headers:headers,body: jsonData);
    final jsonresponse = json.decode(response.body);
    //var jsonresponse;
    if(response.body.isNotEmpty) {
      //jsonresponse = response.body;
    }
    // print('=====================');
    // print('myresponse : ${jsonresponse['checkout_url']}');
    // print('=====================');
    if (selectedOption == 1) {
      showStripe();
    } else if (selectedOption == 2) {
      //openInAppBrowser();
      openCheckOutPage();
    } else if (selectedOption == 3) {
      //print('it tamara');
      final Uri _url = Uri.parse(jsonresponse['checkout_url']);
      tamaraPayment(jsonresponse['checkout_url']);
      launchUrl(_url);
    } else if (selectedOption == 4) {
      widget.products.clear();
      Get.to(Done());
    }
  }

  SharedPreferences? preferences;
  Future getData() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      price = preferences!.getDouble("price");
      // print('=====================');
      // print(price);
      // print('=====================');
      //quantity = preferences!.getInt('quantity');
      for (final product in widget.products) {
        quantity = product.quantity;
        // print('=====================');
        // print(product.id);
        // print(product.quantity);
        // print('=====================');
      }
      // print('=====================');
      // print(quant);
      // //print(product.quantity);
      // print('=====================');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = box.read('u_id').toString();
    lang = box.read('lang');
    token = box.read('token');
    price = box.read('total');
    quant = box.read('total_quant');
    SchedulerBinding.instance.addPostFrameCallback((_) => getCurrentLang());
    _username.text = 'Ali Ahmed';
    _phone.text = '0544337766';
    _email.text = 'musab@gmail.com';
    _city.text = 'Ajman';
    _area.text = 'Ajman';
    //food_id = box.read('food_id');
    //name = box.read('username');
    //phone = box.read('phone');
    //_phone.text = box.read('phone');
    getData();
  }

  void getCurrentLang() {
    final myLocale = Localizations.localeOf(context);
    setState(() {
      mylang = myLocale.languageCode == 'ar' ? Lang.ar : Lang.en;
    });
  }

  //Tabby Payment
  Future<void> createSession() async {
    try {
      _setStatus('pending');
      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: 'PANORAMA HOMEare',
        lang: mylang,
        payment: Payment(
          amount: convertDoubleToStringForStripe(price!),
          currency: Currency.aed,
          buyer: Buyer(
            email: _email.text,
            phone: _phone.text,
            name: _username.text,
            dob: '2019-08-24',
          ),
          buyerHistory: BuyerHistory(
            loyaltyLevel: 0,
            registeredSince: '2019-08-24T14:15:22Z',
            wishlistCount: 0,
          ),
          shippingAddress: const ShippingAddress(
            city: 'string',
            address: 'string',
            zip: 'string',
          ),
          order: Order(referenceId: 'id123', items: [
            OrderItem(
              title: 'Jersey',
              description: 'Jersey',
              quantity: quant!.toInt(),
              unitPrice: '10.00',
              referenceId: 'uuid',
              productUrl: 'http://example.com',
              category: 'clothes',
            )
          ]),
          orderHistory: [
            OrderHistoryItem(
              purchasedAt: '2019-08-24T14:15:22Z',
              amount: '10.00',
              paymentMethod: OrderHistoryItemPaymentMethod.card,
              status: OrderHistoryItemStatus.newOne,
            )
          ],
        ),
      ));
      debugPrint('Session id: ${s.sessionId}');
      setState(() {
        session = s;
      });
      _setStatus('created');
      print('session open');
    } catch (e, s) {
      printError(e, s);
      _setStatus('error');
      print('session error');
    }
  }
  void openInAppBrowser() {
    TabbyWebView.showWebView(
      context: context,
      webUrl: session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultCode.name),
          ),
        );
        print('=====================');
        print('result : ${resultCode.name}');
        print('=====================');
        //Navigator.pop(context);
        if(resultCode.name=='close'){
          Get.to(Info());
        }else{
          widget.products.clear();
          Get.to(Done());
        }
      },
    );
  }
  void openCheckOutPage() {
    Navigator.pushNamed(
      context,
      TabbyCheckoutNavParams.id,
      arguments: TabbyCheckoutNavParams(
        selectedProduct: session!.availableProducts.installments!,
      ),
    );
  }
  //End of Tabby Payment

  int currentStep = 0;
  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1; //currentStep+=1;
      });
    }
  }

  //Tamara Payment
  String checkoutUrl = 'https://api-sandbox.tamara.co/checkout';
  String successUrl  = 'https://panoramahome.ae/api/success-url';
  String failedUrl   = 'https://panoramahome.ae/api/failure-url';
  String canceledUrl = 'https://panoramahome.ae/api/cancel-url';
  void tamaraPayment(String checkout){
    TamaraCheckout(
      checkout,
      successUrl,
      failedUrl,
      canceledUrl,
      onPaymentSuccess: () {
        widget.products.clear();
        Get.to(Done());
      },
      onPaymentFailed: () {
        Fluttertoast.showToast(
              msg: "payment_failed".tr,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0
          );
        Get.to(Info());
      },
      onPaymentCanceled: () {
        Fluttertoast.showToast(
            msg: "payment_canceled".tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Get.to(Info());
      },
    );
  }
  //End of Tamara Payment

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1; //currentStep-=1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  //Call Stripe Payment
  showStripe() async {
    await makePayment();
  }

  Widget controlBuilders(context, details) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          currentStep==2?
          Container():
          ElevatedButton(
            onPressed: details.onStepContinue,
            child: Text('step_next'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: kMainColor, // Background color
            ),
          ),
          const SizedBox(width: 10),
          currentStep==0?
          Container():
          OutlinedButton(
            onPressed: details.onStepCancel,
            child: Text('step_back'.tr,style: TextStyle(color: kMainColor),),
          ),
        ],
      ),
    );
  }

  String? _errorMessage(String hint) {
    if(hint=="login_username".tr){
      return 'login_error'.tr;
    }else if(hint=="phone".tr){
      return 'login_error'.tr;
    }else if(hint=="email".tr){
      return 'login_error'.tr;
    }else if(hint=="street".tr){
      return 'login_error'.tr;
    }else if(hint=="building".tr){
      return 'login_error'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    widget.products=Provider.of<CartItem>(context).products;
    formatdate=new DateFormat('yyyy.MMMMM.dd hh:mm:ss aaa').format(currentdate);
    return Form(
      key: _globalKey,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: WillPopScope(
            onWillPop:(){
              Get.to(CartScreen());
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    child: GestureDetector(
                      onTap:(){
                        cancelDialog();
                      },
                      child: Text('cancel'.tr,
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: kMainColor,
                      //background: Colors.red,
                      //secondary: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: [
                      //SizedBox(height: screenHeight / 25,),
                      SizedBox(height: 20,),
                      Text('continue_order'.tr,
                        style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Stepper(
                        elevation: 0, //Horizontal Impact
                        // margin: const EdgeInsets.all(20), //vertical impact
                        controlsBuilder: controlBuilders,
                        type: StepperType.vertical,
                        physics: const ScrollPhysics(),
                        onStepTapped: onStepTapped,
                        onStepContinue: continueStep,
                        onStepCancel: cancelStep,
                        currentStep: currentStep, //0, 1, 2
                        steps: [
                          Step(
                              title: Text('step_one'.tr),
                              content: Column(
                                children: [
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    controller: _username,
                                    validator:(value) {
                                      if (value!.isEmpty) {
                                        return _errorMessage("login_username".tr);
                                        // ignore: missing_return
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "login_username".tr,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16
                                      ),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    controller: _phone,
                                    keyboardType: TextInputType.phone,
                                    validator:(value) {
                                      if (value!.isEmpty) {
                                        return _errorMessage("phone".tr);
                                        // ignore: missing_return
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "phone".tr,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16
                                      ),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  TextFormField(
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator:(value) {
                                      if (value!.isEmpty) {
                                        return _errorMessage("email".tr);
                                        // ignore: missing_return
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "email".tr,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16
                                      ),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              isActive: currentStep >= 0,
                              state:
                              currentStep >= 0 ? StepState.complete : StepState.disabled),
                          Step(
                            title: Text('step_two'.tr),
                            content: Column(
                              children: [
                                const SizedBox(height: 10,),
                                TextFormField(
                                  controller: _city,
                                  validator:(value) {
                                    if (value!.isEmpty) {
                                      return _errorMessage("street".tr);
                                      // ignore: missing_return
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "street".tr,
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16
                                    ),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  controller: _area,
                                  validator:(value) {
                                    if (value!.isEmpty) {
                                      return _errorMessage("building".tr);
                                      // ignore: missing_return
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "building".tr,
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16
                                    ),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                            isActive: currentStep >= 0,
                            state: currentStep >= 1 ? StepState.complete : StepState.disabled,
                          ),
                          Step(
                            title: Text('step_three'.tr),
                            content: Column(
                              children: [
                                const SizedBox(height: 10,),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: Image.asset(
                                        'assets/images/payment.png',
                                      width: MediaQuery.of(context).size.width / 6,
                                      height: MediaQuery.of(context).size.height / 8,
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: Text('payment_online'.tr),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width / 2,
                                          child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              'payment_online_info'.tr)
                                      ),
                                    ),
                                    trailing: Radio(
                                      value: 1,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                          payment_mthod = 'card';
                                        });
                                      },
                                    ),
                                    dense: true,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: Image.asset(
                                        'assets/images/tabby.png',
                                        width: MediaQuery.of(context).size.width / 6,
                                        height: MediaQuery.of(context).size.height / 8,
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: Text('tabby'.tr),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              'tabby_info'.tr)
                                      ),
                                    ),
                                    trailing: Radio(
                                      value: 2,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                          payment_mthod = 'tabby';
                                          createSession();
                                        });
                                      },
                                    ),
                                    dense: true,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: Image.asset(
                                        'assets/images/tamara.jpeg',
                                      width: MediaQuery.of(context).size.width / 6,
                                      height: MediaQuery.of(context).size.height / 8,
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: Text('tamara'.tr),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              'tamara_info'.tr)
                                      ),
                                    ),
                                    trailing: Radio(
                                      value: 3,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                          payment_mthod = 'tmra';
                                        });
                                      },
                                    ),
                                    dense: true,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  elevation: 1,
                                  child: ListTile(
                                    leading: Image.asset(
                                        'assets/images/cash.png',
                                      width: MediaQuery.of(context).size.width / 6,
                                      height: MediaQuery.of(context).size.height / 8,
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: Text('cach'.tr),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10,top: 5,bottom: 5),
                                      child: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              'cach_info'.tr)
                                      ),
                                    ),
                                    trailing: Radio(
                                      value: 4,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                          payment_mthod = 'cod';
                                        });
                                      },
                                    ),
                                    dense: true,
                                  ),
                                ),
                              ],
                            ),
                            isActive: currentStep >= 0,
                            state: currentStep >= 2 ? StepState.complete : StepState.disabled,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                        child: Builder(
                          builder: (context) => ElevatedButton(
                            onPressed: () {
                              // if(city.text.isEmpty||area.text.isEmpty||dropdownvalue==null){
                              //   Fluttertoast.showToast(
                              //       msg: "continue_order".tr,
                              //       toastLength: Toast.LENGTH_SHORT,
                              //       gravity: ToastGravity.CENTER,
                              //       timeInSecForIosWeb: 1,
                              //       backgroundColor: Colors.black,
                              //       textColor: Colors.white,
                              //       fontSize: 16.0
                              //   );
                              // }else{
                              //   save();
                              // }
                              // if(selectedOption==1){
                              //   showStripe();
                              // }else if(selectedOption==2){
                              //   openInAppBrowser();
                              // }else if(selectedOption==3){
                              //   tamaraPayment();
                              // }else if(selectedOption==4){
                              //
                              // }
                              //save();
                              //newsave();
                              if (_state == 0) {
                                animateButton();
                              }
                              if (_globalKey.currentState!.validate()){
                                _globalKey.currentState!.save();
                                try{
                                  newsave();
                                }on PlatformException catch(e){

                                }
                              }else{
                                setState(() {
                                  _state = 0;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
                              child: Center(
                                  child:setUpButtonChild()
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "order_now".tr,
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(microseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }

  //Stripe Payment
  String convertDoubleToStringForStripe(double amount) {
    int amountInCents = amount.round();
    String amountString = amountInCents.toString();
    return amountString;
  }
  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(convertDoubleToStringForStripe(price!), 'AED');
      //Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
              // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
              style: ThemeMode.dark,
              merchantDisplayName: 'Adnan')).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value){
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green,),
                      SizedBox(width: 5,),
                      Text("payment_successfull".tr),
                    ],
                  ),
                ],
              ),
            ));
        widget.products.clear();
        Get.to(Done());
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;

      }).onError((error, stackTrace){
        print('Error is:--->$error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100 ;
    return calculatedAmout.toString();
  }
  //End of Stripe Payment

  cancelDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("profile_dialog_title".tr,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('cancel_dialog_delete'.tr,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('profile_dialog_no'.tr,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Provider.of<CartItem>(context, listen: false).deleteAll();
                                Navigator.of(context).pop();
                                Get.to(Home());
                              });
                            },
                            child: Text('profile_dialog_ok'.tr,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    });
  }
}
