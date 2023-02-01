library ecorn.globals;

String API_URL = 'https://ecorn-app.uz/';
String LANG = 'ru';
String CLIENT = 'aea11f835600bd34b92fb5a9245330ae';
List CART = List();
List<dynamic> categories;
List<dynamic> menus;


var totalPrice = 0;
var orderPrice = 15000;
var totalSum = 0;

List<Map<String, String>> ORDER_STATUS = [
  {'id': '0', 'name': 'Все'},
  {'id': '1', 'name': 'На рассмотрении'},
  {'id': '2', 'name': 'Готовится'},
  {'id': '3', 'name': 'В пути'},
  {'id': '4', 'name': 'Доставлен'},
  {'id': '5', 'name': 'Отменен'},
];

List<Map<String, String>> PAYMENT_TYPE = [
  {'id': '0', 'name': 'Все'},
  {'id': '1', 'name': 'Наличные'},
  {'id': '2', 'name': 'PayMe'},
  {'id': '3', 'name': 'Click'},
];

List<Map<String, String>> ORDER_TYPE = [
  {'id': '0', 'name': 'Все'},
  {'id': '1', 'name': 'Доставка'},
  {'id': '2', 'name': 'Самовывоз'},
];

List<Map<String, String>> PAYMENT_STATUS = [
  {'id': '1', 'name': 'Оплачен'},
  {'id': '2', 'name': 'Не оплачен'},
];

List<Map<String, String>> POINTS = [
  {'id': '0', 'name': 'Все'},
  {'id': '1', 'name': 'Ecorn Ц1'},
  {'id': '2', 'name': 'Ecorn на Мирабадской'},
  {'id': '3', 'name': 'Ecorn на Чимкентской'},
];
