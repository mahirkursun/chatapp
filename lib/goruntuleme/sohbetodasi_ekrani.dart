import 'package:chat_app/goruntuleme/arama.dart';
import 'package:chat_app/goruntuleme/sohbet_ekrani.dart';
import 'package:chat_app/helper/dogrulama.dart';
import 'package:chat_app/helper/sabit.dart';
import 'package:chat_app/helper/yardimcifonk.dart';
import 'package:chat_app/services/kimlikdogrulama.dart';
import 'package:chat_app/services/veritabani.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

class SohbetOdasi extends StatefulWidget {
  @override
  _SohbetOdasiState createState() => _SohbetOdasiState();
}

class _SohbetOdasiState extends State<SohbetOdasi> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final key = GlobalKey<ScaffoldState>();

  KimlikDogrulamaYontem kimlikDogrulamaYontem = new KimlikDogrulamaYontem();
  VeriTabaniYontem veriTabaniYontem = new VeriTabaniYontem();

  Stream sohbetOdasiStream;

  Widget sohbetOdasiList() {
    return StreamBuilder(
      stream: sohbetOdasiStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return SohbetOdasiKutusu(
                    snapshot.data.documents[index].data["sohbetOdasiId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Sabit.myName, ""),
                    snapshot.data.documents[index].data["sohbetOdasiId"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getKullaniciBilgi();

    super.initState();
    firebaseMessaging.getToken().then((value) => print("Token : " + value));
    firebaseMessaging.configure(
      //called when app is in foreground
      onMessage: (Map<String, dynamic> message) async {
        print('init called onMessage');
        final snackBar = SnackBar(
          content: Text(message['notification']['body']),
          action: SnackBarAction(label: 'GO', onPressed: () {}),
        );
        key.currentState.showSnackBar(snackBar);
      },
      //called when app is completely closed and open from push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('init called onLaunch');
      },
      //called when app is in background  and open from push notification

      onResume: (Map<String, dynamic> message) async {
        print('init called onResume');
      },
    );
  }

  getKullaniciBilgi() async {
    Sabit.myName = await YardimciFonksiyon.getUserNameSharedPreference();
    veriTabaniYontem.getSohbetOdasi(Sabit.myName).then((value) {
      setState(() {
        sohbetOdasiStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 50),
            child: Image.asset(
              "images/appbartext.png",
              height: 70,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              kimlikDogrulamaYontem.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dogrulama()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: sohbetOdasiList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: Icon(
          Icons.search,
          size: 28,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AramaEkrani()));
        },
      ),
    );
  }
}

class SohbetOdasiKutusu extends StatelessWidget {
  final String kullaniciAdi;
  final String sohbetOdasiId;
  SohbetOdasiKutusu(this.kullaniciAdi, this.sohbetOdasiId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("UYARI"),
            content: const Text("Silmek istiyor musunuz?"),
            actions: [
              new FlatButton(
                child: const Text("Evet"),
                onPressed: () {
                  Firestore.instance
                      .collection("SohbetOdasi")
                      .document(sohbetOdasiId)
                      .delete();

                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: const Text("Hayır"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SohbetEkrani(sohbetOdasiId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(6)),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xff145C9E),
                    ),
                    child: Center(
                        child: Text(
                      kullaniciAdi.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Text(
                    kullaniciAdi,
                    style: mediumTextStyle(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
