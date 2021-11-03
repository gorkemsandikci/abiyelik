import 'package:abiyelik/api/register_api_service.dart';
import 'package:abiyelik/model/register_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ProgressHUD.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool hidePassword = true;
  RegisterRequestModel? requestModel;
  bool isApiCallProcess = false;

  @override
  void initState(){
    super.initState();
    requestModel = RegisterRequestModel();
  }

  @override
  Widget build(BuildContext context){
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: const Offset(0, 10),
                          blurRadius: 20),
                    ],
                  ),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Kayıt Ol",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => requestModel!.ad = input ,
                          validator: (input) => input!.length < 2
                              ? "Adınızı kontrol ediniz!."
                              : null,
                          decoration: InputDecoration(
                              hintText: "Adınız",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => requestModel!.soyad = input ,
                          validator: (input) => input!.length < 2
                              ? "Soyadınızı kontrol ediniz!."
                              : null,
                          decoration: InputDecoration(
                              hintText: "Soyadınız",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => requestModel!.email = input ,
                          validator: (input) => input!.contains("@")
                              ? null
                              : "Email adresinizi kontrol ediniz!.",
                          decoration: InputDecoration(
                              hintText: "Email Adresiniz",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => requestModel!.password = input  ,
                            validator: (input) => input!.length < 8
                                ? "Sifreniz 8 karakterden uzun olmalıdır!🔐 "
                                : null,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              hintText: "Sifreniz",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.4),
                                  icon: Icon(hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility)),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 80),
                          onPressed: (){
                            if(validateAndSave()){
                              setState(() {
                                isApiCallProcess = true;
                              });
                              print(requestModel!.toJson());

                              RegisterAPIService apiService = RegisterAPIService();
                              apiService.Register(requestModel!).then((value){
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                if(value!.token!.isNotEmpty){
                                  final snackBar = SnackBar(
                                      content: Text("Giriş Başarılı:"+value.token!)
                                  );
                                  scaffoldkey.currentState!.showSnackBar(snackBar);
                                }
                                else{
                                  final snackBar = SnackBar(
                                    content: Text(value.error!),
                                  );
                                  scaffoldkey.currentState!.showSnackBar(snackBar);
                                }
                              });
                            }
                          },
                          child: const Text("Kayıt ol",style: TextStyle(color: Colors.white),),
                          color: Theme.of(context).accentColor,
                          shape: const StadiumBorder(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave(){
    final form = globalFormKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
}
