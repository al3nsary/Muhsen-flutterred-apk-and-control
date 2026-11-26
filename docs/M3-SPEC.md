# مواصفات Material 3 المستخرجة — مرجع مُحسن كنترول

مستخرجةٌ من **حزمة جوجل نفسِها** `@material/web@2.3.0`، رموز `tokens/v0_192`،
لا من ذاكرةٍ ولا من قراءةِ صفحة. كلُّ رقمٍ هنا له ملفُّه وسطرُه.

الأمرُ المنفِّذ: `tar -xzf @material/web@2.3.0 package/tokens`
والمستخرِج: `scratchpad/m3extract.cjs` ← `m3-spec.json`.

---

## ١. سلّمُ الأنماط — خمسةَ عشرَ نمطًا

| النمط | حجم | سطر | النسبة | تتبّع | وزن |
|---|---|---|---|---|---|
| display-large | 57 | 64 | 1.123 | −0.25 | regular |
| display-medium | 45 | 52 | 1.156 | 0 | regular |
| display-small | 36 | 44 | 1.222 | 0 | regular |
| headline-large | 32 | 40 | 1.250 | 0 | regular |
| headline-medium | 28 | 36 | 1.286 | 0 | regular |
| headline-small | 24 | 32 | 1.333 | 0 | regular |
| title-large | 22 | 28 | 1.273 | 0 | regular |
| title-medium | 16 | 24 | 1.500 | 0.15 | medium |
| title-small | 14 | 20 | 1.429 | 0.1 | medium |
| body-large | 16 | 24 | 1.500 | 0.5 | regular |
| body-medium | 14 | 20 | 1.429 | 0.25 | regular |
| body-small | 12 | 16 | 1.333 | 0.4 | regular |
| label-large | 14 | 20 | 1.429 | 0.1 | medium |
| label-medium | 12 | 16 | 1.333 | 0.5 | medium |
| label-small | 11 | 16 | 1.455 | 0.5 | medium |

**أصغرُ حجمٍ في السلّمِ كلِّه 11** (label-small). وما دونه خارجُ المعيار.

### والعربيّة
M3 يصنّفها في نطاقِ الارتفاعِ **المتوسّط**: ارتفاعُ السطرِ يُضرب في
**1.07**، لا يُرفع إلى أرضيّةٍ ثابتة. وهذا تصحيحٌ لما طُبِّق سابقًا
(أرضيّةُ 1.3): المعيارُ نفسُه ينزل إلى 1.123 في display-large، فأرضيّةُ
1.3 تخالفه لا تطبّقه.

| النمط | سطرٌ لاتينيّ | سطرٌ عربيّ (×1.07) |
|---|---|---|
| display-large | 64 | 68.5 |
| headline-large | 40 | 42.8 |
| title-medium | 24 | 25.7 |
| body-medium | 20 | 21.4 |
| label-small | 16 | 17.1 |

---

## ٢. سلّمُ الأشكال

`none 0` · `extra-small 4` · `small 8` · `medium 12` · `large 16`
· `extra-large 28` · `full 9999`

ولكلِّ واحدٍ صيغةُ طرفٍ واحد (`-top` · `-start` · `-end`) تُستعمل حيث
يلتقي السطحان.

---

## ٣. الحركة

**المدد (مللي ثانية):**
`short1 50` `short2 100` `short3 150` `short4 200` ·
`medium1 250` `medium2 300` `medium3 350` `medium4 400` ·
`long1 450` `long2 500` `long3 550` `long4 600` ·
`extra-long1 700` `extra-long2 800` `extra-long3 900` `extra-long4 1000`

**المنحنيات:**
| الاسم | القيمة | متى |
|---|---|---|
| standard | `(0.2, 0, 0, 1)` | الانتقالُ العامّ |
| standard-decelerate | `(0, 0, 0, 1)` | الداخلُ إلى الشاشة |
| standard-accelerate | `(0.3, 0, 1, 1)` | الخارجُ منها |
| emphasized-decelerate | `(0.05, 0.7, 0.1, 1)` | الداخلُ المؤكَّد |
| emphasized-accelerate | `(0.3, 0, 0.8, 0.15)` | الخارجُ المؤكَّد |
| legacy | `(0.4, 0, 0.2, 1)` | المتوارَث |

