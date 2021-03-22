import 'package:chat_app/goruntuleme/sohbetodasi_ekrani.dart';

import 'package:chat_app/helper/yardimcifonk.dart';
import 'package:chat_app/services/kimlikdogrulama.dart';
import 'package:chat_app/services/veritabani.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Kaydol extends StatefulWidget {
  final Function toggle;
  Kaydol(this.toggle);

  @override
  _KaydolState createState() => _KaydolState();
}

class _KaydolState extends State<Kaydol> {
  bool isLoading = false;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  KimlikDogrulamaYontem kimlikDogrulamaYontem = new KimlikDogrulamaYontem();
  VeriTabaniYontem veriTabaniYontem = new VeriTabaniYontem();

  final formKey = GlobalKey<FormState>();
  TextEditingController kullaniciAdiTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController sifreTextEditingController =
      new TextEditingController();

  beniKaydet(String kullaniciId) async {
    if (formKey.currentState.validate()) {
      String fcmToken = await _fcm.getToken();
      Map<String, String> kullaniciBilgisiMap = {
        "name": kullaniciAdiTextEditingController.text,
        "email": emailTextEditingController.text,
        "token": fcmToken,
      };

      YardimciFonksiyon.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      YardimciFonksiyon.saveUserNameSharedPreference(
          kullaniciAdiTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      kimlikDogrulamaYontem
          .signUpWithEmailAndPassword(
              emailTextEditingController.text, sifreTextEditingController.text)
          .then((value) async {
        //print("${value.uid}");

        veriTabaniYontem.kullaniciBilgiYukle(kullaniciId, kullaniciBilgisiMap);

        YardimciFonksiyon.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SohbetOdasi()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
              child: SizedBox(
                height: 150,
                child: LoadingIndicator(
                  colors: [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC),
                  ],
                  indicatorType: Indicator.pacman,
                ),
              ),
            ))
          : Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 120.0),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/appbartext1.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value.isEmpty || value.length < 2
                                  ? "Lütfen Kullanıcı Adını Giriniz"
                                  : null;
                            },
                            controller: kullaniciAdiTextEditingController,
                            style: simpleTextStyle(),
                            decoration:
                                textFieldInputDecoration("kullanıcı adı"),
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_'{|}~]+@[a-zA_Z0-9]+\.[a-zA-Z0-9]+")
                                      .hasMatch(value)
                                  ? null
                                  : "Lütfen Email Adresini Giriniz";
                            },
                            controller: emailTextEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("e-mail"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              return value.length > 6
                                  ? null
                                  : "Lütfen Şifrenizi en az 6 Karakter Giriniz";
                            },
                            controller: sifreTextEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("şifre"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Şifreni mi Unuttun?",
                          style: simpleTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        beniKaydet(kullaniciAdiTextEditingController.text);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Kaydol",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Google ile Kaydol",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesabınız var mı ? ",
                          style: mediumTextStyle(),
                        ),
                        GestureDetector(
                          onTap: widget.toggle,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Giriş Yapın",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
