/// Regras de domínio (puras) para classificar um animal por **status** e
/// **grupo**, hoje espalhadas como strings mágicas (`status == 'Prenha'`,
/// `grupoAnimal == 'Vacas'`) repetidas dezenas de vezes nas telas-lista gigantes
/// (`listacompleta`, `animais_prenhas`, `secas`, ...).
///
/// Centralizar aqui:
/// - elimina as strings mágicas (uma fonte só para 'Prenha'/'Vacas'/...);
/// - torna os predicados **testáveis** sem widget/ObjectBox/Firestore;
/// - dá nome às regras (`ehVacaPrenha`) em vez de expressões booleanas soltas.
///
/// São funções puras: NÃO dependem de Flutter nem de I/O. As telas passam a
/// chamar estes predicados em vez de comparar strings inline.
library;

// ---------------------------------------------------------------------------
// Status do animal (valores canônicos como gravados no Firestore/struct)
// ---------------------------------------------------------------------------
const String kStatusPrenha = 'Prenha';
const String kStatusVazia = 'Vazia';
const String kStatusInseminada = 'Inseminada';
const String kStatusInseminadaPP = 'Inseminada PP';
const String kStatusSeca = 'Seca';
const String kStatusAborto = 'Aborto';
const String kStatusDescarte = 'Descarte';

/// ⚠️ INCONSISTÊNCIA DE DADOS no código legado: o "pré-parto" aparece com DUAS
/// grafias diferentes — `'Pré-parto'` (hífen) em prenhas/secas e `'Pré Parto'`
/// (espaço) em listacompleta. Como são strings distintas, um filtro escrito com
/// uma NÃO casa registros gravados com a outra. Mantidas as duas aqui para
/// expor o problema; o time deve unificar a grafia (gravação + filtros) e então
/// remover a duplicata.
const String kStatusPrePartoHifen = 'Pré-parto';
const String kStatusPrePartoEspaco = 'Pré Parto';

// ---------------------------------------------------------------------------
// Grupos do animal
// ---------------------------------------------------------------------------
const String kGrupoVacas = 'Vacas';
const String kGrupoNovilhas = 'Novilhas';
const String kGrupoBezerros = 'Bezerros';
const String kGrupoBezerras = 'Bezerras';

// ---------------------------------------------------------------------------
// Predicados de status
// ---------------------------------------------------------------------------
bool ehPrenha(String? status) => status == kStatusPrenha;
bool ehVazia(String? status) => status == kStatusVazia;
bool ehInseminada(String? status) => status == kStatusInseminada;
bool ehInseminadaPP(String? status) => status == kStatusInseminadaPP;
bool ehSeca(String? status) => status == kStatusSeca;
bool ehAborto(String? status) => status == kStatusAborto;
bool ehDescarte(String? status) => status == kStatusDescarte;

/// Robusto às duas grafias legadas (ver [kStatusPrePartoHifen] /
/// [kStatusPrePartoEspaco]): casa "Pré-parto" E "Pré Parto".
bool ehPreParto(String? status) =>
    status == kStatusPrePartoHifen || status == kStatusPrePartoEspaco;

// ---------------------------------------------------------------------------
// Predicados de grupo
// ---------------------------------------------------------------------------
bool ehVaca(String? grupo) => grupo == kGrupoVacas;
bool ehNovilha(String? grupo) => grupo == kGrupoNovilhas;

/// `true` se o animal é Vaca **ou** Novilha (as duas categorias reprodutivas que
/// as telas de prenhas/secas/DG costumam considerar juntas).
bool ehVacaOuNovilha(String? grupo) => ehVaca(grupo) || ehNovilha(grupo);

// ---------------------------------------------------------------------------
// Predicados compostos (regras das telas-lista)
// ---------------------------------------------------------------------------

/// Vaca prenha — filtro da lista de **prenhas** (`animais_prenhas`):
/// `grupoAnimal == 'Vacas' && status == 'Prenha'`.
bool ehVacaPrenha(String? grupo, String? status) =>
    ehVaca(grupo) && ehPrenha(status);

/// Vaca seca — filtro da lista de **secas** (`secas`):
/// `grupoAnimal == 'Vacas' && status == 'Seca'`.
bool ehVacaSeca(String? grupo, String? status) =>
    ehVaca(grupo) && ehSeca(status);

/// Elegível para inseminação — filtro da lista de **inseminações**
/// (`lista_inseminacoes`): é Vaca ou Novilha **e** está Vazia, Inseminada ou
/// Inseminada PP.
bool ehElegivelInseminacao(String? grupo, String? status) =>
    ehVacaOuNovilha(grupo) &&
    (ehVazia(status) || ehInseminada(status) || ehInseminadaPP(status));
