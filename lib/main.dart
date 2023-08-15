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
      home: const MyHomePage(title: 'レシピURL・食材入力'),
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
  String recipeName = "";
  String foodName = "";
  String recipeURL = "";
  List<String> ingredientName=[];

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection("Recipe").doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

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
            const Text("料理名を入力",style: TextStyle(fontSize: 20),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 80,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    recipeName = text;
                  });
                },
              ),
            ),
            const Text("URLを入力",style: TextStyle(fontSize: 20),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 80,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    recipeURL = text;
                  });
                },
              ),
            ),
            const Text("食材を入力",style: TextStyle(fontSize: 20),),
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
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    ingredientName.add(foodName);
                  });
                },
                child: const Text("追加"),
              ),
            ),
            const SizedBox(height: 100,),
            Text("内部数値\n料理名＝$recipeName\nURL＝$recipeURL\n食材＝$ingredientName",style: const TextStyle(fontSize: 20),),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: (){
              setState(() {
                ingredientName=[];
              });
            },
            tooltip: '食材リセット',
            child: const Icon(Icons.refresh_sharp),
          ),
          SizedBox(width: MediaQuery.of(context).size.width*0.5,),
          FloatingActionButton(
            onPressed: ()async{
              for(int i=0;i<ingredientName.length;i++){
                if(await checkIfDocExists(recipeName)){
                  FirebaseFirestore.instance.collection("Recipe").doc(recipeName).set({ingredientName[i] : recipeURL},SetOptions(merge:true));
                }else{
                  FirebaseFirestore.instance.collection("Recipe").doc(recipeName).set({ ingredientName[i] : recipeURL});
                }
              }
              },
            tooltip: '確定',
            child: const Text("確"),
          ),
        ],
      ),

    );
  }
}
