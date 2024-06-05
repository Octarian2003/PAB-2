import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_loker_pab/models/loker.dart';
import 'package:info_loker_pab/services/ServicesLoker.dart';

class UploadLokerScreen extends StatefulWidget {
  final Loker? loker;

  const UploadLokerScreen({super.key, this.loker});

  @override
  State<UploadLokerScreen> createState() => _UploadLokerScreenState();
}

class _UploadLokerScreenState extends State<UploadLokerScreen> {
  final _titleController = TextEditingController();
  final _alamatController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tanggalController = TextEditingController();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.loker != null) {
      _titleController.text = widget.loker!.title;
      _alamatController.text = widget.loker!.alamat;
      _deskripsiController.text = widget.loker!.deskripsi;
      _tanggalController.text = widget.loker!.tanggal;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _alamatController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _alamatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _tanggalController,
              decoration: InputDecoration(labelText: 'Tanggal'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_imageFile == null ? 'Pick Image' : 'Image Selected'),
            ),
            SizedBox(height: 5.0),
            _imageFile != null
                ? Image.network((_imageFile!.path))
                : Container(),
            ElevatedButton(
              onPressed: () async {
                String? urlimage;
                if (_imageFile != null) {
                  urlimage = await LokerService.uploadImage(_imageFile!);
                } else {
                  urlimage = widget.loker?.urlimage;
                }
                Loker loker = Loker(
                  id: widget.loker?.id,
                  title: _titleController.text,
                  alamat: _alamatController.text,
                  deskripsi: _deskripsiController.text,
                  tanggal: _tanggalController.text,
                  urlimage: urlimage,
                  createdAt: widget.loker?.createdAt,
                );
                try {
                  if (widget.loker == null) {
                    await LokerService.addLoker(loker);
                    //Clear Manual
                    _titleController.clear();
                    _alamatController.clear();
                    _deskripsiController.clear();
                    _tanggalController.clear();
                    setState() {
                      _imageFile = null;
                    }
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product uploaded successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload product')),
                  );
                }
              },
              child: Text('Upload Product'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
