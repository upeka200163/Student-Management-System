import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePage extends StatefulWidget {
  final Map student;

  const UpdatePage(this.student, {super.key});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController name;
  late TextEditingController id;
  late TextEditingController degree;

  @override
  void initState() {
    super.initState();
    
    name = TextEditingController(text: widget.student["Name"]);
    id = TextEditingController(text: widget.student["Studentid"]);
    degree = TextEditingController(text: widget.student["Degree"]);
  }

  @override
  void dispose() {
    name.dispose();
    id.dispose();
    degree.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Update", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, 
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
           
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: "Name",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => name.clear(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            
            TextField(
              controller: id,
              decoration: InputDecoration(
                labelText: "Id", 
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => id.clear(),
                ),
              ),
            ),
            const SizedBox(height: 15),

            
            TextField(
              controller: degree,
              decoration: InputDecoration(
                labelText: "Degree",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => degree.clear(),
                ),
              ),
            ),
            const SizedBox(height: 30),

            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () async {
                try {
                  
                  await FirebaseFirestore.instance
                      .collection("Students")
                      .doc(widget.student["key"])
                      .update({
                        "Name": name.text,
                        "Degree": degree.text,
                        "Studentid":
                            id.text, 
                      });

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Student updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text("Update", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
