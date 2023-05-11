import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_firebase/screens/add_task_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String uid = '';

  @override
  void initState() {
    // TODO: implement initState
    gettask();
    super.initState();
  }

  gettask()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else{
            final docu = snapshot.data!.docs;
            return ListView.builder(
                itemCount: docu.length,
                itemBuilder: (context,index){
                  var time = (docu[index]['timestamp'] as Timestamp)
                  .toDate();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(DateFormat.yMd().add_jm().format(time)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(docu[index]['title'], style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                    ),),
                                    Text(docu[index]['description']),
                                  ],
                                ),
                                InkWell(child: Icon(Icons.delete), onTap: ()async{
                                  await FirebaseFirestore.instance.collection('tasks')
                                      .doc(uid).collection('mytasks')
                                      .doc(docu[index]['time']
                                      ).delete();
                                },)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
            });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTask()));
        },
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor:Theme.of(context).primaryColor,
      ),
    );
  }
}
