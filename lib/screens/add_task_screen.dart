import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();

  addtasktofirebase()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance.collection('tasks')
        .doc(uid).collection('mytasks')
        .doc(time.toString()).set({
      'title' : titlecontroller.text,
      'description' : desccontroller.text,
      'time' : time.toString(),
      'timestamp' : time
    });
    Fluttertoast.showToast(msg: 'Task Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                labelText: 'Enter Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: desccontroller,
              decoration: InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                  onPressed: (){
                    addtasktofirebase();
                  },
                  child: Text('Add Task', style: GoogleFonts.roboto(color: Colors.white),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states){
                            if(states.contains(MaterialState.pressed))
                              return Colors.purple.shade100;
                            return Theme.of(context).primaryColor;
                  })
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
