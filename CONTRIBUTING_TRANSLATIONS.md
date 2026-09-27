# Додавання перекладів до UA Forever

Звичайний переклад додається до `entries/`, а не до `scripts/`. Файли в
`scripts/` керують Blizzard lifecycle, безпечним читанням UI та показом уже
готового перекладу.

## Куди додавати переклад

| Domain | Канонічний каталог |
|---|---|
| Item | `entries/forever/catalogs/items/catalog.lua` |
| Spell/aura | `entries/forever/catalogs/spells/catalog.lua` або відповідний класовий файл у `spells/` |
| Talent | `entries/forever/catalogs/talents/` |
| Quest і tasks | відповідний файл у `entries/forever/catalogs/quests/` |
| NPC | `entries/forever/catalogs/npcs/catalog.lua` |
| Object | `entries/forever/catalogs/objects/catalog.lua` |
| Zone | `entries/zone.lua`; Forever client additions у `entries/forever/catalogs/zones/` |
| UI exact key | `entries/forever/catalogs/ui/core.lua`, `settings.lua` або `skills.lua` |
| NPC speech | `entries/forever/catalogs/chat/npc.lua` |
| Gossip | `entries/forever/catalogs/gossip/catalog.lua` |
| Blizzard/system chat wording | `entries/forever/catalogs/chat/system.lua` |
| Tooltip/surface formatter | `entries/forever/catalogs/ui/tooltips.lua` або `surfaces.lua` |
| Власний UI UA Forever | `entries/forever/catalogs/addon/locale_uk.lua` |

Окремих `*_manual.lua` та override-каталогів більше немає. Після перевірки
додавайте або виправляйте запис безпосередньо в канонічному доменному файлі.
Великі каталоги є постійними даними репозиторію: їх не перегенеровують і не
замінюють під час звичайного оновлення перекладу.

## ID, exact key, context чи pattern

- Використовуйте ID для item, spell, quest, NPC та object, якщо клієнт дає
  стабільний ID. Зберігайте актуальний English source у полі `en`, де схема
  його підтримує.
- Використовуйте exact English key для сталої видимої UI-фрази. Не
  нормалізуйте два різні English keys в один запис вручну.
- Використовуйте explicit context, коли одна англійська назва має різні
  значення за domain або slot. Adapter повинен передати `category` і `slot`;
  frame-name domain/glossary heuristic у resolver відсутній.
- Використовуйте pattern лише коли Blizzard text справді містить динамічні
  captures: число, ім'я, link або таймер. Exact key завжди має перевагу.
- Якщо новий текст потребує читання іншого API, нового native writer або
  окремого semantic slot, потрібен surface adapter, а не ширший regex.

## UI tier і пріоритет

UI compiler застосовує порядок:

```text
manual_override > curated > reviewed_import > validated_legacy > generated_fallback
```

Для звичайного перевіреного UI-перекладу додайте exact English key до
`catalogs/ui/core.lua` або до контекстного `settings.lua` / `skills.lua`.
Client-каталоги в `catalogs/ui/client_*.lua` зберігають сумісність і provenance;
не дублюйте в них новий curated-запис. Якщо одна фраза потребує різного
перекладу за контекстом, оформіть це в контекстному каталозі або resolver,
задокументувавши причину.

## Placeholders і WoW markup

Не змінюйте структуру або порядок без окремого runtime test:

- `%s`, `%d`, positional format tokens і Lua captures;
- `|H...|h...|h` links та їх target;
- `|cAARRGGBB` / `|r` colors;
- `|A...|a` atlas tags і `|T...|t` textures;
- `|n`, `\n`, HTML fragments та escape sequences;
- grammar placeholders на кшталт `{ім'я:к}`.

Перекладати можна лише видимий label усередині link. ID, bonus data, color і
link target мають залишитися незмінними.

## Перевірка conflict і provenance

Запустіть з кореня репозиторію:

```powershell
python tools/audit_translation_conflicts.py
python tools/audit_pattern_overlaps.py
python tools/audit_domain_overrides.py
python -m unittest discover -s tools -p 'test_*.py'
git diff --check
```

