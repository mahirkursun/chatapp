import 'package:chat_app/goruntuleme/sohbetodasi_ekrani.dart';
import 'package:chat_app/helper/fadeanimation.dart';
import 'package:chat_app/helper/yardimcifonk.dart';
import 'package:chat_app/services/kimlikdogrulama.dart';
import 'package:chat_app/services/veritabani.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class OturumAc extends StatefulWidget {
  final Function toggle;
  OturumAc(this.toggle);

  @override
  _OturumAcState createState() => _OturumAcState();
}

class _OturumAcState extends State<OturumAc> {
  final formKey = GlobalKey<FormState>();
//final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  KimlikDogrulamaYontem kimlikDogrulamaYontem = new KimlikDogrulamaYontem();
  VeriTabaniYontem veriTabaniYontem = new VeriTabaniYontem();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController sifreTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotKullaniciBilgi;

  oturumAc() {
    if (formKey.currentState.validate()) {
      YardimciFonksiyon.saveUserEmailSharedPreference(
          emailTextEditingController.text);
//     firebaseMessaging.getToken().then((token) {
//      saveTokens(token);
//    });

      veriTabaniYontem
          .kullaniciEmailGoreKullaniciAl(emailTextEditingController.text)
          .then((value) {
        snapshotKullaniciBilgi = value;
        YardimciFonksiyon.saveUserNameSharedPreference(
            snapshotKullaniciBilgi.documents[0].data["name"]);
      });

      setState(() {
        isLoading = true;
      });

      kimlikDogrulamaYontem
          .signInWithEmailAndPassword(
              emailTextEditingController.text, sifreTextEditingController.text)
          .then((value) {
        if (value != null) {
          YardimciFonksiyon.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SohbetOdasi()));
        }
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
                child: FadeAnimation(
                  1.6,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 58.0),
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
                        child: FadeAnimation(
                          1.7,
                          Column(
                            children: [
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
                                decoration: textFieldInputDecoration("email"),
                              ),
                              TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  return value.length > 6
                                      ? null
                                      : "Lütfen Şifrenizi en az 6 Karakter Giriniz";
                                },
                                controller: sifreTextEditingController,
                                decoration: textFieldInputDecoration("şifre"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      FadeAnimation(
                        1.8,
                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Şifreni mi Unuttun?",
                              style: simpleTextStyle(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          oturumAc();
                        },
                        child: FadeAnimation(
                          1.9,
                          Container(
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
                              "Oturum Aç",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FadeAnimation(
                        2.0,
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Google ile Giriş Yap",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FadeAnimation(
                        2.0,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hesabınız yok mu ? ",
                              style: mediumTextStyle(),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Kaydolun",
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
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
