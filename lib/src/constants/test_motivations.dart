import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/motivation/domain/motivation.dart';

/// Test groups to be used until a data source is implemented
Map<GroupId, Motivation> get kTestMotivations => {
      for (final group in kTestGroups) group.id: kMotivation,
    };

const kMotivation = [
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

// const kMotivation = [
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
