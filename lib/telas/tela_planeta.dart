import 'package:flutter/material.dart';

import '../controles/controle_planeta.dart';
import '../modelos/planeta.dart';

// Tela para cadastro e edição de um planeta
class TelaPlaneta extends StatefulWidget {
  final bool isIncluir; // Define se a tela será usada para inclusão ou edição
  final Planeta planeta; // Objeto Planeta que será manipulado
  final Function() onFinalizado; // Callback chamado após salvar

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>(); // Chave global para validação do formulário

  // Controladores para capturar os valores dos campos de entrada
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _nomeAlternativoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Controle de operações sobre planetas

  late Planeta _planeta; // Armazena o planeta atual

  @override
  void initState() {
    super.initState();
    _planeta = widget.planeta;

    // Preenchendo os campos de entrada com os valores atuais do planeta
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _nomeAlternativoController.text = _planeta.nomeAlternativo ?? '';
  }

  @override
  void dispose() {
    // Liberando os controladores de texto para evitar vazamento de memória
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _nomeAlternativoController.dispose();
    super.dispose();
  }

  // Método para inserir um novo planeta no banco de dados
  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  // Método para alterar os dados de um planeta existente
  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  // Método chamado ao pressionar o botão de salvar
  void _submitForm() {
    if (_formKey.currentState!.validate()) { // Valida o formulário
      _formKey.currentState!.save(); // Salva os valores nos objetos correspondentes

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Planeta ${widget.isIncluir ? 'criado' : 'atualizado'} com sucesso!'),
        ),
      );

      Navigator.of(context).pop(); // Fecha a tela atual
      widget.onFinalizado(); // Chama a função callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastro Planetário'),
        backgroundColor: Colors.deepPurple,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de entrada para o nome do planeta
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Planeta',
                    labelStyle: TextStyle(color: Colors.teal),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Informe um nome válido (3 ou mais caracteres)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                // Campo de entrada para o tamanho do planeta
                TextFormField(
                  controller: _tamanhoController,
                  decoration: const InputDecoration(labelText: 'Tamanho (km)'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o tamanho do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Insira um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                // Campo de entrada para a distância do planeta
                TextFormField(
                  controller: _distanciaController,
                  decoration: const InputDecoration(labelText: 'Distância (km)'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a distância do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Insira um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                // Campo de entrada para o nome alternativo do planeta
                TextFormField(
                  controller: _nomeAlternativoController,
                  decoration: const InputDecoration(labelText: 'Nome Alternativo (opcional)'),
                  onSaved: (value) {
                    _planeta.nomeAlternativo = value;
                  },
                ),
                const SizedBox(height: 20.0),
                // Botões de ação (Cancelar e Salvar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
