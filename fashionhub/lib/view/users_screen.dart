// import 'package:fashionhub/model/user_model.dart';
// import 'package:fashionhub/viewmodel/user_ViewModel.dart';
// import 'package:flutter/material.dart';

// class users_Screen extends StatefulWidget {
//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<users_Screen> {
//   final UsersViewModel _viewModel = UsersViewModel();
//   List<UserModel> _users = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsers();
//     _isLoading = false;
//   }

//   Future<void> _lockUnlockUser(String uid, bool lock) async {
//     await _viewModel.lockOrUnlockUser(uid, lock);
//     await _fetchUsers();

//     // Cập nhật trạng thái của người dùng trong danh sách _users
//     int index = _users.indexWhere((user) => user.uid == uid);
//     if (index != -1 && index < _users.length) {
//       setState(() {
//         _users[index].locked = lock;
//       });
//     }
//   }

//   Future<void> _fetchUsers() async {
//     List<UserModel> users = await _viewModel.fetchUsers();
//     setState(() {
//       _users = users;
//       _isLoading = false;
//     });
//   }

//   // Future<void> _lockUnlockUser(String uid, bool lock) async {
//   //   await _viewModel.lockOrUnlockUser(uid, lock);
//   //   await _fetchUsers();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh Sách Tài Khoản'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _users.length,
//               itemBuilder: (context, index) {
//                 UserModel user = _users[index];
//                 return Container(
//                   margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                   padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user.displayName ?? '',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       SizedBox(height: 8.0),
//                       Text(user.email ?? ''),
//                       SizedBox(height: 4.0),
//                       Text('Role: ${user.role}' ?? ''),
//                       SizedBox(height: 4.0), // Thêm khoảng cách
//                       Text(
//                         user.locked == true
//                             ? 'Trạng thái: khoá'
//                             : 'Trạng thái: mở',
//                         style: TextStyle(
//                           color:
//                               user.locked == true ? Colors.red : Colors.green,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () => _lockUnlockUser(user.uid, true),
//                             child: Text('Khóa'),
//                           ),
//                           SizedBox(width: 8.0),
//                           ElevatedButton(
//                             onPressed: () => _lockUnlockUser(user.uid, false),
//                             child: Text('Mở khóa'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//       backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
//     );
//   }
// }

import 'package:fashionhub/model/user_model.dart';
import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/viewmodel/user_ViewModel.dart';
import 'package:flutter/material.dart';

class users_Screen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<users_Screen> {
  final UsersViewModel _viewModel = UsersViewModel();
  final AuthenticationService auth = AuthenticationService();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Hàm kiểm tra vai trò của người dùng mục tiêu
  Future<bool> _isTargetUserAdmin(String uid) async {
    String? role = await auth.getUserRole(uid);
    return role == 'Admin';
  }

  // Hàm khóa/mở khóa người dùng
  Future<void> _lockUnlockUser(String uid, bool lock) async {
    bool isAdmin = await _isTargetUserAdmin(uid);
    if (isAdmin) {
      // Nếu người dùng mục tiêu là admin, hiển thị thông báo không thể thực hiện
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể khóa/mở khóa tài khoản admin'),
        ),
      );
    } else {
      // Nếu không phải admin, thực hiện khóa/mở khóa và cập nhật danh sách
      await _viewModel.lockOrUnlockUser(uid, lock);
      await _fetchUsers();
      int index = _users.indexWhere((user) => user.uid == uid);
      if (index != -1 && index < _users.length) {
        setState(() {
          _users[index].locked = lock;
        });
      }
    }
  }

  // Hàm lấy danh sách người dùng từ view model
  Future<void> _fetchUsers() async {
    List<UserModel> users = await _viewModel.fetchUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Tài Khoản'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                UserModel user = _users[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? '',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(user.email ?? ''),
                      SizedBox(height: 4.0),
                      Text('Role: ${user.role}' ?? ''),
                      SizedBox(height: 4.0),
                      Text(
                        user.locked == true
                            ? 'Trạng thái: khoá'
                            : 'Trạng thái: mở',
                        style: TextStyle(
                          color:
                              user.locked == true ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => _lockUnlockUser(user.uid, true),
                            child: Text('Khóa'),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () => _lockUnlockUser(user.uid, false),
                            child: Text('Mở khóa'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
    );
  }
}
