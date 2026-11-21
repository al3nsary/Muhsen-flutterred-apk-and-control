# سيناريو المالك على الصفحةِ المنشورة، كما يفتحها من جوالِه وحاسوبِه.
# يُمرَّر المضيفُ بـ --variable base=http://127.0.0.1:PORT

# ١) صفحةُ التحميلِ تفتح وفيها البابان.
GET {{base}}/
HTTP 200
[Asserts]
header "Content-Type" contains "text/html"
body contains "تحميل التطبيق"
body contains "فتح الكنترول"

# ٢) زرُّ التطبيقِ يشير إلى أصلِ الإصدارِ لا إلى ملفٍّ في المستودع:
#    رفعُ الـAPK في المستودعِ يختنق، والإصدارُ مسارُه للملفّاتِ الكبيرة.
GET {{base}}/
HTTP 200
[Asserts]
body contains "releases/latest/download/muhsen.apk"
body contains "releases/latest/download/muhsen-32bit.apk"

# ٣) وبابُ الكنترولِ يفتح الكنترولَ الجديدَ لا صفحةَ انتظار.
GET {{base}}/control/
HTTP 200
[Asserts]
header "Content-Type" contains "text/html"
body contains "الكنترول"
body not contains "لم تُوضع هنا بعد"
bytes count > 1000000

# ٤) وما ليس في المجلّدِ لا يُخترع.
GET {{base}}/لا-يوجد.html
HTTP 404
