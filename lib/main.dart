import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';



final controller_crypt = TextEditingController();
final controller_key = TextEditingController();
final controller_crypted = TextEditingController();

bool bool_crypt=true;

String selected_crypt="sh";




randChar() {
  var rng = Random();
  String matrix="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  return matrix[rng.nextInt(matrix.length-1)];
}

var cache_string=[];
randString(n) {
  String str="";
  for(int i=0;i<n;i++) {
    str=str+randChar();
  }
  if (cache_string.contains(str)) {
    return randString(n);
  }
  cache_string.add(str);
  return str;
}



limitText(text,limit) {

  limit=text.length<limit?text.length:limit;

  return text.substring(0,limit);
/*
  String str="";
  for(int i=0;i<limit; i++) {
    str+=text[i];
  }

  return str;

 */
}


getDateTimeCutted(datetime) {
  try {
    if (datetime != "") {
      var sp = datetime.split(" ");
      var hour = sp[1];
      var hour_sp = hour.split(":");
      var h = hour_sp[0];
      var i = hour_sp[1];
      return h + "h" + i;
    } else {
      return "";
    }
  } catch (e) {
    return "";
  }
}


getDateTimeCutted2(datetime) {
  if (datetime!=null) {
    try {
      var datetime_sp = datetime.split(" ");
      String date = datetime_sp[0];
      String time = datetime_sp[1];
      var date_sp = date.split("-");
      var time_sp = time.split(":");
      String d = date_sp[2];
      String m = date_sp[1];
      String h = time_sp[0];
      String i = time_sp[1];

      String now = DateTime.now().toString().split(".")[0];
      String today = now.split(" ")[0];

      if (date == today) {
        datetime = h + "h" + i;
      } else if (DateTime
          .parse(date + " 00:00:00")
          .difference(
          DateTime.parse(today + " 00:00:00"))
          .inDays == 1) {
        datetime = "yesterday " + h + "h" + i;
      } else {
        datetime = d + "/" + m + " " + h + "h" + i;
      }
      return datetime;
    } catch (e) {
      return "";
    }
  } else {
    return "";
  }
}

void random(start,end) {
  return (start+Random().nextInt(end-start+1));
}


