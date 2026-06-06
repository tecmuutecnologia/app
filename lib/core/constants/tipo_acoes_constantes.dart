/// Descrições fixas dos tipos de ação do exame ginecológico.
///
/// Antes ficavam em `FFAppState.tipoAcoes` (lista de `TipoAcoesStruct`), que
/// nunca era escrita — era uma constante de fato, usada apenas como opções de
/// dropdown via `.map((e) => e.descricao)`. Movida para cá como `List<String>`
/// const, eliminando o campo do god object `FFAppState`.
const kTipoAcoesDescricoes = <String>[
  'Aborto',
  'Anestro',
  'Ausência de Muco',
  'CG I',
  'CG II',
  'CG III',
  'CG IV',
  'Cio',
  'Cisto Folicular',
  'Cisto Luteinico',
  'Cl cavitário',
  'Cloe',
  'Endometrite',
  'Feto mumificado',
  'Fl-',
  'Hemorragia de Metaestro',
  'IATF',
  'IATF com Implante',
  'Indução de Lactação',
  'Inseminação',
  'Liberada',
  'Lóquio',
  'Metrite',
  'Muco Turvo',
  'Mucometra',
  'Outros',
  'Ovsynch',
  'Piometra',
  'Reabsorção Embrionária',
  'Retenção de Placenta',
  'Secagem',
  'Prostaglandina',
];
