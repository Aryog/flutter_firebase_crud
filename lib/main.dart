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
      body: Padding(
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
                    createData();
                   },
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: Text("Read"),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onPressed: () { 
                    readData();
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
            )
          ],
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
  }
  updateData(){
    log("Updated!");
  }
  deleteData(){
    log("Deleted!");
  }