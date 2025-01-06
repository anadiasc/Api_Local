import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class EnvioPage extends StatefulWidget {
  @override
  _EnvioPageState createState() => _EnvioPageState();
}

class _EnvioPageState extends State<EnvioPage> {
  final _textController = TextEditingController();
  Uint8List? _image; // Armazena os bytes da imagem

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _image = result.files.single.bytes; // Armazena os bytes da imagem
      });
    }
  }

  Future<void> enviarPost() async {
    if (_image == null || _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Align(
            alignment: Alignment.center,  // Centraliza o texto
            child: Text(
              'Por favor, preencha o texto e selecione uma imagem.',
              style: TextStyle(
                color: Colors.white,  // Cor do texto
                fontSize: 20,  // Tamanho da fonte
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 212, 14, 0),  // Cor de fundo do SnackBar
        ),
      );
      return;
    }

    final base64Image = base64Encode(_image!);
    final response = await http.post(
      Uri.parse('http://localhost:8080/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'texto': _textController.text, 'imagem': base64Image}),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar o post.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Imagem',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),

            _image == null
                ? Text('Nenhuma imagem selecionada.')
                : Image.memory(
                    _image!,
                    height: 200,
                  ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: pickImage,
              child: Text(
                'Selecionar Imagem',
                style: TextStyle(
                  color: Colors.white,  // Cor do texto
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color.fromARGB(193, 0, 161, 8),  // Cor do texto no botão
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Texto'),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: enviarPost,
              child: Text(
                'Enviar',
                style: TextStyle(
                  color: Colors.white,  // Cor do texto
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF03457C),  // Cor do texto no botão
              ),
            ),

          ],
        ),
      ),
    );
  }
}
