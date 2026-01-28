# 📱 Guia Completo: Deploy na Google Play Store

## 📋 Informações do Projeto
- **Nome do App**: tecmuu
- **Package ID**: br.app.tecmuu
- **Versão Atual**: 1.0.18+85

---

## ✅ Pré-requisitos

### 1. Verificar Configurações de Assinatura
Confirme que o arquivo `key.properties` existe na raiz do projeto Android com as credenciais da keystore:
```
storePassword=<sua-senha>
keyPassword=<sua-senha>
keyAlias=<seu-alias>
storeFile=<caminho-para-o-arquivo.keystore>
```

### 2. Ferramentas Necessárias
- Flutter instalado e atualizado
- Android SDK instalado
- Conta Google Play Console configurada
- Keystore de produção (para assinar o app)

---

## 🔢 Passo 1: Atualizar a Versão

### Editar o arquivo `pubspec.yaml`
Localize a linha `version:` e atualize:
```yaml
version: 1.0.19+86  # Formato: major.minor.patch+buildNumber
```

**Regras de versionamento:**
- `1.0.19` - Versão visível para usuários (versionName)
- `+86` - Número do build (versionCode) - DEVE ser sempre maior que o anterior
- **Importante**: O buildNumber (`86`) NUNCA pode ser menor que versões anteriores na Play Store

---

## 🧹 Passo 2: Limpar Build Anterior

Execute no terminal:
```bash
flutter clean
flutter pub get
```

---

## 🔍 Passo 3: Verificar Configurações Android

### Verificar `android/app/build.gradle`
Confirme que as configurações de release estão corretas:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
    }
}
```

---

## 🏗️ Passo 4: Gerar o Build de Produção

### Opção A: APK (para testes ou distribuição direta)
```bash
flutter build apk --release
```

### Opção B: App Bundle (RECOMENDADO para Play Store)
```bash
flutter build appbundle --release
```

**Por que App Bundle?**
- Tamanho menor para usuários (Google otimiza por dispositivo)
- Suporte automático a múltiplas arquiteturas (ARM, x86)
- Requerido pela Google Play para apps novos

---

## 📦 Passo 5: Localizar os Arquivos Gerados

Após o build, os arquivos estarão em:

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

---

## 🚀 Passo 6: Upload para a Play Store

### 6.1 Acessar o Google Play Console
1. Acesse: https://play.google.com/console
2. Selecione seu aplicativo "tecmuu"

### 6.2 Criar uma Nova Versão
1. No menu lateral, vá em **Produção** ou **Teste**
2. Clique em **Criar nova versão**
3. Faça upload do arquivo `app-release.aab`

### 6.3 Preencher Informações da Versão
- **Nome da versão**: 1.0.19 (mesmo do pubspec.yaml)
- **Notas de versão**: Descreva as mudanças/melhorias
  ```
  - Correções de bugs
  - Melhorias de performance
  - Novas funcionalidades [descrever]
  ```

### 6.4 Revisar e Publicar
1. Revise todas as informações
2. Clique em **Revisar versão**
3. Clique em **Iniciar lançamento para produção**

---

## ⏱️ Passo 7: Aguardar Aprovação

- **Primeira versão**: 2-7 dias para revisão
- **Atualizações**: 1-3 dias normalmente
- Você receberá emails sobre o status

---

## 🔧 Solução de Problemas Comuns

### Erro: "Version code has already been used"
- Aumente o número após o `+` no pubspec.yaml
- Exemplo: `1.0.18+85` → `1.0.18+86`

### Erro: "App not signed correctly"
- Verifique o arquivo `key.properties`
- Confirme que a keystore existe no caminho especificado
- Verifique se as senhas estão corretas

### Erro: "Minimum SDK version"
- Verifique `android/app/build.gradle`
- A Play Store requer no mínimo API 21 (Android 5.0)

### Build muito grande
- Use `--split-per-abi` para APKs:
  ```bash
  flutter build apk --release --split-per-abi
  ```
- Considere usar App Bundle (já otimizado)

---

## 📊 Passo 8: Monitorar após Publicação

### No Google Play Console:
1. **Estatísticas**: Visualize downloads e uso
2. **Classificações**: Monitore avaliações dos usuários
3. **Relatórios de erros**: Verifique crashes (via Firebase Crashlytics)
4. **Feedback**: Responda comentários dos usuários

---

## 🔄 Checklist Rápido

Antes de cada deploy:
- [ ] Atualizar versão no `pubspec.yaml`
- [ ] Executar `flutter clean && flutter pub get`
- [ ] Testar o app localmente
- [ ] Executar `flutter build appbundle --release`
- [ ] Verificar que o arquivo .aab foi gerado
- [ ] Preparar notas de versão
- [ ] Fazer upload no Play Console
- [ ] Revisar e publicar

---

## 📝 Comandos Úteis

```bash
# Ver versão atual do Flutter
flutter --version

# Analisar o código
flutter analyze

# Executar testes
flutter test

# Build para debug
flutter build apk --debug

# Build para release com logs
flutter build appbundle --release --verbose

# Verificar tamanho do app
flutter build appbundle --release --analyze-size
```

---

## 🔐 Segurança

**NUNCA faça commit dos seguintes arquivos:**
- `key.properties`
- `*.keystore`
- `*.jks`
- `google-services.json` (se contém dados sensíveis)
- Senhas ou credenciais

Mantenha backups seguros da sua keystore - se perder, não poderá mais atualizar o app!

---

## 📞 Suporte

- **Documentação Flutter**: https://flutter.dev/docs/deployment/android
- **Google Play Console**: https://support.google.com/googleplay/android-developer
- **Firebase**: https://firebase.google.com/docs

---

**Última atualização**: Janeiro 2026
**Versão do guia**: 1.0
