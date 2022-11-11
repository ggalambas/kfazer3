import 'dart:math';

import 'package:collection/collection.dart';
import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';

/// Test groups to be used until a data source is implemented
List<Group> get kTestGroups => [..._kTestGroups];
final _kTestGroups = List.generate(
  2,
  (i) => Group(
    id: '$i',
    title: 'Group $i',
    description:
        'A group made by him for the company x in the center of the world.',
    motivationalMessages: [...kMotivationalMessages],
    plan: GroupPlan.family,
    memberIds: kTestUsers
        .whereIndexed((j, user) {
          if (i < 2 && j == 0) return true;
          return Random().nextBool();
        })
        .map((user) => user.id)
        .toList(),
  ),
);

const kMotivationalMessages = [
  'Tarefa concluída, força!',
  'Trabalho concluído, bom esforço!',
  'Está num bom caminho, tarefa concluída.',
  'Bom esforço, tarefa concluída.',
  'Bom foco, trabalho finalizado.',
  'Objetivo alcançado, bom esforço!',
  'Contamos consigo, tarefa concluída.',
  'O seu empenho é importante, trabalho concluído.',
  'A nossa equipa depende de si, continue!',
  'O seu trabalho conta, contamos consigo!',
  'O seu empenho faz a diferença, tarefa concluída.',
  'Parabéns, tarefa concluída!',
  'Parabéns, concluiu o seu trabalho.',
  'Concluiu o seu trabalho, parabéns!',
  'Bom trabalho!',
  'Continuamos a contar consigo!',
  'Sucesso, concluiu a sua tarefa.',
  'O seu empenho e dedicação fazem esta equipa melhor!',
  'Tarefa concluída, contamos consigo!',
  'A nossa equipa agradece, bom trabalho.',
  'Agradecemos o seu empenho! Somos uma equipa melhor.',
  'Todos contam, você também, tarefa concluída!',
  'Tarefa concluída, parabéns.',
  'Tarefa concluída com sucesso! Bom trabalho.',
  'Tarefa concluída com sucesso! Obrigado.',
  'Tarefa concluída! O seu trabalho conta.',
  'Tarefa concluída! O seu trabalho faz a diferença.',
  'Juntos conseguimos! Tarefa concluída.',
  'O seu trabalho é importante! Tarefa concluída.'
];
