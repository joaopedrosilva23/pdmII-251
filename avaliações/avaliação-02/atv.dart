// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {'nome': _nome};
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  // Método de cria que retorna um json
  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList()
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeDoProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList()
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  Dependente dp1 = new Dependente("Thiago");
  Dependente dp2 = new Dependente("Sara");
  Dependente dp3 = new Dependente("Tito");
  Dependente dp4 = new Dependente("Clara");

  // 2. Criar varios objetos Funcionario
  Funcionario func1 = new Funcionario("Sávio", [dp1, dp2]);
  Funcionario func2 = new Funcionario("Wendell", [dp2, dp3]);
  Funcionario func3 = new Funcionario("Alysson", [dp4]);

  //DEBUG
  //String info = jsonEncode(func1.toJson());
  //print(info);

  // 3. Associar os Dependentes criados aos respectivos
  //    funcionarios

  // 4. Criar uma lista de Funcionarios
  List<Funcionario> listFuncionarios = [func1, func2, func3];
  // 5. criar um objeto Equipe Projeto chamando o metodo
  //    contrutor que da nome ao projeto e insere uma
  //    coleção de funcionario
  EquipeProjeto equp1 = new EquipeProjeto("Projeto Dolphin", listFuncionarios);
  // 6. Printar no formato JSON o objeto Equipe Projeto.
  String info = jsonEncode(equp1.toJson());

  print(info);
}