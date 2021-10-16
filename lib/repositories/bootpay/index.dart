import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/bio_payload.dart';
import 'package:bootpay_api/model/bio_price.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:bootpay_api/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

void goBootpayRequest(BuildContext context) async {
  Item item1 = Item();
  item1.itemName = "미키 마우스"; // 주문정보에 담길 상품명
  item1.qty = 1; // 해당 상품의 주문 수량
  item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
  item1.price = 500; // 상품의 가격

  Item item2 = Item();
  item2.itemName = "키보드"; // 주문정보에 담길 상품명
  item2.qty = 1; // 해당 상품의 주문 수량
  item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
  item2.price = 500; // 상품의 가격
  List<Item> itemList = [item1, item2];

  Payload payload = Payload();
  payload.applicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';

  payload.pg = 'kcp';
  payload.method = 'card';
  // payload.methods = ['card', 'phone', 'vbank', 'bank'];
  payload.name = '테스트 상품';
  payload.price = 1000.0; //정기결제시 0 혹은 주석
  payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
  payload.params = {
    "callbackParam1": "value12",
    "callbackParam2": "value34",
    "callbackParam3": "value56",
    "callbackParam4": "value78",
  };
//    payload.us

  User user = User();
  user.username = "사용자 이름";
  user.email = "user1234@gmail.com";
  user.area = "서울";
  user.phone = "010-4033-4678";
  user.addr = '서울시 동작구 상도로 222';

  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterSample';
  extra.quotas = [0, 2, 3];
  extra.popup = 1;
  extra.quick_popup = 1;

  BootpayApi.request(
    context,
    payload,
    extra: extra,
    user: user,
    items: itemList,
    onDone: (json) {
      print('--- onDone: $json');
    },
    onCancel: (json) {
      print('--- onCancel: $json');
    },
    onError: (json) {
      print(' --- onError: $json');
    },
  );

  // Timer.periodic(Duration(milliseconds: 10), (timer) {                     setState(() {                       _timerCount++;                     });                   });
}

void goBootpayRequestBio(String token, BuildContext context) async {
  Item item1 = Item();
  item1.itemName = "미키 마우스"; // 주문정보에 담길 상품명
  item1.qty = 1; // 해당 상품의 주문 수량
  item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
  item1.price = 500; // 상품의 가격

  Item item2 = Item();
  item2.itemName = "키보드"; // 주문정보에 담길 상품명
  item2.qty = 1; // 해당 상품의 주문 수량
  item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
  item2.price = 500; // 상품의 가격
  List<Item> itemList = [item1, item2];

  BioPayload payload = BioPayload();
  payload.applicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';
  payload.userToken = token;

  payload.pg = 'nicepay';
  // payload.methods = ['card', 'phone', 'vbank', 'bank'];
  payload.name = '테스트 상품';
  payload.price = 1000.0; //정기결제시 0 혹은 주석
  payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
  payload.params = {
    "callbackParam1": "value12",
    "callbackParam2": "value34",
    "callbackParam3": "value56",
    "callbackParam4": "value78",
  };

  BioPrice price1 = BioPrice();
  price1.name = "상품가격";
  price1.price = 89000;

  BioPrice price2 = BioPrice();
  price2.name = "쿠폰적용";
  price2.price = -2500;

  BioPrice price3 = BioPrice();
  price3.name = "배송비";
  price3.price = 2500;
  payload.prices = [price1, price2, price3];

  payload.names = ["플리츠레이어 카라숏원피스", "블랙 (COLOR)", "55 (SIZE)"];
//    payload.us

  User user = User();
  user.username = "사용자 이름";
  user.email = "user1234@gmail.com";
  user.area = "서울";
  user.phone = "010-4033-4678";
  user.addr = '서울시 동작구 상도로 222';

  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterSample';
  extra.quotas = [0, 2, 3];
  extra.iosCloseButton = false;

  BootpayApi.requestBio(
    context,
    payload,
    extra: extra,
    user: user,
    items: itemList,
    onDone: (json) {
      print('--- onDone: $json');
    },
    onCancel: (json) {
      print('--- onCancel: $json');
    },
    onError: (json) {
      print(' --- onError: $json');
    },
  );
}

//(이것은 단순히 예제입니다.) 클라이언트 <-> 부트페이와 통신해서는 안됩니다.
//서버 <-> 부트페이 서버와 통신 후, 받아온 userToken 값을
//클라이언트 <-> 서버와 통신하셔서 받아오셔야 합니다.
@deprecated
void getRestToken(BuildContext context) async {
  String rest_applicationId = "5b8f6a4d396fa665fdc2b5ea";
  String rest_pk = "n9jO7MxVFor3o//c9X5tdep95ZjdaiDvVB4h1B5cMHQ=";

  Map<String, dynamic> params = {
    "application_id": rest_applicationId,
    "private_key": rest_pk
  };

  var url = Uri.parse('https://api.bootpay.co.kr/request/token');
  final response = await http.post(url, body: params);
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    String token = res['data']['token'];
    getUserToken(token, context);
  } else {
    print(response.body);
  }
}

void getUserToken(String restToken, BuildContext context) async {
  Map<String, dynamic> body = {
    "user_id": "12342134567",
//      "user_id": Uuid().v1(),
    "email": "test1234@gmail.com",
    "name": "테스트 유저",
    "gender": 0,
    "birth": "861014",
    "phone": "01012345678"
  };

  var url = Uri.parse('https://api.bootpay.co.kr/request/user/token');
  final response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": restToken
      },
      body: body);
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    String token = res['data']['user_token'];
    goBootpayRequestBio(token, context);
  } else {
    print(response.body);
  }
}
