# سيناريو المالك على الروابطِ الثلاثة، كما يفتحها من جوالِه وحاسوبِه.
# يُمرَّر المضيفُ بـ --variable base=http://127.0.0.1:PORT

# ١) صفحةُ التحميلِ تفتح وفيها البابان.
GET {{base}}/
HTTP 200
[Asserts]
header "Content-Type" contains "text/html"
body contains "تحميل التطبيق"
body contains "فتح الكنترول"
body contains "muhsen.apk"
body contains "control/"

# ٢) زرُّ التطبيقِ ينزّل ملفًّا حقيقيًّا لا صفحةَ خطأ.
GET {{base}}/muhsen.apk
HTTP 200
[Asserts]
header "Content-Type" == "application/vnd.android.package-archive"
bytes count > 10000000

# ٣) ونسخةُ ٣٢ بت كذلك.
GET {{base}}/muhsen-32bit.apk
HTTP 200
[Asserts]
bytes count > 10000000

# ٤) وبابُ الكنترولِ يفتح الكنترولَ الجديدَ لا صفحةَ انتظار.
GET {{base}}/control/
HTTP 200
[Asserts]
header "Content-Type" contains "text/html"
body contains "الكنترول"
body not contains "لم تُوضع هنا بعد"
bytes count > 1000000

# ٥) وما ليس في المجلّدِ لا يُخترع.
GET {{base}}/لا-يوجد.html
HTTP 404
