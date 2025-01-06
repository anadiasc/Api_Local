import 'package:flutter/material.dart';
import 'dart:convert';
import 'envio_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> posts = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPosts();

    // Adiciona o listener para o ScrollController
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('http://localhost:8080/posts'));
    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sharing App',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _scrollController.hasClients && _scrollController.offset > 50
                ? Colors.white // Cor do texto ao rolar
                : Colors.black, // Cor do texto no topo
          ),
        ),
        backgroundColor: _scrollController.hasClients && _scrollController.offset > 50
            ? Color(0xFF03457C) // Cor de fundo do AppBar ao rolar
            : Colors.transparent, // Cor do AppBar no topo
        elevation: 0, // Remover a sombra do AppBar
      ),
      body: posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/Empty.png', 
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Você não compartilhou nenhuma imagem, clique no botão + para adicionar!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Center( // Centraliza a coluna na tela
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: posts.map((post) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 250,  // Largura fixa do Container
                        height: 320, // Altura fixa do Container
                        padding: EdgeInsets.all(16), // Espaçamento interno
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 247, 247), // Cor de fundo
                          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo dentro do Container
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            post['imagem'] != null
                                ? Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12), // Bordas arredondadas na imagem
                                      child: Image.memory(
                                        base64Decode(post['imagem']),
                                        width: 250,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Icon(Icons.image),
                            SizedBox(height: 8),
                            Text(post['texto'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EnvioPage()),
          ).then((_) => fetchPosts());
        },
        backgroundColor: Color(0xFF03457C),  // Cor de fundo do botão
        child: Icon(
          Icons.add,
          color: Colors.white,  // Cor branca para o ícone
        ),
      ),
    );
  }
}
