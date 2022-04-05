import 'package:flutter/material.dart';
import 'package:notas_diarias/helper/anotacao_helper.dart';
import 'package:notas_diarias/model/anotacao_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _tituloEC = TextEditingController();
  final TextEditingController _descricaoEC = TextEditingController();
  final _db = AnotacaoHelper();
  List<Anotacao?> _anotacoes = [];

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

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao> listaTemporaria = [];
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }
    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = [];
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat("dd/MM/y HH:mm:ss");
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _salvarAnotacao() async {
    String titulo = _tituloEC.text;
    String descricao = _descricaoEC.text;
    Anotacao anotacao = Anotacao(titulo, DateTime.now().toString(), descricao);
    int resultado = await _db.salvarAnotacao(anotacao);
    print('salvar anotação: ' + resultado.toString());
    _tituloEC.clear();
    _descricaoEC.clear();
    _recuperarAnotacoes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index) {
                    final anotacao = _anotacoes[index];
                    return Card(
                      child: ListTile(
                        title: Text(anotacao!.titulo.toString()),
                        subtitle: Text(
                            "${_formatarData(anotacao.data!)} - ${anotacao.descricao}"),
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exibirTelaCadastro,
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
