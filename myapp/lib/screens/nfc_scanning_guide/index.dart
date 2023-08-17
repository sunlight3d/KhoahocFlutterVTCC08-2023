
import 'package:flutter/material.dart';
import 'package:myapp/constants/text_styles.dart';
import 'package:myapp/constants/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/models/list_item.dart';
import 'package:myapp/screens/nfc_scanning_guide/video_widget.dart';
import 'package:myapp/widgets/active_button.dart';
import 'package:video_player/video_player.dart';

class NFCScanningGuide extends StatefulWidget {
  NFCScanningGuide({super.key});

  @override
  State<NFCScanningGuide> createState() => _NFCScanningGuideState();
}

class _NFCScanningGuideState extends State<NFCScanningGuide> {
  final List<ListItem> yourList = [
    ListItem(AppIcons.ICON_SCREEN, 'Text 1'),
    ListItem(AppIcons.ICON_SCREEN, 'Text 2'),
    ListItem(AppIcons.ICON_SCREEN, 'Text 3'),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Hướng dẫn quét thồng tin trong chip CCCD ejhsurh sdhgrhehr ehri eriehirh ehiriehr ehri eihr',
                style: TextStyles.big,
              ),
              Column(
                children: getList(),
              ),
              Text('Video hướng dẫn', style: TextStyles.big,),
              VideoWidget(
                //videoUrl: 'https://www.youtube.com/watch?v=HXfn_1guF_I',
                videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
              ),
              Text('Sau khi đã hiểu, hãy bắt đầu', style: TextStyles.normal,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ActiveButton(title: 'Bỏ qua', onPress: (){},)),
                  Expanded(child: ActiveButton(title: 'Bắt đầu quét', onPress: (){},)),
                ],
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
