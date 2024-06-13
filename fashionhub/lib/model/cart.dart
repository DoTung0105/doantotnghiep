import 'package:fashionhub/model/clother.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  List<Clother> cloShop = [
    Clother(
      name: 'Áo polo Paradox® WEE LOGO',
      price: '225.000',
      imagePath: 'lib/images/Polo_black.png',
      description:
          'Áo polo Paradox® WEE LOGO với thiết kế thời thượng bằng chất liệu cotton 2 chiều 250gsm mang đến sự thoải mái và quen thuộc khi mặc. Hình thêu tỉ mỉ và tinh tế. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo dày dặn 3 cm và có chu vi vừa phải, tôn dáng và thoải mái khi mặc.',
      brand: 'PARADOX',
      color: 'Đen',
      size: '',
      evaluate: 4.9,
      sold: 1100,
      wareHouse: 990,
    ),
    Clother(
      name: 'Áo polo Paradox® WEE LOGO',
      price: '225.000',
      imagePath: 'lib/images/Polo_white.png',
      description:
          'Áo polo Paradox® WEE LOGO với thiết kế thời thượng bằng chất liệu cotton 2 chiều 250gsm mang đến sự thoải mái và quen thuộc khi mặc. Hình thêu tỉ mỉ và tinh tế. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo dày dặn 3 cm và có chu vi vừa phải, tôn dáng và thoải mái khi mặc.',
      brand: 'PARADOX',
      color: 'Trắng',
      size: '',
      evaluate: 4.3,
      sold: 200,
      wareHouse: 1800,
    ),
    Clother(
      name: 'Áo thun Paradox® FLOWERS',
      price: '185.000',
      imagePath: 'lib/images/Polo_1_black.png',
      description:
          'Áo thun Paradox® FLOWERS với thiết kế thời thượng bằng chất liệu cotton 2 chiều 250gsm mang đến sự thoải mái và quen thuộc khi mặc. Hình in kéo lụa chắc chắn và bền màu. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo tròn ôm sát, dày dặn 3 cm và có chu vi vừa phải, tôn dáng và thoải mái khi mặc.',
      brand: 'FLOWERS',
      color: 'Đen',
      size: '',
      evaluate: 4.5,
      sold: 1305,
      wareHouse: 1324,
    ),
    Clother(
      name: 'Áo thun Paradox® FLOWERS',
      price: '185.000',
      imagePath: 'lib/images/Polo_1_white.png',
      description:
          'Áo thun Paradox® FLOWERS với thiết kế thời thượng bằng chất liệu cotton 2 chiều 250gsm mang đến sự thoải mái và quen thuộc khi mặc. Hình in kéo lụa chắc chắn và bền màu. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo tròn ôm sát, dày dặn 3 cm và có chu vi vừa phải, tôn dáng và thoải mái khi mặc.',
      brand: 'FLOWERS',
      color: 'Trắng',
      size: '',
      evaluate: 4.5,
      sold: 978,
      wareHouse: 1022,
    ),
    Clother(
      name: 'Áo thun Paradox® CUPID',
      price: '250.000',
      imagePath: 'lib/images/Polo_2_black.png',
      description:
          'Áo thun Paradox® CUPID với thiết kế thời thượng bằng chất liệu cotton 2 chiều 250gsm mang đến sự thoải mái và quen thuộc khi mặc. Hình in kéo lụa chắc chắn và bền màu. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo tròn ôm sát, dày dặn 3 cm và có chu vi vừa phải, tôn dáng và thoải mái khi mặc.',
      brand: 'CUPID',
      color: 'Đen',
      size: '',
      evaluate: 4.9,
      sold: 990,
      wareHouse: 1100,
    ),
    Clother(
      name: 'Áo thun Paradox® CUPID',
      price: '250.000',
      imagePath: 'lib/images/Polo_2_white.png',
      description:
          'Áo thun Paradox® CUPID với thiết kế thời thượng bằng chất liệu cotton 2 chiều 250gsm mang đến sự thoải mái và quen thuộc khi mặc. Hình in kéo lụa chắc chắn và bền màu. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo tròn ôm sát, dày dặn 3 cm và có chu vi vừa phải, tôn dáng và thoải mái khi mặc.',
      brand: 'CUPID',
      color: 'Trắng',
      size: '',
      evaluate: 4.9,
      sold: 700,
      wareHouse: 1300,
    ),
    Clother(
      name: 'Áo khoác dù Paradox® JOLLY',
      price: '325.000',
      imagePath: 'lib/images/Polo_3.png',
      description:
          'Áo khoác dù Paradox® JOLLY với thiết kế thời thượng bằng chất liệu dù 2 lớp mang đến sự thoải mái và thoáng khí khi mặc. Hình in kéo lụa chắc chắn và bền màu. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo lọ tôn dáng và thoải mái khi mặc.',
      brand: 'JOLLY',
      color: 'Trắng',
      size: '',
      evaluate: 4.7,
      sold: 1200,
      wareHouse: 800,
    ),
    Clother(
      name: 'Áo khoác dù Paradox® JOLLY',
      price: '325.000',
      imagePath: 'lib/images/Polo_3.png',
      description:
          'Áo khoác dù Paradox® JOLLY với thiết kế thời thượng bằng chất liệu dù 2 lớp mang đến sự thoải mái và thoáng khí khi mặc. Hình in kéo lụa chắc chắn và bền màu. Form áo oversize cá tính và che hết mọi khuyết điểm trên cơ thể. Sản phẩm phù hợp với mọi hoạt động thường ngày. Cổ áo lọ tôn dáng và thoải mái khi mặc.',
      brand: 'GUCCI',
      color: 'Trắng',
      size: '',
      evaluate: 4.7,
      sold: 1200,
      wareHouse: 800,
    ),
  ];

  List<Clother> userCart = [];

  List<Clother> getClotherList() {
    return cloShop;
  }

  List<Clother> getUserCart() {
    return userCart;
  }

  List<String> getBranchesList() {
    Set<String> brandesSet = {};
    for (var item in cloShop) {
      brandesSet.add(item.brand);
    }
    return brandesSet.toList();
  }

  void addItemToCart(Clother clother, int quantity, String size) {
    bool productExists = false;
    for (var item in userCart) {
      if (item.name == clother.name && item.size == size) {
        // Kiểm tra tên và kích thước
        item.quantity += quantity;
        productExists = true;
        break;
      }
    }
    if (!productExists) {
      Clother cartItem = Clother(
        name: clother.name,
        price: clother.price,
        imagePath: clother.imagePath,
        description: clother.description,
        brand: clother.brand,
        color: clother.color,
        size: size, // Lưu trữ kích thước
        evaluate: clother.evaluate,
        sold: clother.sold,
        wareHouse: clother.wareHouse,
        quantity: quantity,
      );
      userCart.add(cartItem);
    }
    notifyListeners();
  }

  List<Clother> sortClotherList(String sortOption) {
    List<Clother> sortedList = List.from(cloShop);
    switch (sortOption) {
      case 'Giá từ thấp đến cao':
        sortedList.sort((a, b) => double.parse(a.price.replaceAll('.', ''))
            .compareTo(double.parse(b.price.replaceAll('.', ''))));
        break;
      case 'Giá từ cao đến thấp':
        sortedList.sort((a, b) => double.parse(b.price.replaceAll('.', ''))
            .compareTo(double.parse(a.price.replaceAll('.', ''))));
        break;
      case 'Lượt bán':
        sortedList.sort((a, b) => b.sold.compareTo(a.sold));
        break;
      case 'Đánh giá':
        sortedList.sort((a, b) => b.evaluate.compareTo(a.evaluate));
        break;
      default:
        break;
    }
    return sortedList;
  }

  void removeItemFromCart(Clother clother) {
    for (var item in userCart) {
      if (item.name == clother.name) {
        if (item.quantity > 1) {
          item.quantity -= 1;
        } else {
          userCart.remove(item);
        }
        notifyListeners();
        return;
      }
    }
  }

  void removeItems(List<Clother> items) {
    for (var item in items) {
      userCart.remove(item);
    }
    notifyListeners();
  }
}
