import 'package:chat_app/goruntuleme/sohbet_ekrani.dart';
import 'package:chat_app/helper/sabit.dart';
import 'package:chat_app/services/veritabani.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AramaEkrani extends StatefulWidget {
  @override
  _AramaEkraniState createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  VeriTabaniYontem veriTabaniYontem = new VeriTabaniYontem();
  TextEditingController aramatextEditingController =
      new TextEditingController();

  QuerySnapshot aramaSonuc;
  Widget aramaList() {
    return aramaSonuc != null
        ? ListView.builder(
            itemCount: aramaSonuc.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return AramaKutusu(
                kullaniciAdi: aramaSonuc.documents[index].data["name"],
                kullaniciEmail: aramaSonuc.documents[index].data["email"],
              );
            },
          )
        : Container();
  }

  aramaBaslatma() {
    veriTabaniYontem
        .kullaniciAdinaGoreKullaniciAl(aramatextEditingController.text)
        .then((value) {
      setState(() {
        aramaSonuc = value;
      });
    });
  }

//sohbet odasi kullanıcı kaydından sonra sohbet  ekranına git
  sohbetOdasiOlusturVeKonusmaBaslat({String kullaniciAdi}) {
    if (kullaniciAdi != Sabit.myName) {
      List<String> kullanicilar = [
        Sabit.myName,
        kullaniciAdi,
      ];
      String sohbetOdasiId = getSohbetOdasiId(
        Sabit.myName,
        kullaniciAdi,
      );
      Map<String, dynamic> sohbetOdasiMap = {
        "kullanicilar": kullanicilar,
        "sohbetOdasiId": sohbetOdasiId
      };
      VeriTabaniYontem().sohbetOdasiOlustur(sohbetOdasiId, sohbetOdasiMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SohbetEkrani(sohbetOdasiId)));
    } else {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("UYARI"),
          content: const Text("Kendine Mesaj Gönderemezsin"),
          actions: [
            new FlatButton(
              child: const Text("Kapat"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget AramaKutusu({String kullaniciAdi, String kullaniciEmail}) {
    return Container(
      color: Colors.white,
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kullaniciAdi,
                  style: simpleTextStyle(),
                ),
                Text(
                  kullaniciEmail,
                  style: simpleTextStyle(),
                )
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                sohbetOdasiOlusturVeKonusmaBaslat(kullaniciAdi: kullaniciAdi);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(40)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.message,
                      size: 25,
                      color: Colors.blue[900],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Mesaj",
                      style: TextStyle(color: Colors.blue[900], fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSohbetOdasiId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 15),
                      child: TextField(
                        controller: aramatextEditingController,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              aramaBaslatma();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(40)),
                              child: Icon(
                                Icons.search,
                                size: 35,
                              ),
                            ),
                          ),
                          hintText: "Kullanıcı Adı Ara",
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 4,
            ),
            aramaList(),
          ],
        ),
      ),
    );
  }
}
