import 'package:flutter/material.dart';
import 'package:kelimeezberle/db/db/db.dart';
import 'package:kelimeezberle/db/models/words.dart';
import 'package:kelimeezberle/global_widget/fastMethodColor.dart';
import 'package:kelimeezberle/global_widget/app_bar.dart';
import 'package:kelimeezberle/global_widget/toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../db/db/shared_preferences.dart';
import '../global_widget/global_variable.dart';



class WordCardsPage extends StatefulWidget {
  const WordCardsPage({Key?key}): super(key: key);

  @override
  State<WordCardsPage> createState() => _WordCardsPageState();
}




class _WordCardsPageState extends State<WordCardsPage> {





  @override
  void initState() {
    super.initState();
    getLists().then((value) => setState(() => lists));
  }


  List<Word> _words = [];
  bool start = false;
  List<bool> changeLang = [];


  void getSelectedWordOfLists(List<int> selectedListID) async

  {

    //Int listesi SP de olmadığından Int listesini String listesine dönüştürdük.
    List<String> value = selectedListID.map((e) => e.toString()).toList();
    SP.write("selected_list", value);
    
    
    if (chooseQuestionType == Which.learned)
    {

      _words = await DB.instance.readWordByLists(selectedListID,status: true);
      
    }
    else if(chooseQuestionType == Which.unlearned)
    {

      _words = await DB.instance.readWordByLists(selectedListID,status: false);

    }
    else
    {
      _words = await DB.instance.readWordByLists(selectedListID);

    }






    if(_words.isNotEmpty)
      {
        for (int i = 0; i<_words.length; ++i)
          {
            changeLang.add(true);
          }


        if (listMixed) _words.shuffle(); // Listeyi karıştır.
        start = true;

        setState(() {
          _words;
          start;
        });
      }
      else
      {
        toastMessage("Seçilen şartlarda liste boş.");
      }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        left: const Icon(Icons.arrow_back_ios,color: Colors.black,size: 22,),
        center: const Text("Kelime Kartları",style: TextStyle(fontFamily: "carter", fontSize: 22),),
        leftWidgetOnClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: start==false?Container(
          width: double.infinity,
          //Background kartımın tam ekrana yayılması için
          margin:  const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
          decoration: BoxDecoration(
            color: Color(fastMethodColor.HexaColorConverter("#DCD2FF")),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(text: "Öğrenmediklerimi sor", value: Which.unlearned),
              whichRadioButton(text: "Öğrendiklerimi sor", value: Which.learned),
              whichRadioButton(text: "Hepsini sor", value: Which.all),
              checkBox(text: "Listeyi karıştır", fWhat: forWhat.forListMixed),
              const SizedBox(height: 20,),
              const Divider(color: Colors.black,thickness: 1,),
              const Padding(padding: EdgeInsets.only(left: 16),
                child: Text("Listeler",style: TextStyle(fontFamily: "RobotoRegular", fontSize: 18,color: Colors.black),),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8,right: 8,bottom: 10,top: 10),
                height: 200,
                decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1)
                ),
                child: Scrollbar(
                thickness: 5,
                thumbVisibility: true,
                child: ListView.builder(itemBuilder: (context,index){
                  return checkBox(index: index,text:lists[index]['name'].toString());
                },itemCount: lists.length,),
              ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: ()
                  {
                    List<int> selectedIndexNoOfList = [];

                    for (int i = 0; i<selectedListIndex.length; ++i)
                      {
                        if(selectedListIndex[i] == true)
                          {
                            selectedIndexNoOfList.add(i);
                          }
                      }

                    List<int> selectedListIdList = [];

                    for (int i = 0 ; i<selectedIndexNoOfList.length; ++i)
                    {
                      selectedListIdList.add(lists[selectedIndexNoOfList[i]]['list_id'] as int);
                    }

                    if (selectedListIdList.isNotEmpty)
                    {
                      getSelectedWordOfLists(selectedListIdList);
                    } 
                    else
                    {
                      toastMessage("Lütfen, liste seç");
                    }
                  },
                  child: const Text("Başla",style: TextStyle(fontFamily: "RobotoRegular",fontSize: 18,color: Colors.black)),
                ),
              )
            ],
          ),
          ):CarouselSlider.builder(
          options: CarouselOptions(
            height: double.infinity
          ),
          itemCount: _words.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex)
            {

              String word = "";

              if (chooseLang == Lang.tr)
              {
                word = changeLang[itemIndex]?(_words[itemIndex].word_tr!):(_words[itemIndex].word_eng!);
              }
              else
              {
                word = changeLang[itemIndex]?(_words[itemIndex].word_eng!):(_words[itemIndex].word_tr!);
              }

              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            if (changeLang[itemIndex] == true)
                            {
                              changeLang[itemIndex] = false;
                            }
                            else
                            {
                              changeLang[itemIndex] = true;
                            }
                            setState(() {
                              changeLang[itemIndex];
                            });

                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            //Background kartımın tam ekrana yayılması için
                            margin:  const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                            padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
                            decoration: BoxDecoration(
                              color: Color(fastMethodColor.HexaColorConverter("#DCD2FF")),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(word, style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 28, color: Colors.black),),
                          ),
                        ),
                        Positioned(child:
                        Text((itemIndex+1).toString()+"/"+(_words.length).toString(),style: const TextStyle(fontFamily: "RobotoRegular",fontSize: 16,color: Colors.black),),left: 30,top: 10,)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    child: CheckboxListTile(
                      title: const Text("Öğrendim"),
                      value: _words[itemIndex].status,
                      onChanged: (value) {
                        _words[itemIndex] = _words[itemIndex].copy(status: value);
                        DB.instance.markAsLearned(value!, _words[itemIndex].id as int);
                        toastMessage(value?"Öğrenildi olarak işaretlendi":"Öğrenilmedi olarak işaretlendi");

                        setState(() {
                          _words[itemIndex];
                        });
                      },

                    ),

                  )

                ],

              );
            },
        ),
      ),
    );
  }

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: 300,
      height: 30,
      child: ListTile(
        title: Text(text!,style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),),
        leading: Radio<Which>(
          value: value!,
          groupValue: chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              chooseQuestionType = value;
            });

            switch(value)
            {
              case Which.learned:
                SP.write("which", 0);
                break;
              case Which.unlearned:
                SP.write("which", 1);
                break;
              case Which.all:
                SP.write("which", 2);
                break;
              default:
                break;
            }


          },
        ),
      ),
    );
  }

  SizedBox checkBox({int index=0,String ?text, forWhat fWhat=forWhat.forList})
  {
    return SizedBox(
      width: 300,
      height: 35,
      child: ListTile(
        title: Text(text!,style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.deepPurpleAccent,
          hoverColor: Colors.blueAccent,
          value: fWhat==forWhat.forList?selectedListIndex[index]:listMixed,
          onChanged: (bool? value) {

            setState(() {
              if (fWhat == forWhat.forList)
              {
                selectedListIndex[index] = value!;
              }
              else
              {
                listMixed = value!;
                SP.write("mix", value);
              }
            });


          },
        ),
      ),
    );
  }
}
