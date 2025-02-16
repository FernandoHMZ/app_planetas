class Planeta {
  int? id;
  String nome;
  double tamanho;
  double distancia;
  String? nomeAlternativo;

  // Construtor da classe Planeta
  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.nomeAlternativo,
  });

  // Construtor alternativo que cria um Planeta "vazio"
  Planeta.vazio()
      : nome = '',
        tamanho = 0.0,
        distancia = 0.0,
        nomeAlternativo = '';

  // Construtor de fábrica para criar um Planeta a partir de um Map
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      nomeAlternativo: map['apelido'], // Usando nomeAlternativo em vez de apelido
    );
  }

  // Método para converter a instância de Planeta em um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': nomeAlternativo, // Usando nomeAlternativo aqui também
    };
  }

  // Método para exibir informações do Planeta de maneira mais amigável
  String descricaoCompleta() {
    return 'Planeta: $nome\nTamanho: $tamanho km\nDistância: $distancia km\nApelido: ${nomeAlternativo ?? 'Nenhum apelido'}';
  }
}
