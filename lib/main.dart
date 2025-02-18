import 'package:flutter/material.dart';

import 'controles/controle_planeta.dart'; // Controle de manipulação dos planetas
import 'modelos/planeta.dart'; // Modelo de dados para os planetas
import 'telas/tela_planeta.dart'; // Tela de edição/criação de planetas

void main() {
  runApp(const MyApp()); // Inicia o aplicativo Flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Configuração principal do aplicativo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Aplicativo - Planeta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Instância do controlador de planetas
  List<Planeta> _planetas = []; // Lista que armazena os planetas

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas(); // Atualiza a lista de planetas ao iniciar
  }

  // Método para carregar os planetas da fonte de dados
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  // Navega para a tela de inclusão de um novo planeta
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: () {
            _atualizarPlanetas(); // Atualiza a lista ao finalizar
          },
        ),
      ),
    );
  }

  // Navega para a tela de edição de um planeta existente
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: () {
            _atualizarPlanetas(); // Atualiza a lista ao finalizar
          },
        ),
      ),
    );
  }

  // Exclui um planeta e atualiza a lista
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            itemCount: _planetas.length,
            itemBuilder: (context, index) {
              final planeta = _planetas[index];
              return ListTile(
                title: Text(planeta.nome), // Nome do planeta
                subtitle: Text(planeta.nomeAlternativo!), // Nome alternativo do planeta
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _alterarPlaneta(context, planeta), // Editar planeta
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _excluirPlaneta(planeta.id!), // Excluir planeta
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context); // Adicionar novo planeta
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
