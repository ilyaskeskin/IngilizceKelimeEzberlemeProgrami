
import 'package:flutter/material.dart';
import 'package:kelimeezberle/global_widget/global_variable.dart';
import 'package:kelimeezberle/pages/main.dart';
import '../db/db/shared_preferences.dart';


class TemporaryPage extends StatefulWidget {
  const TemporaryPage({super.key});

  @override
  State<TemporaryPage> createState() => _TemporaryPageState();
}

class _TemporaryPageState extends State<TemporaryPage> {



  //First Screen Geçiş Bekleme Süresi.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4),() {
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MainPage()));
    });

    spRead();



  }


  //SPreferences (2)
  void spRead() async
  {
    if(await SP.read('lang')==true)
      {
        chooseLang = Lang.eng;
      }
    else
      {
        chooseLang = Lang.tr;
      }

    switch (await SP.read('which'))
    {
      case 0:
        chooseQuestionType = Which.learned;
        break;
      case 1:
        chooseQuestionType = Which.unlearned;
        break;
      case 2:
        chooseQuestionType = Which.all;
        break;
    }

    if (await SP.read('mix') == false)
    {
      listMixed = false;
    }
  }





  //Logo, Program İsmi ve Alt Font Ayarları
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Column(
                  children: [
                    Image.asset("assets/images/logo1.png"),
                    const Padding(
                      padding: EdgeInsets.all(15.0), //logo ile font arası boşluk.
                      child: Text("QUEAZY",style: TextStyle(color: Colors.black,fontFamily: "Luck",fontSize: 40),),
                    ),
                  ],
                ),
                const Padding(
                    padding: EdgeInsets.all(15.0), //logo ile font arası boşluk.
                    child: Text("İstediğini Öğren!",style: TextStyle(color: Colors.black,fontFamily: "Carter",fontSize: 25),),
                  ),
              ],

            ),
          ),
        ),

      ),


    );
  }
}
