import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final degreeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField("Name", nameController),
            const SizedBox(height: 10),
            buildTextField("Id", idController),
            const SizedBox(height: 10),
            buildTextField("Degree", degreeController),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    idController.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("Students")
                      .doc(idController.text)
                      .set({
                        "Name": nameController.text,
                        "Studentid": idController.text,
                        "Degree": degreeController.text,
                      });

                  nameController.clear();
                  idController.clear();
                  degreeController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added Successfully!")),
                  );
                }
              },
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),

        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => controller.clear(),
        ),
      ),
    );
  }
}
