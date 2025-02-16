import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../modelos/planeta.dart';

class ControlePlaneta {
  static Database? _database;

  // Obtém a instância do banco de dados, inicializando se necessário
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('planetas.db');
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase(String arquivoLocal) async {
    final caminhoBD = await getDatabasesPath();
    final caminhoCompleto = join(caminhoBD, arquivoLocal);
    return await openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: _criarDatabase,
    );
  }

  // Cria o banco de dados e a tabela planetas
  Future<void> _criarDatabase(Database db, int versao) async {
    const sql = '''
    CREATE TABLE planetas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      tamanho REAL NOT NULL,
      distancia REAL NOT NULL,
      apelido TEXT
    );
    ''';
    await db.execute(sql);
  }

  // Lê todos os planetas armazenados no banco de dados
  Future<List<Planeta>> lerPlanetas() async {
    final db = await database;
    final resultado = await db.query('planetas');
    return resultado.map((item) => Planeta.fromMap(item)).toList();
  }

  // Insere um novo planeta no banco de dados
  Future<int> inserirPlaneta(Planeta planeta) async {
    final db = await database;
    return await db.insert(
      'planetas',
      planeta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,  // Evita erro de conflito de dados
    );
  }

  // Atualiza as informações de um planeta existente
  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await database;
    return db.update(
      'planetas',
      planeta.toMap(),
      where: 'id = ?',
      whereArgs: [planeta.id],
    );
  }

  // Exclui um planeta do banco de dados com base no seu ID
  Future<int> excluirPlaneta(int id) async {
    final db = await database;
    return await db.delete(
      'planetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
