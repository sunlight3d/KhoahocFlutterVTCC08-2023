
import 'package:flutter/material.dart';
import 'package:myapp/constants/app_icons.dart';

class NFCScanningGuide extends StatefulWidget {
  const NFCScanningGuide({super.key});

  @override
  State<NFCScanningGuide> createState() => _NFCScanningGuideState();
}

class _NFCScanningGuideState extends State<NFCScanningGuide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        leading: IconButton(
          icon: Image.asset(AppIcons.ICON_CLOSE), // Hình ảnh bên trái
          onPressed: () {
            // Xử lý khi ấn vào hình ảnh bên trái
            print('haha');
          },
        ),
        centerTitle: true,
        title: Text(
          'Quét thông tin trong chip',
          textAlign: TextAlign.center,),
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Icon bên phải
            onPressed: () {
              // Xử lý khi ấn vào icon bên phải
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          child: Column(
            children: [
              Text(
                'Hướng dẫn quét thồng tin trong chip CCCD ejhsurh sdhgrhehr ehri eriehirh ehiriehr ehri eihr',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Image.asset(AppIcons.ICON_SETTING), // Hình ảnh bên trái
                    onPressed: () {
                      // Xử lý khi ấn vào hình ảnh bên trái
                      print('haha');
                    },
                  ),
                  Text(
                      'Cho phép ứng dụng truy cập NFC trên điện thoại',
                      style: TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
        )
      ),
    );
  }
}
