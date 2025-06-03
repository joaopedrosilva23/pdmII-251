import 'dart:convert';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Professor {
  int id;
  String codigo;
  String nome;
  List<Disciplina> disciplinas = [];

  Professor({required this.id, required this.codigo, required this.nome});

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'nome': nome,
        'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
      };
}

class Aluno {
  int id;
  String nome;
  String matricula;

  Aluno({required this.id, required this.nome, required this.matricula});

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'matricula': matricula,
      };
}

class Disciplina {
  int id;
  String descricao;
  int qtdAulas;

  Disciplina(
      {required this.id, required this.descricao, required this.qtdAulas});

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'qtdAulas': qtdAulas,
      };
}

class Curso {
  int id;
  String descricao;
  List<Professor> professores = [];
  List<Aluno> alunos = [];
  List<Disciplina> disciplinas = [];

  Curso({required this.id, required this.descricao});

  void adicionarProfessor(Professor professor) {
    professores.add(professor);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'professores': professores.map((p) => p.toJson()).toList(),
        'alunos': alunos.map((a) => a.toJson()).toList(),
        'disciplinas': disciplinas.map((d) => d.toJson()).toList(),
      };
}

void main() async {
  // Criando dados
  var d1 = Disciplina(id: 1, descricao: "Banco de Dados", qtdAulas: 40);
  var d2 = Disciplina(id: 2, descricao: "Programação Web 1", qtdAulas: 40);

  var p1 = Professor(id: 1, codigo: "P001", nome: "Ricardo Taveira");
  var p2 = Professor(id: 2, codigo: "P002", nome: "José Roberto");
  p1.adicionarDisciplina(d1);
  p2.adicionarDisciplina(d2);

  var a1 = Aluno(id: 1, nome: "João Pedro", matricula: "20231001");
  var a2 = Aluno(id: 2, nome: "Gustavo Fontenele", matricula: "20231002");

  var curso = Curso(id: 10, descricao: "Curso Técnico de Informática");
  curso.adicionarProfessor(p1);
  curso.adicionarProfessor(p2);
  curso.adicionarAluno(a1);
  curso.adicionarAluno(a2);
  curso.adicionarDisciplina(d1);
  curso.adicionarDisciplina(d2);

  // JSON
  String jsonCurso = jsonEncode(curso.toJson());

  // Salva em arquivo (opcional)
  final file = File('curso.json');
  await file.writeAsString(jsonCurso);

  // Credenciais do Gmail ou outro SMTP (substitua pelos seus dados)
  String username = 'pedro.joao10@aluno.ifce.edu.br';
  String password = 'tvpj prgs npze diiv';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'Prova pratica 01')
    ..recipients.add('taveira@ifce.edu.br')
    ..subject = 'Dados JSON do Curso - ${DateTime.now()}'
    ..text = 'Segue em anexo o JSON com os dados do curso.'
    ..attachments = [
      FileAttachment(file)..location = Location.attachment,
    ];

  try {
    final sendReport = await send(message, smtpServer);
    print('Email enviado com sucesso: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Erro ao enviar email: $e');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}
