// import 'package:fashionhub/model/order.dart';
// import 'package:flutter/material.dart';

// class Admin_Order_ListScreen extends StatefulWidget {
//   @override
//   State<Admin_Order_ListScreen> createState() => _Admin_Order_ListScreenState();
// }

// class _Admin_Order_ListScreenState extends State<Admin_Order_ListScreen> {
//   List<Order> orders = [
//     Order(
//         id: '1',
//         customerName: 'John Doe',
//         item: 'Laptop',
//         price: 999.99,
//         status: 'Pending',
//         timestamp: DateTime(1)),
//     Order(
//         id: '2',
//         customerName: 'Jane Smith',
//         item: 'Smartphone',
//         price: 699.99,
//         status: 'Shipped',
//         timestamp: DateTime(2)),
//     Order(
//         id: '3',
//         customerName: 'Alice Johnson',
//         item: 'Tablet',
//         price: 499.99,
//         status: 'Delivered',
//         timestamp: DateTime(3)),
//   ];

//   void _updateOrderStatus(String id, String newStatus) {
//     setState(() {
//       orders = orders.map((order) {
//         if (order.id == id) {
//           return Order(
//               id: order.id,
//               customerName: order.customerName,
//               item: order.item,
//               price: order.price,
//               status: newStatus,
//               timestamp: DateTime.now());
//         }
//         return order;
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Order Review'),
//       ),
//       body: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               title: Text('${order.item} - ${order.customerName}'),
//               subtitle: Text('Price: \$${order.price}'),
//               trailing: Text('${order.status},\n${order.timestamp.toString()}'),
//               onTap: () {
//                 _showStatusUpdateDialog(order);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showStatusUpdateDialog(Order order) {
//     String selectedStatus = order.status;
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: Text('Update ${order.customerName}'),
//               content: DropdownButton<String>(
//                 value: selectedStatus,
//                 onChanged: (String? newStatus) {
//                   if (newStatus != null) {
//                     setState(() {
//                       selectedStatus = newStatus;
//                     });
//                   }
//                 },
//                 items: <String>['Pending', 'Shipped', 'Delivered', 'Cancelled']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     _updateOrderStatus(order.id, selectedStatus);
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Update'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
