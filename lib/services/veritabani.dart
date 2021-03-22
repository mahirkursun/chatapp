import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final Firestore _db = Firestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();

class VeriTabaniYontem {
  kullaniciAdinaGoreKullaniciAl(String kullaniciadi) async {
    return await Firestore.instance
        .collection("kullanicilar")
        .where("name", isEqualTo: kullaniciadi)
        .getDocuments();
  }

  kullaniciEmailGoreKullaniciAl(String kullaniciEmail) async {
    return await Firestore.instance
        .collection("kullanicilar")
        .where("email", isEqualTo: kullaniciEmail)
        .getDocuments();
  }

  kullaniciBilgiYukle(String kullaniciId, kullaniciMap) {
    Firestore.instance
        .collection("kullanicilar")
        .document(kullaniciId)
        .setData(kullaniciMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  sohbetOdasiOlustur(String sohbetOdasiId, sohbetOdasiMap) {
    Firestore.instance
        .collection("SohbetOdasi")
        .document(sohbetOdasiId)
        .setData(sohbetOdasiMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addSohbetMesaj(String sohbetOdasiId, mesajMap) {
    Firestore.instance
        .collection("SohbetOdasi")
        .document(sohbetOdasiId)
        .collection("sohbet")
        .add(mesajMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getSohbetMesaj(String sohbetOdasiId) async {
    return await Firestore.instance
        .collection("SohbetOdasi")
        .document(sohbetOdasiId)
        .collection("sohbet")
        .orderBy("zaman", descending: false)
        .snapshots();
  }

  getSohbetOdasi(String kullaniciAdi) async {
    return await Firestore.instance
        .collection("SohbetOdasi")
        .where("kullanicilar", arrayContains: kullaniciAdi)
        .snapshots();
  }
}
