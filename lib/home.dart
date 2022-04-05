import 'package:flutter/material.dart';
import 'package:notas_diarias/helper/anotacao_helper.dart';
import 'package:notas_diarias/model/anotacao_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _tituloEC = TextEditingController();
  final TextEditingController _descricaoEC = TextEditingController();
  var _db = AnotacaoHelper();

  _exibirTelaCadastro() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloEC,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título...",
                  ),
                ),
                TextField(
                  controller: _descricaoEC,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite descrição...",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _salvarAnotacao();
                  Navigator.pop(context);
                },
                child: Text('Salvar'),
              ),
            ],
          );
        });
  }

  _salvarAnotacao() async {
    String titulo = _tituloEC.text;
    String descricao = _descricaoEC.text;
    Anotacao anotacao = Anotacao(titulo, DateTime.now().toString(), descricao);
    int resultado = await _db.salvarAnotacao(anotacao);
    print('salvar anotação: ' + resultado.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirTelaCadastro,
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
