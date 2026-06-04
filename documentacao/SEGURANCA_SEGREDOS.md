# Higiene de segredos — ação requerida do time

> **Status:** ⚠️ Pendente de decisão/execução do time.
> Levantado na **Fase 0** do plano de refatoração (rede de segurança). Este
> documento **apenas registra o risco e o procedimento** — a execução (rotação
> de chaves + reescrita de histórico) exige coordenação e **não foi feita
> automaticamente**, pois é destrutiva e afeta todos os clones do repositório.

## O problema

Arquivos com segredos estão **commitados no histórico do Git** e, portanto,
expostos a qualquer pessoa com acesso ao repositório (e permanecem no histórico
mesmo que sejam apagados num commit futuro).

### Segredos atualmente VERSIONADOS (risco ativo)

| Arquivo | Natureza | Gravidade |
|---|---|---|
| `AuthKey_ZA9C2S6HF2.p8` | Chave privada de API da Apple (App Store Connect / push) | 🔴 Alta |
| `credentials.txt` | Credenciais em texto | 🔴 Alta |
| `apple_deploy_keys.txt` | Chaves/segredos de deploy Apple | 🔴 Alta |

### Já protegidos (apenas conferir)

`key.properties` e `*.jks` (keystore Android) já estão no `.gitignore` e **não**
aparecem como versionados. Confirmar que nunca foram commitados no passado:

```bash
git log --all --oneline -- key.properties '*.jks'
```

## Procedimento recomendado (executar com o time)

### 1. Rotacionar TODAS as chaves expostas (fazer ANTES de qualquer outra coisa)

Remover do Git **não** basta — o segredo já pode ter sido copiado. Portanto:

- **Apple `.p8` (App Store Connect):** revogar a chave no portal Apple Developer
  e gerar uma nova.
- **`credentials.txt` / `apple_deploy_keys.txt`:** rotacionar cada credencial
  contida neles nos respectivos provedores.

### 2. Parar de versionar (remover do índice, manter localmente)

```bash
git rm --cached AuthKey_ZA9C2S6HF2.p8 credentials.txt apple_deploy_keys.txt
```

### 3. Adicionar ao `.gitignore`

Acrescentar:

```gitignore
# Segredos / chaves de deploy (NUNCA versionar)
*.p8
credentials.txt
apple_deploy_keys.txt
```

### 4. Purgar do histórico do Git

Como os arquivos já estão em commits antigos, é preciso reescrever o histórico
com [`git filter-repo`](https://github.com/newren/git-filter-repo) (recomendado)
ou o BFG Repo-Cleaner. **Coordenar com todo o time** — exige novo clone após o
force-push.

```bash
git filter-repo --invert-paths \
  --path AuthKey_ZA9C2S6HF2.p8 \
  --path credentials.txt \
  --path apple_deploy_keys.txt
git push origin --force --all
git push origin --force --tags
```

### 5. Gestão de segredos daqui pra frente

- Guardar segredos de CI/CD em **GitHub Actions Secrets** (ou no cofre do
  provedor de CI), injetados em runtime — nunca em arquivo no repo.
- Em desenvolvimento, manter os arquivos **localmente**, fora do versionamento.

## Checklist

- [ ] Chave Apple `.p8` revogada e regenerada
- [ ] Credenciais de `credentials.txt` rotacionadas
- [ ] Credenciais de `apple_deploy_keys.txt` rotacionadas
- [ ] `git rm --cached` aplicado aos 3 arquivos
- [ ] `.gitignore` atualizado
- [ ] Histórico purgado (`git filter-repo`) e force-push feito
- [ ] Time re-clonou o repositório
- [ ] Segredos migrados para o cofre de CI/CD
