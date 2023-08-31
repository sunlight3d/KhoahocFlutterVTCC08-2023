
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/index.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserService userService = GetIt.instance<UserService>();//Dependency Injection
  User user = User.empty;
  Future<void> fetchUserData() async {
    try {
      final jsonData = await userService.fetchUserData();
      setState(() {
        print("haha");
      });
    } catch (e) {
      print('Error fetching product data: $e');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('haha', style: TextStyle(fontSize: 30),),
        ),
      ),
    );
  }
}
