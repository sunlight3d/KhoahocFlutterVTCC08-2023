
import 'package:flutter/material.dart';
import 'package:myapp/constants/text_styles.dart';
import 'package:myapp/constants/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NFCScanningGuide extends StatefulWidget {
  const NFCScanningGuide({super.key});

  @override
  State<NFCScanningGuide> createState() => _NFCScanningGuideState();
}
class ListItem {
  final String icon;
  final String title;

  ListItem(this.icon, this.title);
}
class _NFCScanningGuideState extends State<NFCScanningGuide> {
  final List<ListItem> yourList = [
    ListItem(AppIcons.ICON_SCREEN, 'Text 1'),
    ListItem(AppIcons.ICON_SCREEN, 'Text 2'),
    ListItem(AppIcons.ICON_SCREEN, 'Text 3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        leading: Builder(
          builder: (BuildContext context) {
            return InkWell(
              child: Container(
                child: SvgPicture.asset(
                  AppIcons.ICON_CLOSE,
                  colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                ),
                width: 10,
                height: 10,
              ),
              onTap: (){
                print("haha");
              },
            );
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
                style: TextStyles.big,
              ),
              Column(
                children: getList(),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
        )
      ),
    );
  }
  List<Widget> getList() {
    return yourList.map((item) {
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: SvgPicture.asset(
              item.icon,
            ),
          ),
          Expanded(
            child: Text(
              item.title,
              style: TextStyles.normal,
            ),
          ),
        ],
      );
    }).toList();
  }
}
