# 🍎 Guia Completo: Deploy na Apple App Store

## 📋 Informações do Projeto
- **Nome do App**: Tecmuu
- **Bundle ID**: br.app.tecmuu
- **Versão Atual**: 1.0.18+85

---

## ✅ Pré-requisitos

### 1. Conta Apple Developer
- Conta ativa no [Apple Developer Program](https://developer.apple.com/programs/) ($99/ano)
- Acesso ao [App Store Connect](https://appstoreconnect.apple.com)

### 2. Ferramentas Necessárias
- macOS com Xcode instalado (versão mais recente)
- Flutter instalado e atualizado
- CocoaPods instalado (`sudo gem install cocoapods`)
- Fastlane instalado (opcional, mas recomendado)

### 3. Certificados e Provisioning Profiles
- Certificado de Distribuição (Distribution Certificate)
- Provisioning Profile de App Store
- Chave de API do App Store Connect (já configurada: `AuthKey_ZA9C2S6HF2.p8`)

---

## 🔢 Passo 1: Atualizar a Versão

### Editar o arquivo `pubspec.yaml`
```yaml
version: 1.0.19+86  # Formato: major.minor.patch+buildNumber
```

**Importante para iOS:**
- O `buildNumber` (86) deve ser **único** para cada upload no App Store Connect
- Não pode repetir números de build já enviados anteriormente

---

## 🧹 Passo 2: Limpar e Preparar o Projeto

### 2.1 Limpar builds anteriores
```bash
flutter clean
flutter pub get
```

### 2.2 Atualizar dependências iOS
```bash
cd ios
pod install --repo-update
cd ..
```

---

## 🔐 Passo 3: Configurar Assinatura no Xcode

### 3.1 Abrir projeto no Xcode
```bash
open ios/Runner.xcworkspace
```

### 3.2 Verificar configurações de assinatura
1. Selecione **Runner** no navegador do projeto
2. Vá em **Signing & Capabilities**
3. Certifique-se de que:
   - **Team**: Sua equipe de desenvolvimento está selecionada
   - **Bundle Identifier**: `br.app.tecmuu`
   - **Signing Certificate**: iPhone Distribution
   - **Provisioning Profile**: App Store (para distribuição)

### 3.3 Configurar para Release
1. No Xcode, vá em **Product > Scheme > Edit Scheme**
2. Selecione **Archive** no menu lateral
3. Confirme que **Build Configuration** está como **Release**

---

## 🏗️ Passo 4: Gerar o Build de Produção

### Opção A: Via Linha de Comando (Recomendado)
```bash
flutter build ipa --release
```

O arquivo IPA será gerado em:
```
build/ios/ipa/tecmuu.ipa
```

### Opção B: Via Xcode
1. No Xcode, vá em **Product > Archive**
2. Aguarde a compilação (pode levar alguns minutos)
3. O Organizer abrirá automaticamente com o archive

---

## 🚀 Passo 5: Upload para App Store Connect

### Opção A: Usando Fastlane (Configurado no projeto) ⭐ RECOMENDADO

O projeto já tem Fastlane configurado! Use um dos comandos:

#### Para TestFlight (Testes Internos)
```bash
cd /Users/tecmuu/Desktop/tecmuu
fastlane ios upload_testflight_internal
```

#### Para TestFlight (Testes Externos)
```bash
cd /Users/tecmuu/Desktop/tecmuu
fastlane ios upload_testflight_external
```

### Opção B: Via Xcode Organizer
1. No Organizer (Window > Organizer), selecione o archive
2. Clique em **Distribute App**
3. Selecione **App Store Connect**
4. Clique em **Upload**
5. Siga as instruções na tela

### Opção C: Via Transporter
1. Baixe o app [Transporter](https://apps.apple.com/app/transporter/id1450874784) da App Store
2. Arraste o arquivo `.ipa` para o Transporter
3. Clique em **Entregar**

---

## 📱 Passo 6: Configurar no App Store Connect

### 6.1 Acessar App Store Connect
1. Acesse: https://appstoreconnect.apple.com
2. Selecione seu app "Tecmuu"

### 6.2 TestFlight (Testes Beta)
1. Vá em **TestFlight**
2. O build aparecerá em "Processando" (pode levar 15-30 minutos)
3. Após processado:
   - **Testes Internos**: Adicione testadores internos
   - **Testes Externos**: Configure grupos e submeta para revisão

### 6.3 Preparar para Lançamento na App Store
1. Vá em **App Store > Preparar para Envio**
2. Preencha/atualize:
   - **Screenshots** para todos os tamanhos de tela
   - **Descrição** do app
   - **Palavras-chave** para busca
   - **Notas de versão** (O que há de novo)
   - **Informações de contato** de suporte
   - **URL de Privacidade**

### 6.4 Selecionar o Build
1. Na seção **Build**, clique no **+**
2. Selecione o build que você enviou
3. Salve as alterações

---

## 📝 Passo 7: Submeter para Revisão

### 7.1 Preencher informações de revisão
- **Informações de login** (se necessário para testar)
- **Notas para o revisor** (informações adicionais)
- **Informações de contato**

### 7.2 Enviar para revisão
1. Clique em **Adicionar para Revisão**
2. Confirme as declarações de conformidade
3. Clique em **Enviar para Revisão**

---

## ⏱️ Passo 8: Aguardar Aprovação

### Tempos típicos de revisão:
- **Primeira versão**: 24-48 horas (pode levar até 7 dias)
- **Atualizações**: 24-48 horas normalmente
- Você receberá notificações por email

### Status possíveis:
- 🟡 **Esperando Revisão**: Na fila
- 🔵 **Em Revisão**: Sendo analisado
- 🟢 **Pronto para Venda**: Aprovado!
- 🔴 **Rejeitado**: Precisa de correções

---

## 🔧 Solução de Problemas Comuns

### Erro: "No signing certificate found"
```bash
# Verificar certificados instalados
security find-identity -v -p codesigning
```
- Baixe o certificado de distribuição no Apple Developer Portal
- Instale no Keychain Access

### Erro: "Provisioning profile doesn't match"
1. Acesse [Apple Developer Portal](https://developer.apple.com/account/resources/profiles/list)
2. Crie/atualize o Provisioning Profile para App Store
3. Baixe e instale (duplo clique)
4. No Xcode: **Preferences > Accounts > Download Manual Profiles**

### Erro: "Build number already used"
- Aumente o número após o `+` no pubspec.yaml
- Exemplo: `1.0.18+85` → `1.0.18+86`

### Erro: "Missing compliance information"
- No App Store Connect, responda às perguntas sobre criptografia
- A maioria dos apps Flutter usa criptografia padrão (HTTPS) = responda "Sim" para uso de criptografia, mas isento de documentação

### Build travado em "Processing"
- Aguarde até 30 minutos
- Se persistir, tente enviar novamente
- Verifique emails para possíveis erros

### Erro: "Pod install failed"
```bash
cd ios
pod deintegrate
pod cache clean --all
pod install --repo-update
```

---

## 📊 Checklist Rápido iOS

Antes de cada deploy:
- [ ] Atualizar versão no `pubspec.yaml` (incrementar buildNumber)
- [ ] Executar `flutter clean && flutter pub get`
- [ ] Executar `cd ios && pod install --repo-update && cd ..`
- [ ] Testar o app no simulador e dispositivo físico
- [ ] Verificar certificados e provisioning profiles
- [ ] Executar `flutter build ipa --release`
- [ ] Upload via Fastlane ou Xcode
- [ ] Configurar informações no App Store Connect
- [ ] Submeter para revisão

---

## 🔄 Comandos Rápidos

```bash
# Limpar projeto
flutter clean && flutter pub get

# Atualizar pods
cd ios && pod install --repo-update && cd ..

# Build IPA
flutter build ipa --release

# Upload via Fastlane (interno)
fastlane ios upload_testflight_internal

# Upload via Fastlane (externo)
fastlane ios upload_testflight_external

# Abrir projeto no Xcode
open ios/Runner.xcworkspace

# Verificar certificados
security find-identity -v -p codesigning
```

---

## 📁 Arquivos Importantes do Projeto

| Arquivo | Descrição |
|---------|-----------|
| `pubspec.yaml` | Versão do app |
| `ios/Runner/Info.plist` | Configurações do app iOS |
| `ios/Runner.xcworkspace` | Projeto Xcode |
| `fastlane/Fastfile` | Automação de deploy |
| `AuthKey_ZA9C2S6HF2.p8` | Chave API App Store Connect |

---

## 🔐 Configuração Fastlane (Já Configurado)

O projeto já possui Fastlane configurado com:
- **Key ID**: ZA9C2S6HF2
- **Issuer ID**: a55da086-9dab-4ba4-a008-af34b00f7cb8
- **Key File**: AuthKey_ZA9C2S6HF2.p8

---

## 📱 Requisitos da App Store

### Mínimos obrigatórios:
- Screenshots para iPhone 6.5" e 5.5"
- Screenshots para iPad 12.9" (se suportar iPad)
- Ícone do app 1024x1024
- Descrição (até 4000 caracteres)
- URL de política de privacidade
- Categoria do app
- Classificação etária

### Recomendados:
- Vídeo de preview do app
- Texto promocional
- Palavras-chave otimizadas

---

## 📞 Suporte

- **Documentação Flutter**: https://flutter.dev/docs/deployment/ios
- **App Store Connect**: https://appstoreconnect.apple.com
- **Apple Developer**: https://developer.apple.com/support/
- **Fastlane Docs**: https://docs.fastlane.tools

---

**Última atualização**: Janeiro 2026
**Versão do guia**: 1.0
