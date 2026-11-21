#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════
#   سيناريو المالك كاملاً — محليًّا، بلا شبكةٍ ولا إنتاج
#
#   هذا المستودعُ تسليمٌ لا تطوير: صفحةٌ ساكنةٌ وملفّا تطبيقٍ
#   ونسخةُ كنترول. فسيناريو المالكِ هو ما يفعله الناسُ بها:
#
#     ١) يفتح الصفحةَ فتفتح، وفيها البابان.
#     ٢) يضغط «تحميل التطبيق» فينزّل APK حقيقيًّا لا صفحةَ خطأ.
#     ٣) يضغط «فتح الكنترول» فيفتح الكنترولُ الجديد.
#     ٤) ولا يُرفع شيءٌ فوق ٢٥ ميجابايت: رفعُ المتصفّحِ يرفضه،
#        وهو سببُ تقسيمِ التطبيقِ نسختين.
#     ٥) ولا مفتاحَ ولا رمزَ في ملفٍّ ذاهبٍ إلى مستودعٍ عام.
#
#   يُشغَّل على خادمٍ محلّيٍّ على منفذٍ عشوائيٍّ، ويُقتل بعد
#   الفحص. ولا يكتب في المستودعِ ولا يحذف ملفًّا.
# ════════════════════════════════════════════════════════════
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"
HURL="${HURL_BIN:-/c/Users/KSA/tools/hurl-8.1.0/hurl.exe}"

PORT=""
PID=""
LOG="$(mktemp -t smoke-rel-XXXXXX.txt)"
cleanup() {
  [ -n "$PID" ] && kill "$PID" 2>/dev/null || true
  rm -f "$LOG" 2>/dev/null || true
}
trap cleanup EXIT

fail() {
  echo "" >&2
  echo "✗ $1" >&2
  exit 1
}

echo "▸ المستودع: $ROOT"

# ── ١/٥  الملفّاتُ موجودةٌ وغيرُ فارغة ─────────────────────────
echo "▸ ١/٥  الملفّاتُ الأربعة"
need=(
  "docs/index.html"
  "docs/muhsen.apk"
  "docs/muhsen-32bit.apk"
  "docs/control/index.html"
)
for f in "${need[@]}"; do
  [ -s "$f" ] || fail "ملفٌّ ناقصٌ أو فارغ: $f"
done
echo "  ✓ أربعةُ ملفّاتٍ حاضرة"

# ── ٢/٥  التطبيقُ ملفُّ APK حقيقيٌّ ودون حدِّ الرفع ───────────
echo "▸ ٢/٥  الـAPK: صحيحٌ ودون ٢٥ ميجابايت"
LIMIT=$((25 * 1024 * 1024))
for f in docs/muhsen.apk docs/muhsen-32bit.apk; do
  magic="$(head -c 2 "$f")"
  [ "$magic" = "PK" ] || fail "ليس ملفَّ APK: $f"
  size="$(wc -c < "$f" | tr -d ' ')"
  [ "$size" -lt "$LIMIT" ] || fail "فوق حدِّ رفعِ المتصفّح (٢٥م.ب): $f = $size"
  # وAndroidManifest داخلَه — حتّى لا يكون أرشيفًا فارغًا باسم apk.
  #
  # والقائمةُ تُؤخذ في متغيّرٍ لا في أنبوب: `unzip` يردُّ غيرَ صفرٍ
  # على تحذيرٍ عابر، و`pipefail` يُسقط الأنبوبَ كلَّه فيُتَّهم ملفٌّ
  # سليم.
  if command -v unzip >/dev/null 2>&1; then
    list="$(unzip -l "$f" 2>/dev/null || true)"
    case "$list" in
      *AndroidManifest.xml*) ;;
      *) fail "أرشيفٌ بلا AndroidManifest: $f" ;;
    esac
  fi
done
echo "  ✓ نسختانِ سليمتانِ ودون الحدّ"

# ── ٣/٥  الكنترولُ وثيقةٌ كاملةٌ وليس صفحةَ انتظار ────────────
echo "▸ ٣/٥  الكنترولُ الجديد"
head -c 200 docs/control/index.html | grep -qi "<!doctype html" \
  || fail "الكنترولُ ليس وثيقةً كاملة"
grep -q "</html>" docs/control/index.html || fail "الكنترولُ مبتور"
grep -q "لم تُوضع هنا بعد" docs/control/index.html \
  && fail "ما زالت صفحةُ الانتظارِ مكانَ الكنترول"
csize="$(wc -c < docs/control/index.html | tr -d ' ')"
[ "$csize" -gt 1000000 ] || fail "الكنترولُ أصغرُ ممّا يُعقل: $csize"
echo "  ✓ وثيقةٌ كاملةٌ ($((csize / 1024)) ك.ب)"

# ── ٤/٥  لا سرَّ في مستودعٍ عامّ ──────────────────────────────
echo "▸ ٤/٥  لا مفتاحَ ولا رمز"
if grep -rlEI "ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|AIza[0-9A-Za-z_-]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY" \
     --exclude-dir=.git --exclude="*.apk" . > "$LOG" 2>/dev/null; then
  if [ -s "$LOG" ]; then
    echo "" >&2
    cat "$LOG" >&2
    fail "سرٌّ في ملفٍّ ذاهبٍ إلى العلن"
  fi
fi
echo "  ✓ نظيف"

# ── ٥/٥  السيناريو على خادمٍ محلّيّ ───────────────────────────
echo "▸ ٥/٥  الروابطُ الثلاثةُ على خادمٍ محلّيّ"
command -v node >/dev/null 2>&1 || fail "node غيرُ موجود"
node .smoke/serve.cjs > "$LOG" 2>&1 &
PID=$!
for _ in $(seq 1 50); do
  PORT="$(head -1 "$LOG" 2>/dev/null | tr -d '\r')"
  case "$PORT" in
    ''|*[!0-9]*) PORT=""; sleep 0.2 ;;
    *) break ;;
  esac
done
[ -n "$PORT" ] || fail "لم يُقلع الخادمُ المحلّيّ"

BASE="http://127.0.0.1:$PORT"
if [ -f "$HURL" ]; then
  "$HURL" --test --variable "base=$BASE" .smoke/links.hurl \
    || fail "سقط سيناريو الروابط (hurl)"
else
  # بديلٌ بـcurl إن لم يكن hurl على الجهاز — الفحصُ نفسُه.
  code() { curl -s -o /dev/null -w "%{http_code}" "$1"; }
  [ "$(code "$BASE/")" = "200" ] || fail "صفحةُ التحميلِ لا تفتح"
  [ "$(code "$BASE/muhsen.apk")" = "200" ] || fail "رابطُ التطبيقِ مكسور"
  [ "$(code "$BASE/control/")" = "200" ] || fail "رابطُ الكنترولِ مكسور"
  curl -s "$BASE/" | grep -q "تحميل التطبيق" || fail "زرُّ التحميلِ غائب"
fi
echo "  ✓ الصفحةُ والتطبيقُ والكنترولُ تفتح جميعًا"

echo ""
echo "✓ السيناريو مرّ كاملاً — بلا مساسٍ بالإنتاج ولا حذف."
