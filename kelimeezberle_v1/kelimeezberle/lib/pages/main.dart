import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kelimeezberle/global_widget/fastMethodColor.dart';
import 'package:kelimeezberle/pages/lists.dart';
import 'package:kelimeezberle/pages/words_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../db/db/shared_preferences.dart';
import '../global_widget/app_bar.dart';
import '../global_widget/global_variable.dart';
import 'multiple_choice.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}



//Tıkla linki
final Uri _url = Uri.parse(
    'https://linkedin.com/in/ilyaskeskin');

class _MainPageState extends State<MainPage> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Paket Versiyonu Çekme 26 to 44
  PackageInfo? packageInfo;
  String version = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    packageInfoInit();
  }

  void packageInfoInit() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo!.version;
    });
  }

  @override
  Widget build(BuildContext context) {

    //Status bar renk seçimi.
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);

    //Dark mode da status bardaki simgelerin renginin düzgün olması için.
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    return Scaffold(
      key: _scaffoldKey,

      //Çekmece Özellikleri
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo1.png",
                    height: 80,
                  ),
                  const Text(
                    "Quick and Easy",
                    style: TextStyle(fontFamily: "RobotoLight", fontSize: 26),
                  ),
                  const Text(
                    "İstediğini Öğren",
                    style: TextStyle(fontFamily: "RobotoLight", fontSize: 22),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: const Divider(
                        color: Colors.black,
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 50, right: 8, left: 8),
                      child: const Text(
                        "Uygulama Geliştiricileri\n\nHayati KAYA\nİlyas KESKİN",
                        style: TextStyle(
                          fontFamily: "RobotoLight",
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                      )),

                  //url_launcher 6.1.11 kütüphanesi kullanıldı.
                  InkWell(
                      onTap: () async {
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      child: Text(
                        "Tıkla",
                        style: TextStyle(
                            fontFamily: "RobotoLight",
                            fontSize: 16,
                            color: Color(
                                fastMethodColor.HexaColorConverter("#0A588D"))),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("v" +version +"\nhayatiden@gmail.com\nilyas.keskin@outlook.com.tr",
                  style: TextStyle(
                      fontFamily: "RobotoLight",
                      fontSize: 14,
                      color:Color(fastMethodColor.HexaColorConverter("#0A588D"))),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: appBar(context,
          left: const FaIcon(
            FontAwesomeIcons.bars,
            color: Colors.black,
            size: 20,
          ),
          center: Image.asset("assets/images/text.png"),
          leftWidgetOnClick: () => {_scaffoldKey.currentState!.openDrawer()}),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                //Radio button ayarları
                langRadioButton(
                    text: "İngilizce - Türkçe", group: chooseLang, value: Lang.eng),
                langRadioButton(
                    text: "Türkçe - İngilizce",
                    group: chooseLang,
                    value: Lang.tr),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListsPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    margin: const EdgeInsets.only(bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(fastMethodColor.HexaColorConverter("#7D20A6")),
                          Color(fastMethodColor.HexaColorConverter("#481183")),
                        ],
                        // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: const Text(
                      "Listelerim",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: "Carter"),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      card(context,
                          startColor: "#1DACC9",
                          endColor: "#0C33B2",
                          title: "Kelime\nKartları",click: (){
                            Navigator.push(context, MaterialPageRoute(builder:(context) => const WordCardsPage()));

                          } ),
                      card(context,
                          startColor: "#FF3348",
                          endColor: "#B029B9",
                          title: "Çoktan\nSeçmeli",click: () {
                            Navigator.push(context, MaterialPageRoute(builder:(context) => const MultipleChoicePage()));

                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell card(BuildContext context,
      {@required String? startColor,
      @required String? endColor,
      @required String? title, @required Function ?click}) {
    return InkWell(
      onTap: () => click!(),
      child: Container(
        alignment: Alignment.center,
        height: 200,
        width: MediaQuery.of(context).size.width * 0.37,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(fastMethodColor.HexaColorConverter(startColor!)),
              Color(fastMethodColor.HexaColorConverter(endColor!)),
            ],
            // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title!,
              style: const TextStyle(
                  fontSize: 28, color: Colors.white, fontFamily: "Carter"),
              textAlign: TextAlign.center,
            ),
            const Icon(
              Icons.file_copy,
              size: 32,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

//Temiz kod için required yapısı kullanıldı.

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required Lang? group,
  }) {
    return SizedBox(
      width: 250,
      height: 30,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "Carter", fontSize: 15),
        ),
        leading: Radio<Lang>(
            value: value!,
            groupValue: chooseLang,
            onChanged: (Lang? value) {
              setState(() {
                chooseLang = value;
              });


              //SPreferences (1)
              //TRUE = İngilizceden Türkçeye
              //FALSE = Türkçeden İngilizceye

              if (value == Lang.eng)
              {
                SP.write("lang", true);
              }
              else
              {
                SP.write("lang", true);
              }

            },
        ),
      ),
    );
  }
}
