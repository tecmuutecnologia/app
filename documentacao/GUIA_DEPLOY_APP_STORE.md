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
