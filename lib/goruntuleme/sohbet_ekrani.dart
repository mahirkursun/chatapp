import 'package:chat_app/goruntuleme/sohbetodasi_ekrani.dart';
import 'package:chat_app/helper/sabit.dart';
import 'package:chat_app/services/veritabani.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class SohbetEkrani extends StatefulWidget {
  final String sohbetOdasiId;
  SohbetEkrani(this.sohbetOdasiId);
  @override
  _SohbetEkraniState createState() => _SohbetEkraniState();
}

class _SohbetEkraniState extends State<SohbetEkrani> {
  VeriTabaniYontem veriTabaniYontem = new VeriTabaniYontem();
  TextEditingController mesajController = new TextEditingController();
  Stream sohbetMesajStream;

  Widget sohbetMesajList() {
    return StreamBuilder(
      stream: sohbetMesajStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data.documents[index];
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
                                setState(() {
                                  Firestore.instance
                                      .collection("SohbetOdasi")
                                      .document(widget.sohbetOdasiId)
                                      .collection("sohbet")
                                      .document(document.documentID)
                                      .updateData({
                                    "mesaj": "🚫 Bu mesaj silindi",
                                  });
                                });
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
                    child: MesajKutusu(
                        snapshot.data.documents[index].data["mesaj"],
                        snapshot.data.documents[index].data["gonderen"] ==
                            Sabit.myName),
                  );
                })
            : Container();
      },
    );
  }

  mesajGonder() {
    if (mesajController.text.isNotEmpty) {
      Map<String, dynamic> mesajMap = {
        "mesaj": mesajController.text,
        "gonderen": Sabit.myName,
        "zaman": DateTime.now().millisecondsSinceEpoch,
      };
      veriTabaniYontem.addSohbetMesaj(widget.sohbetOdasiId, mesajMap);

      print(mesajMap);
      setState(() {
        mesajController.text = "";
      });
    }
  }

  @override
  void initState() {
    veriTabaniYontem.getSohbetMesaj(widget.sohbetOdasiId).then((value) {
      setState(() {
        sohbetMesajStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            sohbetMesajList(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 75,
                  color: Colors.white,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      height: 55,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                style: TextStyle(fontSize: 18),
                                controller: mesajController,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      mesajGonder();
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[350],
                                          borderRadius:
                                              BorderRadius.circular(45)),
                                      child: Icon(
                                        Icons.send,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  hintText: "Mesaj...",
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MesajKutusu extends StatelessWidget {
  final String mesaj;
  final bool gonderilenMesaj;
  MesajKutusu(this.mesaj, this.gonderilenMesaj);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.only(
            left: gonderilenMesaj ? 24 : 16, right: gonderilenMesaj ? 16 : 24),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment:
            gonderilenMesaj ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gonderilenMesaj
                  ? [const Color(0xffC0C0C0), const Color(0xffC0C0C0)]
                  : [const Color(0xffFFFFFF), const Color(0xffEEEEEE)],
            ),
            borderRadius: gonderilenMesaj
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
          ),
          child: Text(
            mesaj,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
