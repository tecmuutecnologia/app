## 🔄 Comandos Rápidos

```bash
# Limpar projeto
flutter clean && flutter pub get

# Atualizar pods
#--repo-update só é necessário quando você muda uma dependência no pubspec.yaml.
#cd ios && pod install --repo-update && cd ..
cd ios && pod install && cd ..

# Build IPA
flutter build ipa --release

# Upload via Fastlane (interno) — de dentro de ios/
#fastlane ios upload_testflight_internal

# Upload via Fastlane (externo) — de dentro de ios/
fastlane ios upload_testflight_external groups:"Testadores Externos"

# Abrir projeto no Xcode
#open ios/Runner.xcworkspace

# Verificar certificados
#security find-identity -v -p codesigning
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

## ⚠️ Upload falha com "A required agreement is missing or has expired"

```
| 2    | app_store_connect_api_key | 0  |   ← a chave autenticou
| 💥   | pilot                     | 1  |   ← a Apple recusou

[!] A required agreement is missing or has expired.
```

**Não é o build, a chave nem o certificado.** Há um contrato pendente de
aceite na conta Apple, e o App Store Connect bloqueia todo upload — pela API
e pelo site — enquanto ele não for assinado. Acontece sempre que a Apple
atualiza os termos do Developer Program License Agreement: funcionava ontem,
eles mudam o texto, e para de funcionar hoje. Vale para app gratuito também.

Como reconhecer: a etapa `app_store_connect_api_key` passa e o `pilot`
morre em 1 segundo. Se a chave estivesse errada, teria falhado na etapa 2.

**Só o Account Holder resolve** — Admin e Developer não conseguem aceitar.

1. Entrar em `appstoreconnect.apple.com` com a conta do titular
2. Aceitar o contrato pendente no banner da home ou em **Negócios**
   (*Business*, antes "Contratos, Impostos e Banco")
3. App pago ou com compra no app pode exigir também os dados fiscais e
   bancários completos
4. Conferir em `developer.apple.com/account` se a associação ao Developer
   Program não expirou — a renovação vencida dá a MESMA mensagem

Propaga em alguns minutos. Depois é só repetir o comando de upload: o
`.ipa` continua válido, não precisa refazer o build.

---
