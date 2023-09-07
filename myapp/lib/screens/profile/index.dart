
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/index.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/widgets/image_picker_dialog.dart';

/*
Nội dung nghiên cứu buổi sau:
-Bấm vào ảnh profile => cho chọn ảnh
-Viết màn hình Settings, có switcher(chuyển dark mode)
-Navigation nhiều màn hình
* */
class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserService userService = GetIt.instance<UserService>();//Dependency Injection
  bool isFetchingData = false;
  User user = User.empty;
  Future<void> fetchUserData() async {
    setState(() {
      isFetchingData = true; // Bắt đầu fetching
    });

    try {
      final User updatedUser = await userService.fetchUserData();

      if (this.user != updatedUser) {
        setState(() {
          print("haha");
          this.user = updatedUser;
        });
      }

    } catch (e) {
      print('Error fetching product data: $e');
    } finally {
      setState(() {
        isFetchingData = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }
  Widget _buildRow({Function()? onPressed, IconData? iconData, String? text}) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(iconData, size: 30),
        ),
        SizedBox(width: 10),
        Text(text ?? '', style: TextStyle(fontSize: 16),),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          //alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 200,
                      color:Colors.blue,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Profile'.toUpperCase(),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,),
                      )
                  ),
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        color: Colors.yellow,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            _buildRow(
                              onPressed: () {
                                // Xử lý sự kiện khi IconButton được nhấn
                              },
                              iconData: Icons.widgets_sharp,
                              text: 'Dashboard',
                            ),
                            _buildRow(
                              onPressed: () {
                                // Xử lý sự kiện khi IconButton được nhấn
                              },
                              iconData: Icons.widgets_sharp,
                              text: 'Another Option',
                            ),
                          ],
                        ),
                      ))

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 120, left: 20, right: 20),
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: isFetchingData == true ? Center(
                  child: LoadingAnimationWidget.twistingDots(
                    leftDotColor: const Color(0xFF1A1A3F),
                    rightDotColor: const Color(0xFFEA3799),
                    size: 200,
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        width: 80, // Độ rộng của avatar
                        height: 80, // Độ cao của avatar
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2, // Độ dày viền trắng
                          ),
                          image: DecorationImage(
                            image: NetworkImage(this.user.picture.large), // Đường dẫn hình ảnh từ URL
                            fit: BoxFit.cover, // Cách hình ảnh sẽ fit trong vùng giới hạn của nó
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImagePickerDialog(
                              onImageSelected: (List<XFile>? files) async {
                                print("haha");
                              },
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10), // Khoảng cách giữa avatar và tên người dùng
                    Text(
                      user.userName, // Thay bằng tên người dùng thực tế
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email, // Thay bằng email thực tế
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchUserData();
        },
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
