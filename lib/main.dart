import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Thanks Doctor Nishio!!

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
  String ingredientName = "";
  String recipeName = "";
  String recipeURL = "";
  List<String> recipeNames=[];
  List<String> recipeURLs=[];

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection("Recipe").doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
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
            const Text("食材名を入力",style: TextStyle(fontSize: 20),),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              height: 80,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    ingredientName = text;
                  });
                },
              ),
            ),
            Container(
              color: Colors.grey[350],
              padding: const EdgeInsets.all(10),
              child: Column(
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
                  const Text("レシピURLを入力",style: TextStyle(fontSize: 20),),
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
                  Container(
                    width: MediaQuery.of(context).size.width*0.6,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          recipeNames.add(recipeName);
                          recipeURLs.add(recipeURL);
                        });
                      },
                      child: const Text("追加"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100,),
            Text("内部数値\n食材名＝$ingredientName\n料理名＝$recipeNames\nレシピURL＝$recipeURLs",style: const TextStyle(fontSize: 20),),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: (){
              setState(() {
                recipeNames=[];
                recipeURLs=[];
              });
            },
            tooltip: '食材リセット',
            child: const Icon(Icons.refresh_sharp),
          ),
          SizedBox(width: MediaQuery.of(context).size.width*0.5,),
          FloatingActionButton(
            onPressed: ()async{
              for(int i=0;i<recipeNames.length;i++){
                if(await checkIfDocExists(ingredientName)){
                  FirebaseFirestore.instance.collection("Recipe").doc(ingredientName).set({recipeNames[i] : recipeURLs[i]},SetOptions(merge:true));
                }else{
                  FirebaseFirestore.instance.collection("Recipe").doc(ingredientName).set({ recipeNames[i] : recipeURLs[i]});
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
