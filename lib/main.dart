import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.cyan,

    ),
    home: MyApp(),
  )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late String studentName, studentId, studyProgramId;
  late double studentGPA;

  final fieldText1 = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3 = TextEditingController();
  final fieldText4 = TextEditingController();

  getStudentName(name){
    this.studentName = name;
  }

  getStudentId(id){
    this.studentId = id;
  }

  getStudentProgramID(programId)
  {
    this.studyProgramId = programId;
  }

  getStudentGPA(gpa){
    this.studentGPA = double.parse(gpa);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Flutter Collage"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue , width: 2.0)
                    ),
                  ),
                  onChanged: (String name){
                    getStudentName(name);
                  },
                  controller: fieldText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Student ID",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue , width: 2.0)
                    ),
                  ),
                  onChanged: (String studentId){
                    getStudentId(studentId);
                  },
                  controller: fieldText2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Study Program ID",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue , width: 2.0)
                    ),
                  ),
                  onChanged: (String programId){
                    getStudentProgramID(programId);
                  },
                  controller: fieldText3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "GPA",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue , width: 2.0)
                    ),
                  ),
                  onChanged: (String gpa){
                    getStudentGPA(gpa);
                  },
                  controller: fieldText4,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    color: Colors.green,
                    child: Text("Create"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () { 
                      showSimpleAlert();
                     },
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    child: Text("Read"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () { 
                      readsingleData();
                     },
                  ),
                  MaterialButton(
                    color: Colors.orange,
                    child: Text("Update"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () { 
                      updateData();
                     },
                  ),
                  MaterialButton(
                    color: Colors.red,
                    child: Text("delete"),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () { 
                      deleteData();
                     },
                  )
                ],
              ),
              SizedBox(height: 20,),
              StreamBuilder(
                
                stream: FirebaseFirestore.instance.collection("MyCollage").snapshots(),
                builder: (context,AsyncSnapshot snapshot){
                  // return Text(snapshot.hasData ? '${snapshot.data}' : '');
                  if(snapshot.hasData)
                  {
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 20.0),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      
                      itemBuilder: (context, index){
                        DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                        return Container(
                          decoration: BoxDecoration(
                                      border: index == 0
                                      ? const Border() // This will create no border for the first item
                                      : Border(
                                      top: BorderSide(
                                            width: 1,
                                            color: Theme.of(context).primaryColor
                                            )
                                          ),
                          ),
                          padding: EdgeInsets.only(bottom: 10.0 , top: 10),
                          child: Row(children: [
                            Expanded(child: Container(child: Text('$index.'))),
                            Expanded(flex:3 ,child: Text(documentSnapshot["studentName"],style: TextStyle(fontSize: 15),),),
                            Expanded(child: Text(documentSnapshot["studentId"])),
                            Expanded(child: Text(documentSnapshot["studyprogramId"])),
                            Expanded(child: Text(documentSnapshot["studentGPA"].toString())),
                          ],),
                        );
                      },
                    
                    );
                  }
                  if(snapshot.hasError){
                    return Text("Error Loading Data");
                  }
                  return Text('Loading...');
                }
                )
            ],
          ),
        ),
      ),
    );
  }

  void clearText (){
    fieldText1.clear();
    fieldText2.clear();
    fieldText3.clear();
    fieldText4.clear();
  }



  // Alert dialog implementation
 Future<void> showSimpleAlert() async
  {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //user must tap on buttons
      builder: (context){
        return AlertDialog(
          title: Text("Confirmation!"),
          content: SingleChildScrollView(child: ListBody(children: [
            Text('Do you want to confirm.'),
          ],
          )
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
              createData();
            },
          ),
        ],
        );
      }
    );
  }
  createData() async {
    log("Created!");
    DocumentReference documentReference = FirebaseFirestore.instance.collection('MyCollage').doc(studentId);


    final json = <String, dynamic>{
      "studentName": studentName,
      "studentId" :studentId,
      "studyprogramId" : studyProgramId,
      "studentGPA": studentGPA
    };

    await documentReference.set(json).whenComplete(() => log("$studentName created"));
    clearText();
    
  }

// Getting all data from the firebase database
  readData() async{
    await FirebaseFirestore.instance.collection("MyCollage").get().then((event) {
  for (var doc in event.docs) {
    log("${doc.id} => ${doc.data()}");
  }
  });
}

// Reading data with the studentId
  readsingleData() async{
    log("clicked read");
    final docRef = await FirebaseFirestore.instance.collection("MyCollage").doc(studentId);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
          for (final mapEntry in data.entries) {
            final key = mapEntry.key;
            final value = mapEntry.value;
            log('Key: $key, Value: $value');  // Key: a, Value: 1 ...
            if(key == "studyprogramId"){fieldText3.text=value;}
            if(key == "studentName"){fieldText1.text=value;}
            if(key == "studentGPA"){fieldText4.text=value.toString();}
            }
      },
      onError: (e) => print("Error getting document: $e"),
);
  }
  updateData() async{
    log("Updated!");
    DocumentReference documentReference = FirebaseFirestore.instance.collection('MyCollage').doc(studentId);


    final json = <String, dynamic>{
      "studentName": studentName,
      "studentId" :studentId,
      "studyprogramId" : studyProgramId,
      "studentGPA": studentGPA
    };

    await documentReference.set(json).whenComplete(() => log("$studentName Updated"));
    clearText();

  }
  deleteData() async{
    log("Deleted!");
    DocumentReference documentReference = FirebaseFirestore.instance.collection('MyCollage').doc(studentId);
    await documentReference.delete().whenComplete(() => log("$studentId Deleted!"));
    clearText();
  }
}