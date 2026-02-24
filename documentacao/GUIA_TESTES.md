# 🧪 Guia de Testes - Ações Favoritas

## 📱 Como Testar a Funcionalidade

### Pré-requisitos
- Aplicativo compilado e rodando
- Acesso a dados de propriedade e animais
- Tela de Exame Ginecológico acessível

---

## 🧪 Testes Básicos

### Teste 1: Abrir Dropdown de Ações
**Objetivo**: Verificar se o dropdown aparece corretamente

**Passos:**
1. Navegue para uma propriedade
2. Acesse Exame Ginecológico
3. Selecione um animal (status "Vazia")
4. Clique no botão **"Ação"**

**Resultado Esperado:**
- ✅ Lista de ações aparece
- ✅ Cada ação tem uma estrela ao lado (☆)
- ✅ Nenhuma estrela está preenchida no início

---

### Teste 2: Marcar como Favorita
**Objetivo**: Verificar se consegue marcar ação como favorita

**Passos:**
1. Com dropdown aberto, localize a ação **"Anestro"**
2. Clique na estrela **vazia (☆)** ao lado
3. Observe a mudança visual

**Resultado Esperado:**
- ✅ Estrela muda de vazia para **preenchida (★)**
- ✅ Cor muda para **âmbar/dourada**
- ✅ Lista é atualizada automaticamente
- ✅ "Anestro" agora aparece **no topo** da lista

---

### Teste 3: Remover Favorita
**Objetivo**: Verificar se consegue desmarcar ação favorita

**Passos:**
1. Com dropdown aberto, localize uma ação com estrela preenchida **"Anestro ★"**
2. Clique na estrela **preenchida (★)** novamente

**Resultado Esperado:**
- ✅ Estrela muda de preenchida para **vazia (☆)**
- ✅ Cor volta para **cinza**
- ✅ Lista é atualizada automaticamente
- ✅ "Anestro" é movida para sua posição alfabética

---

### Teste 4: Ordenação de Favoritas
**Objetivo**: Verificar se favoritas aparecem primeiro

**Passos:**
1. Abra o dropdown
2. Marque como favoritas: "Cio", "Inseminação", "Metrite"
3. Observe a ordem da lista

**Resultado Esperado:**
- ✅ Ordem da lista: 
  ```
  Cio ★
  Inseminação ★
  Metrite ★
  ---
  Aborto
  Anestro
  Ausência de Muco
  ```
- ✅ Favoritas em ordem alfabética primeiro
- ✅ Não-favoritas em ordem alfabética depois

---

### Teste 5: Persistência - Parte 1 (Salvar)
**Objetivo**: Verificar se favoritas são salvas

**Passos:**
1. Abra dropdown
2. Marque 3 ações como favoritas: "Aborto", "Cio", "Inseminação"
3. **Feche o dropdown** (selecione uma ação ou clique fora)
4. **Feche o aplicativo**
5. **Espere 5 segundos** (para ter certeza que fechou)
6. **Reabra o aplicativo**

**Resultado Esperado:**
- ✅ Aplicativo inicia normalmente
- ✅ Sem erros de compilação
- ✅ Dados carregam corretamente

---

### Teste 6: Persistência - Parte 2 (Verificar)
**Objetivo**: Verificar se favoritas foram mantidas

**Passos:**
1. Navegue novamente para o Exame Ginecológico
2. Clique no botão **"Ação"** novamente
3. Verifique o estado das ações

**Resultado Esperado:**
- ✅ As 3 ações continuam com estrela preenchida **★**
- ✅ Aparecem no topo da lista
- ✅ Nenhuma favorita foi perdida

---

## 🔄 Testes de Interação

### Teste 7: Múltiplos Cliques Rápidos
**Objetivo**: Verificar se a interface é responsiva

**Passos:**
1. Abra dropdown
2. Clique rapidamente (5-10 vezes) em estrelas de diferentes ações
3. Observe se a UI fica responsiva

**Resultado Esperado:**
- ✅ Nenhum lag ou travamento
- ✅ Todas as ações marcam/desesmarcam corretamente
- ✅ Lista re-ordena suavemente

---

### Teste 8: Seleção de Ação
**Objetivo**: Verificar se consegue selecionar ação favorita

**Passos:**
1. Abra dropdown
2. Marque "Cio" como favorita
3. Clique em "Cio" (não na estrela, no texto)
4. Verifique se a ação foi selecionada

**Resultado Esperado:**
- ✅ "Cio" é selecionada
- ✅ Dropdown fecha
- ✅ Ação é registrada normalmente
- ✅ Favorita continua marcada para próxima vez

---

## 📱 Testes em Diferentes Cenários

### Teste 9: Sem Conexão (Modo Offline)
**Objetivo**: Verificar se funciona offline

**Passos:**
1. Ative modo offline
2. Abra Exame Ginecológico
3. Clique em "Ação"
4. Marque/desmarque favoritas