String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class crypt {
  //static String key=
  //    "Your-key-here";

  static String md5_(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String rev(String s) {
    return s
        .split('')
        .reversed
        .join();
  }
  static String sh(String s, int d) {
    int g = 1;
    var ns={};
    for (int i = 0; i < s.length; i++) {
      if (g > d) {
        g = 1;
      }
      if (ns[g] == null) {
        ns[g] = "";
      }
      if (s[i] != '') {
        ns[g] += s[i];
      }
      g++;
    }
    String r = '';
    for (int a = 1; a <= d; a++) {
      r += ns[a] + '';
    }
    return r;
  }
  static String unsh(String s,int l) {
    int c = 0;
    int a = 0;
    var arr={};
    for (int i = 0; i < s.length; i++) {
      arr[c] = s[i];
      if (c < (s.length - l)) {
        c += l;
      } else {
        a++;
        c = a;
      }
    }
    String r = '';
    for (int i = 0; i < s.length; i++) {
      r = r + '' + arr[i] + '';
    }
    return r;
  }

  static String cesar(String s, int n, bool rv) {
    var matrix={};
    matrix[0] = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz";
    matrix[1] = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String r = "";
    for (int a = 0; a <= 1; a++) {
      String m = matrix[a];
      r = "";
      for (int i = 0; i < s.length; i++) {
        int p = m.indexOf(s[i]);
        int sm;
        if (p >= 0) {
          if (rv) {
            sm = (p) - n;
          } else {
            sm = (p) + n;
          }
          while (sm >= 52) {
            sm -= 26;
          }
          while (sm < 0) {
            sm += 26;
          }
          r += m[sm];
        } else {
          r += s[i];
        }
      }
      s = r;
    }
    return r;
  }
  static int sumString(String s) {
    int sum = 0;
    for (int i = 1; i < s.length; i++) {
      sum += 1;
    }
    return sum + s.length;
  }
  static int charVal(String c) {
    String m = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int p = m.indexOf(c);
    if (p > 0) {
      return p;
    }
    return 0;
  }
  static String viginere(String s, String k, bool rv) {
    int kl = k.length;
    int cn = 0;
    String r = "";
    for (int i = 0; i < s.length; i++) {
      if (cn == kl) {
        cn = 0;
      }
      r += cesar(s[i], charVal(k[cn]), rv);
      cn++;
    }
    return r;
  }
  static String randString(int n) {
    String m='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    int l = m.length;
    var rng = new Random();
    String r='';
    for (var i = 0; i < n; i++) {
      r+=m[rng.nextInt(l)];
    }
    return r;
  }
  static String b64encode(String str) {
    return base64.encode(utf8.encode(str));
  }
  static String b64decode(String str) {
    return utf8.decode(base64.decode(str));
  }


  static String fuckyou(msg,key,reverse,revert) {
    if (revert) {
      if (
      key.contains("f") ||
          key.contains("U") ||
          key.contains("c") ||
          key.contains("K") ||
          key.contains("y") ||
          key.contains("O") ||
          key.contains("u") ||
          key.contains("!")
      ) {} else {
        msg = viginere(msg, key, reverse);
      }
    } else {
      if (
      key.contains("f") ||
          key.contains("U") ||
          key.contains("c") ||
          key.contains("K") ||
          key.contains("y") ||
          key.contains("O") ||
          key.contains("u") ||
          key.contains("!")
      ) {
        msg = viginere(msg, key, reverse);
      }
    }
    return msg;
  }

  /*
    for(var i=0;i<key.length-1;i++) {
      var v=charVal(key[i]);
    }
   */

  static String cr(msg,key) {
    msg=msg+randChar();
    msg=fuckyou(msg,key,false,true);
    msg=msg+randChar();
    msg=sh(msg,3);
    msg=msg+randChar();
    msg=viginere(msg,key,true);
    msg=msg+randChar();
    msg=unsh(msg,4);
    msg=msg+randChar();
    msg=fuckyou(msg,key,false,false);
    msg=msg+randChar();
    msg=b64encode(msg);
    msg=msg+randChar();
    msg=sh(msg,5);
    msg=msg+randChar();
    msg=unsh(msg,3);
    return msg;
  }
  static String dc(msg,key) {
    msg=sh(msg,3);
    msg=msg.substring(0,msg.length-1);
    msg=unsh(msg,5);
    msg=msg.substring(0,msg.length-1);
    msg=b64decode(msg);
    msg=msg.substring(0,msg.length-1);
    msg=fuckyou(msg,key,true,false);
    msg=msg.substring(0,msg.length-1);
    msg=sh(msg,4);
    msg=msg.substring(0,msg.length-1);
    msg=viginere(msg,key,false);
    msg=msg.substring(0,msg.length-1);
    msg=unsh(msg,3);
    msg=msg.substring(0,msg.length-1);
    msg=fuckyou(msg,key,true,true);
    msg=msg.substring(0,msg.length-1);
    return msg;
  }
}


/*
void test() {
  var t="hello world";
  var k="aloha";
  var c=sh(t,3);
  var d=unsh(c,3);
  var cs=cesar(t,2,false);
  var uc=cesar(cs,2,true);
  var vg=viginere(t,k,false);
  var uv=viginere(vg,k,true);
  print(c);
  print(d);
  print(cs);
  print(uc);
  print(vg);
  print(uv);
}
 */





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

br(n) {
  return Container(height: n);
}


buttonBody(color,height,padding,widget) {
  var decoration = BoxDecoration(
      color: color,
      border: Border.all(
        color: color,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5))
  );
  var padding_ = Padding(
    padding: EdgeInsets.all(padding),
    child: Center(child: widget),
  );
  return height > 0 ? Container(
      width: double.infinity,
      height: height,
      decoration: decoration,
      child: padding_
  ) : Container(
      width: double.infinity,
      decoration: decoration,
      child: padding_
  );
}

