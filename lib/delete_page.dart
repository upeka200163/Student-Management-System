import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final TextEditingController idCtrl = TextEditingController();

  @override
  void dispose() {
    idCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextField(
              controller: idCtrl,
              decoration: InputDecoration(
                labelText: "Id",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => idCtrl.clear(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _deleteStudent(idCtrl.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteStudent(String studentId) async {
    if (studentId.isEmpty) {
      _showSnackBar("Please enter an ID", Colors.black);
      return;
    }

    try {
      // Firestore Collection සහ Field names
      var query = await FirebaseFirestore.instance
          .collection('Students')
          .where('Studentid', isEqualTo: studentId)
          .get();

      if (query.docs.isNotEmpty) {
        for (var doc in query.docs) {
          await doc.reference.delete();
        }

        if (!mounted) return;

        // ඔබ ඉල්ලා සිටි සාර්ථක පණිවිඩය සහ ID එක clear කිරීම
        String deletedId = idCtrl.text;
        idCtrl.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ID $deletedId deleted successfully!"),
            backgroundColor:
                Colors.red, // සාර්ථක වූ විට රතු පැහැය [ඔබගේ ඉල්ලීම පරිදි]
          ),
        );
      } else {
        if (!mounted) return;
        // ID එක සොයාගත නොහැකි වූ විට රතු පැහැයෙන් පෙන්වීම
        _showSnackBar("No student found with this ID", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  // පණිවිඩය පෙන්වන SnackBar එක වර්ණය අනුව වෙනස් කළ හැකි පරිදි සකසා ඇත
  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