---

## ٤. طبقاتُ الحالة

`hover 0.08` · `focus 0.12` · `pressed 0.12` · `dragged 0.16`
وتُرسَم من لونِ **on-** السطحِ الذي تحتَها، لا من لونٍ ثابت.

---

## ٥. أدوارُ اللون — ثمانيةٌ وأربعون

```
primary on-primary primary-container on-primary-container
primary-fixed on-primary-fixed primary-fixed-dim on-primary-fixed-variant
secondary on-secondary secondary-container on-secondary-container
secondary-fixed on-secondary-fixed secondary-fixed-dim
tertiary on-tertiary tertiary-container on-tertiary-container
tertiary-fixed on-tertiary-fixed tertiary-fixed-dim
error on-error error-container on-error-container
background on-background
surface on-surface surface-variant on-surface-variant
surface-dim surface-bright
surface-container-lowest surface-container-low surface-container
surface-container-high surface-container-highest
surface-tint inverse-surface inverse-on-surface inverse-primary
outline outline-variant shadow scrim
```

القاعدة: كلُّ لونِ نصٍّ هو `on-` السطحِ الذي تحتَه. ولا يُكتب لونٌ
بلا سطحِه.

---

## ٦. مقاساتُ المكوّنات

| المكوّن | الارتفاع | الأيقونة | الحدّ | ملاحظة |
|---|---|---|---|---|
| filled / outlined / text button | **40** | 18 | 1 | |
| icon-button (ممتلئ) | **40×40** | 24 | | |
| assist / filter chip | **32** | 18 | 1 | |
| صفُّ قائمةٍ سطرٌ واحد | **56** | 24 | | مسافةُ طرفٍ 16 |
| صفُّ قائمةٍ سطران | **72** | 24 | | |
| صفُّ قائمةٍ ثلاثة | **88** | 24 | | |
| تبويبٌ أساسيّ | **48** | 24 | | |
| شريطٌ علويٌّ صغير | **64** | 24 | | |
| شريطُ تنقّلٍ سفليّ | **80** | 24 | | |
| سكّةُ تنقّلٍ جانبيّة | عرض **80** | 24 | | |
| جدولُ بيانات: ترويسة | **56** | | 1 | |
| جدولُ بيانات: صفّ | **52** | | 1 | |
| جدولُ بيانات: ذيل | **52** | | | |
| شريطُ بحث | **56** | | | |
| FAB | **56×56** | 24 | | |
| مربّعُ اختيار | | 18 | 2 | نصفُ قطرٍ 2 |
| مفتاحُ تبديل | المقبض 24 | 16 | 2 | |
| منبثقةٌ بسطرين | **68** | 24 | | |

**هدفُ اللمس 48×48** لكلِّ ما يُنقَر — وهو مستقلٌّ عن مقاسِ المكوّن
المرسوم. الزرُّ يُرسَم 40 ويُلمَس 48.

---

## ٧. ما يلزم مُحسن كنترول

| في الكنترول | يقابله في M3 | الحدّ |
|---|---|---|
| `.btn` | button | ارتفاع 40، أيقونة 18 |
| `.btn.xs` | chip | ارتفاع 32 |
| `.iconbtn` | icon-button | 40×40، أيقونة 24 |
| `.nav` `.kid` | list item | 56 سطرًا، 72 سطرين |
| `.ops-time-item` `.ops-prep-item` `.control-hour-item` | list item | 56 |
| `.control-top-link` | tab | 48 |
| `.top` | top-app-bar | 64 |
| جداولُ الكنترول | data-table | ترويسة 56، صفّ 52 |
| `.langb` `.fold` | chip | 32 مرسومًا، 48 ملموسًا |
| البطاقات | card | شكل 12، حدّ 1 |
