#!/bin/bash
#
# abrir_admin.sh — abre o ObjectBox Admin do device físico no navegador do Mac.
#
# Cria o túnel adb (Mac -> device) e abre http://127.0.0.1:PORTA.
# Uso:
#   ./abrir_admin.sh          # usa a porta padrão 8090
#   ./abrir_admin.sh 9090     # usa outra porta local (mapeia para 8090 no device)
#

set -e

# Porta do Admin no device (veja no log: "Listening on http://0.0.0.0:8090")
PORTA_DEVICE=8090
# Porta local no Mac (1o argumento, ou igual à do device)
PORTA_LOCAL="${1:-$PORTA_DEVICE}"

# Localiza o adb (não precisa estar no PATH)
ADB="$HOME/Library/Android/sdk/platform-tools/adb"
if [ ! -x "$ADB" ]; then
  ADB="$(command -v adb || true)"
fi
if [ -z "$ADB" ] || [ ! -x "$ADB" ]; then
  echo "❌ adb não encontrado. Verifique o Android SDK em ~/Library/Android/sdk/platform-tools"
  exit 1
fi

# Confere se há device conectado e autorizado
if ! "$ADB" get-state >/dev/null 2>&1; then
  echo "❌ Nenhum device conectado/autorizado."
  echo "   Rode '$ADB devices' e confirme que aparece como 'device' (não 'unauthorized')."
  exit 1
fi

# Cria o túnel
"$ADB" forward tcp:"$PORTA_LOCAL" tcp:"$PORTA_DEVICE"
echo "✅ Túnel criado: 127.0.0.1:$PORTA_LOCAL -> device:$PORTA_DEVICE"

# Abre no navegador
URL="http://127.0.0.1:$PORTA_LOCAL"
echo "🌐 Abrindo $URL"
open "$URL"