**Resultado Esperado:**
- ✅ Funciona normalmente
- ✅ Sem erros ou travamentos
- ✅ Favoritas são salvas mesmo offline

---

### Teste 10: Com Muitas Ações
**Objetivo**: Verificar performance com muitas favoritas

**Passos:**
1. Abra dropdown
2. Marque **15-20 ações** como favoritas
3. Observe performance
4. Reabra dropdown

**Resultado Esperado:**
- ✅ Sem lag notável
- ✅ Lista ordena corretamente
- ✅ Interface responsiva
- ✅ Performance aceitável

---

## 🎨 Testes de UI/UX

### Teste 11: Cores e Ícones
**Objetivo**: Verificar visual da interface

**Passos:**
1. Abra dropdown
2. Verifique cores e ícones

**Resultado Esperado:**
- ✅ Estrela **vazia (☆)** em cinza para não-favoritas
- ✅ Estrela **preenchida (★)** em âmbar/dourado para favoritas
- ✅ Contraste adequado para leitura
- ✅ Sem distorções visuais

---

### Teste 12: Tamanho e Espaçamento
**Objetivo**: Verificar se layout está correto

**Passos:**
1. Abra dropdown
2. Verifique tamanho dos elementos

**Resultado Esperado:**
- ✅ Texto legível
- ✅ Estrelas clickáveis (tamanho adequado)
- ✅ Espaçamento entre itens
- ✅ Layout responsivo em diferentes tamanhos

---

## 🌐 Testes em Diferentes Dispositivos

### Teste 13: Celular (Android)
**Objetivo**: Testar em dispositivo mobile

**Passos:**
1. Rode em Android
2. Siga testes básicos 1-6

**Resultado Esperado:**
- ✅ Todos os testes passam
- ✅ Toque responsivo na estrela
- ✅ Sem problemas de layout

---

### Teste 14: Tablet
**Objetivo**: Testar em dispositivo maior

**Passos:**
1. Rode em tablet
2. Verifique se interface se adapta
3. Siga testes básicos 1-6

**Resultado Esperado:**
- ✅ Interface se expande corretamente
- ✅ Elementos bem espaçados
- ✅ Funcionalidade idêntica

---

## 📊 Testes de Regressão

### Teste 15: Funcionalidades Existentes Não Foram Quebradas
**Objetivo**: Verificar se nada parou de funcionar

**Passos:**
1. Selecione uma ação favorita
2. Preencha outros campos (data, observações)
3. Clique "Salvar"
4. Verifique se a ação foi registrada normalmente

**Resultado Esperado:**
- ✅ Ação é registrada corretamente
- ✅ Data e observações são salvas
- ✅ Sem comportamento inesperado

---

### Teste 16: Navegação Não Foi Afetada
**Objetivo**: Verificar fluxo de navegação

**Passos:**
1. Abra Exame Ginecológico
2. Clique "Ação"
3. Clique em uma ação
4. Preencha formulário
5. Clique "Cancelar"
6. Verifique se voltou para a tela anterior

**Resultado Esperado:**
- ✅ Navegação funciona corretamente
- ✅ Sem travamentos
- ✅ Botões respondem

---

## ✅ Checklist Final de Testes

Marque conforme completa cada teste:

```
Testes Básicos:
□ Teste 1: Abrir Dropdown
□ Teste 2: Marcar como Favorita
□ Teste 3: Remover Favorita
□ Teste 4: Ordenação de Favoritas
□ Teste 5: Persistência - Salvar
□ Teste 6: Persistência - Verificar

Testes de Interação:
□ Teste 7: Múltiplos Cliques
□ Teste 8: Seleção de Ação

Testes de Cenários:
□ Teste 9: Modo Offline
□ Teste 10: Muitas Favoritas

Testes de UI/UX:
□ Teste 11: Cores e Ícones
□ Teste 12: Tamanho e Espaçamento

Testes em Dispositivos:
□ Teste 13: Android
□ Teste 14: Tablet

Testes de Regressão:
□ Teste 15: Funcionalidades Existentes
□ Teste 16: Navegação
```

---

## 🐛 Se Encontrar um Bug

1. **Anote os detalhes:**
   - O que você estava fazendo
   - Que erro ocorreu
   - Em qual dispositivo
   - Em qual versão do app

2. **Verifique se é reproduzível:**
   - Tente novamente
   - Tente em outro dispositivo

3. **Reporte com:**
   - Passos para reproduzir
   - Resultado esperado vs resultado real
   - Screenshot/vídeo se possível

---

## 📞 Suporte

Se encontrar problemas não contemplados neste guia:
1. Consulte [TECNICA_ACOES_FAVORITAS.md](TECNICA_ACOES_FAVORITAS.md)
2. Verifique [GUIA_ACOES_FAVORITAS.md](GUIA_ACOES_FAVORITAS.md)
3. Entre em contato com a equipe

---

**Tempo estimado de testes**: 30-45 minutos
**Sucesso esperado**: 100%