button(title,color,size) {
  return buttonBody(
      color,
      size=="sm"?25.0:35.0,
      8.0,
      Text(title,style:TextStyle(color:Colors.white))
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  initState() {

    controller_crypt.text="Hello World";
    controller_key.text="3";
    apply();

    super.initState();
  }



  apply() {
    try {
      if (selected_crypt == "cs") {
        if (bool_crypt) {
          controller_crypted.text =
              crypt.cesar(
                  controller_crypt.text, int.parse(controller_key.text),
                  false);
        } else {
          controller_crypted.text =
              crypt.cesar(
                  controller_crypt.text, int.parse(controller_key.text), true);
        }
      } else if (selected_crypt == "vg") {
        if (bool_crypt) {
          controller_crypted.text =
              crypt.viginere(
                  controller_crypt.text, controller_key.text, false);
        } else {
          controller_crypted.text =
              crypt.viginere(controller_crypt.text, controller_key.text, true);
        }
      } else if (selected_crypt == "sh") {
        if (bool_crypt) {
          controller_crypted.text =
              crypt.sh(controller_crypt.text, int.parse(controller_key.text));
        } else {
          controller_crypted.text =
              crypt.unsh(
                  controller_crypt.text, int.parse(controller_key.text));
        }
      } else if (selected_crypt == "b64") {
        if (bool_crypt) {
          controller_crypted.text =
              crypt.b64encode(controller_crypt.text);
        } else {
          controller_crypted.text =
              crypt.b64decode(controller_crypt.text);
        }
      } else if (selected_crypt == "wh") {
        if (bool_crypt) {
          controller_crypted.text =
              crypt.cr(controller_crypt.text, controller_key.text);
        } else {
          controller_crypted.text =
              crypt.dc(controller_crypt.text, controller_key.text);
        }
      }
    } catch(e) {
      //toast("Error on crypt/decrypt");
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    String title_ = "";
    if (selected_crypt == "cs" || selected_crypt == "sh") {
      title_="Number";
    }
    if (selected_crypt == "vg" || selected_crypt == "wh") {
      title_="Key";
    }

    return Scaffold(
      body: ListView(
          reverse: true,
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          children: <Widget>[Column(children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 45.0, bottom: 15.0, left: 30.0, right: 30.0),
          child: Column(children: [


            Row(children: [

              Expanded(flex: 20, child: GestureDetector(onTap: () {
                setState(() {
                  if (!bool_crypt) {
                    String c1=controller_crypt.text;
                    String c2=controller_crypted.text;
                    controller_crypt.text=c2;
                    controller_crypted.text=c1;
                    bool_crypt = true;
                  }
                });
              }, child: button("Crypt",
                  bool_crypt ? Colors.blue : Colors.grey,""))),


              Expanded(flex: 1, child: Container()),

              Expanded(flex: 20, child: GestureDetector(onTap: () {
                setState(() {
                  if (bool_crypt) {
                    String c1=controller_crypt.text;
                    String c2=controller_crypted.text;
                    controller_crypt.text=c2;
                    controller_crypted.text=c1;
                    bool_crypt = false;
                  }
                });
              }, child: button("Decrypt",
                  bool_crypt ? Colors.grey : Colors.blue,""))),

            ]),


            br(15.0),





            GestureDetector(onTap: () {
              setState(() {
                selected_crypt = "cs";

                controller_key.text="3";

                apply();
              });
            },
                child: button("Caesar",
                    selected_crypt == "cs" ? Colors.blue : Colors.grey,"")),
            br(5.0),
            GestureDetector(onTap: () {
              setState(() {
                selected_crypt = "vg";
                controller_key.text="your key here";
                apply();
              });
            },
                child: button("Viginere",
                    selected_crypt == "vg" ? Colors.blue : Colors.grey,"")),
            br(5.0),
            GestureDetector(onTap: () {
              setState(() {
                selected_crypt = "sh";
                controller_key.text="3";
                apply();
              });
            },
                child: button("Shuffle",
                    selected_crypt == "sh" ? Colors.blue : Colors.grey,"")),
            br(5.0),
            GestureDetector(onTap: () {
              setState(() {
                selected_crypt = "b64";
                apply();
              });
            },
                child: button("Base64",
                    selected_crypt == "b64" ? Colors.blue : Colors.grey,"")),
            br(5.0),
            GestureDetector(onTap: () {
              setState(() {
                selected_crypt = "wh";
                controller_key.text="your key here";
                apply();
              });
            },
                child: button("WhiteHats",
                    selected_crypt == "wh" ? Colors.blue : Colors.grey,"")),
            br(15.0),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bool_crypt ? "Your text here" : "Text crypted"),
                br(5.0),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xFF999999),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      onChanged: (String value) {
                        apply();
                      },
                      style: TextStyle(fontSize: 15),
                      controller: controller_crypt,
                      //obscureText: true,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        //labelText: 'Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            br(10.0),

            selected_crypt != "b64"
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title_,style:TextStyle(fontSize: 14)),
                br(5.0),
                Container(
                    width: double.infinity,
                    height: 40,

                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF999999),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0),
                      child: TextField(
                        onChanged: (value) {
                          apply();
                        },
                        style:TextStyle(fontSize: 15),
                        controller: controller_key,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          //labelText: 'Password',
                        ),
                      ),
                    )
                ),
              ],
            )
                : Container(),
            selected_crypt != "b64" ? br(10.0) : Container(),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bool_crypt ? "Text crypted" : "Your decrypted"),
                br(5.0),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xFF999999),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      style: TextStyle(fontSize: 15),
                      controller: controller_crypted,
                      //obscureText: true,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        //labelText: 'Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            br(30.0),

          ],),
        )]),
      ],), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

