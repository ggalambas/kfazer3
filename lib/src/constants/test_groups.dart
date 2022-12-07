import 'dart:math';

import 'package:kfazer3/src/constants/test_users.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/domain/group_plan.dart';
import 'package:kfazer3/src/features/groups/domain/member_role.dart';

/// Test groups to be used until a data source is implemented
List<Group> get kTestGroups => [..._kTestGroups];
final _kTestGroups = List.generate(
  6,
  (i) => Group(
    id: '$i',
    name: 'Group $i',
    description: 'A group made by him for the company.' * (i % 3),
    motivationalMessages: [...kMotivationalMessages],
    plan: GroupPlan.family,
    members: Map.fromIterable(
      // user 0 + random users
      kTestUsers.where((user) {
        if (user.id == '0') return true;
        return Random().nextBool();
      }).map((user) => user.id),
      value: (userId) {
        if (userId == '0') {
          if (i == 0) return MemberRole.owner;
          if (i == 1) return MemberRole.admin;
          if (i == 2) return MemberRole.member;
          if (i >= 3) return MemberRole.pending;
        }
        return [MemberRole.member, MemberRole.pending][Random().nextInt(2)];
      },
    ),
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

// const kMotivationalMessages = [
//   'força!',
//   'Bom esforço!',
//   'Está num bom caminho.',
//   'Bom foco.',
//   'Objetivo alcançado!',
//   'Contamos consigo.',
//   'O seu empenho é importante.',
//   'A nossa equipa depende de si!',
//   'Continue!',
//   'O seu trabalho conta!',
//   'O seu empenho faz a diferença.',
//   'Parabéns!',
//   'Bom trabalho!',
//   'Continuamos a contar consigo!',
//   'Sucesso.',
//   'O seu empenho e dedicação fazem esta equipa melhor!',
//   'A nossa equipa agradece.',
//   'Agradecemos o seu empenho!',
//   'Somos uma equipa melhor.',
//   'Todos contam, você também!',
//   'O seu trabalho faz a diferença.',
//   'Juntos conseguimos!',
//   'O seu trabalho é importante!'
// ];
