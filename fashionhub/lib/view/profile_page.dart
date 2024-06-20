import 'package:fashionhub/service/authentication_service.dart';
import 'package:fashionhub/view/user_profile_screen.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ProfilePage(authService: AuthenticationService());
  }
}
