import 'package:flutter/material.dart';
import 'package:utspaboctarian/services/mahasiswa_service.dart';

class MahasiswaListScreen extends StatefulWidget {
  const MahasiswaListScreen({Key? key}) : super(key: key);

  @override
  State<MahasiswaListScreen> createState() => _MahasiswaListScreenState();
}

class _MahasiswaListScreenState extends State<MahasiswaListScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final MahasiswaService _mahasiswaService = MahasiswaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nama mahasiswa',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _npmController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan NPM mahasiswa',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _mahasiswaService.addMahasiswaItem(
                      _namaController.text,
                      _npmController.text,
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, String>>>(
              stream: _mahasiswaService.getMahasiswaList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, String>> items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title:
                            Text(item['nama']!),
                        subtitle: Text(
                            item['npm']!),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