Audit не повинен мати `new/changed` conflicts. Lower-tier collision може бути
явним `TIER_OVERRIDE`; різні значення на однаковому top tier/priority є
`SAME_TIER_PRIORITY_CONFLICT` і потребують ручного рішення. Runtime provenance
доступний через `addonTable.forever_catalog.ui_provenance[key]` або
`translation_resolver.ui_provenance(key)`; запис містить `source` і `tier`.

Не оновлюйте baseline, доки не класифіковано кожну нову різницю. Invalid ID чи
English mismatch має потрапити до `[INVALID_CANDIDATES]`, а не тихо зникнути.

## Autoscan неперекладеного тексту

1. Увімкніть **Налаштування → Додатки → UA Forever → Автоскан** або виконайте
   `/uaf autoscan on`.
2. Відкрийте конкретну поверхню й відтворіть native writer після `/reload`.
3. Виконайте `/uaf scan`, потім `/uaf report`.
4. Відкрийте **Показати зібрані дані**, скопіюйте всі частини експорту й лише
   після цього очищуйте scan data.

Збережіть експорт у текстовий файл і побудуйте перевірені worklist-файли:

```powershell
python -m pip install -r automation/requirements.txt
python automation/catalog_scan.py build/log.txt
```

Рядки, які свідомо треба залишити без перекладу, додавайте до
`automation/ignored_sources.json` із точними `section`, `source` і поясненням
у `reason`. Після сканування вони потрапляють до `results/ignored.json`, а не
до `needs_translation.json`.

Експорт автоскану містить лише невирішені записи. Якщо текст зі звіту вже має
переклад у поточному репозиторії, автоматизація відносить його до
`not_applied.json`, а не до `existing.json`. Поля `surface`, `owner` і `slot`
показують екран та елемент, на якому виникла проблема; UI-звіти в
`results/ui/` додатково мають статус `needs_translation`, `not_applied` або
`review`.

Конвеєр завантажує фактичні каталоги в порядку `entries/index.xml` та
`entries/forever/index.xml`, тому відокремлює вже наявні переклади від справді
нових. Результати знаходяться в `automation/results/`:

- `needs_translation.json` і `translate/*.json` — рядки, які треба перекласти;
- `not_applied.json` — переклад є, але runtime його не втримав;
- `review.json` — динамічні або неоднозначні записи;
- `ignored.json` — технічний шум;
- `ui/menus.json`, `ui/widgets.json`, `ui/other.json` — поділ нових UI-знахідок.

Заповнюйте лише поле `translation`. Для машинної чернетки за явно запитаним
workflow встановіть `GOOGLE_TRANSLATE_API_KEY` і запустіть:

```powershell
python automation/catalog_translate_google.py
```

Скрипт заповнює лише порожні поля у `needs_translation.json`, не змінює
каталоги й не замінює вже перевірені переклади. Усі машинні результати треба
переглянути. Потім згенеруйте Lua-фрагменти для перевірки без зміни каталогів:

```powershell
python automation/catalog_apply.py automation/results/needs_translation.json
```

Після review внесіть ті самі записи безпосередньо в канонічні каталоги:

```powershell
python automation/catalog_apply.py automation/results/needs_translation.json --apply
```

Скрипт не створює `*_manual.lua`, не перегенеровує великі каталоги й не
перезаписує наявні переклади без явного `--update-existing`. Нові записи
вставляються всередину наявних Lua-таблиць канонічного каталогу, а не окремими
присвоєннями наприкінці файла.

У report перевіряйте не тільки missing text, а й hook lifecycle, catalog
conflicts, technical literals та invalid candidates. Секція `[RUNTIME]` показує
`lookupTier`/`catalogSource`, semantic owner/slot, `applied`, `retained` і фінальний
`outcome`; для успішного сценарію після deferred verification очікуються
`applied = true`, `retained = true` та `RETAINED_AFTER_APPLY`. Не записуйте
secret value або довільний player chat як translation source.

## Мінімальний review checklist

- English source точно відповідає поточному build `1.60.1.70009`.
- Обрано правильний domain/context/slot і правильний tier.
- Placeholders та markup збережені.
- Каталоги не перегенеровували й не замінювали; змінено лише потрібні записи.
- Audits, повний test suite і `git diff --check` зелені.
- Для нового/зміненого adapter hook виконано відповідний сценарій у грі та
  підтверджено `available / installed / observed / applied / retained`.
