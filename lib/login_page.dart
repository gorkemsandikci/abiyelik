import 'package:abiyelik/app.dart';
import 'package:abiyelik/api/api_service.dart';
import 'package:abiyelik/model/login_model.dart';
import 'package:abiyelik/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel? requestModel;
  bool isApiCallProcess = false;

  @override
  void initState(){
    super.initState();
    requestModel = LoginRequestModel();
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
                          "Giriş",
                          style: Theme.of(context).textTheme.headline2,
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
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "YourRoute");
                          },
                          child:
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:  EdgeInsets.all(10.0),
                              child:  Text("Şifremi Unuttum"),
                            ),
                          ),
                        ),
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

                              APIService apiService = APIService();
                              apiService.login(requestModel!).then((value){
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                if(value!.token!.isNotEmpty){
                                  final snackBar = SnackBar(
                                      content: Text("Giriş Başarılı:"+value.token!)
                                  );
                                  scaffoldkey.currentState!.showSnackBar(snackBar);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => App()),
                                  );
                                }
                                else{
                                  final snackBar = SnackBar(
                                    content: Text(value.error!),
                                  );
                                  scaffoldkey.currentState!.showSnackBar(snackBar);
                                  /*----This----*/
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => App()),
                                  );
                                  /*----end----*/
                                }
                              });


                            }
                          },
                          child: const Text("Giriş",style: TextStyle(color: Colors.white),),
                          color: Theme.of(context).accentColor,
                          shape: const StadiumBorder(),
                        ),
                        const SizedBox(
                            height : 15
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child:
                          const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:  EdgeInsets.all(10.0),
                              child:  Text("Üye Ol"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => App()),
                            );
                          },
                          child:
                          const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:  EdgeInsets.all(10.0),
                              child:  Text("Üye Olmadan Devam Et"),
                            ),
                          ),
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
