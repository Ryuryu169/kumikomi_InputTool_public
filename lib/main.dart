import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '賞味期限入力'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String foodName = "";
  int expiryDate = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("食材名を入力",style: TextStyle(fontSize: 20),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 80,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    foodName = text;
                  });
                },
              ),
            ),
            const Text("賞味期限を入力",style: TextStyle(fontSize: 20),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 80,
              child: TextField(
                onChanged: (text){
                  var num = int.tryParse(text);
                  setState(() {
                    if(num!=null){
                      expiryDate = num;
                    }
                  });
                  },
              ),
            ),
            const SizedBox(height: 100,),
            Text("内部数値\n食材名＝$foodName\n賞味期限＝$expiryDate",style: const TextStyle(fontSize: 20),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await FirebaseFirestore.instance.collection("Date").doc(foodName).set({'date':expiryDate});
          foodName="";
          expiryDate=0;
        },
        tooltip: '確定',
        child: const Text("確"),
      ),
    );
  }
}
