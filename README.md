# UA Forever

UA Forever is a Ukrainian localization addon for World of Warcraft: Forever
Beta, built for its modern Camelot interface. It translates quests, tooltips,
menus, character and profession panels, chat, NPC names, and other visible text.
Hold Shift to see the original tooltip; quest conversations have an EN/UA
switch. Target client: `wow_forever_beta` build `1.60.1.70205` (Interface
`16001`).

UA Forever — доповнення з українською локалізацією для World of Warcraft: Forever Beta, створене для сучасного інтерфейсу Camelot. Воно перекладає завдання, підказки, меню, панелі персонажа й професій, чат, імена NPC та інший видимий текст.
Утримуйте Shift, щоб побачити оригінал підказки. У діалогах завдань можна перемикатися між англійською та українською мовами. Цільовий клієнт: wow_forever_beta, збірка 1.60.1.70205 (інтерфейс 16001).

## Реліз 0.19.0

Git-тег: `0.19.0`. Зміни відносно 0.18.5-beta:

- Додано український переклад інтерфейсу ForeverVO: налаштувань, керування відтворенням, черги, імен персонажів і текстів завдань та діалогів.
- Покращено перемикання EN/UA для цілей і заголовків завдань; кнопку перемикання розміщено поруч із кнопкою відтворення ForeverVO.
- Оновлено українські переклади предметів, заклять, завдань, діалогів, книг, досягнень, локацій та інтерфейсу.
- Покращено сумісність бойових шрифтів із NiceDamage та іншими доповненнями, що змінюють шрифти.
- Додано переклад теми листа з доставкою предмета; переклад списку пошти більше не позначає листи прочитаними.
- Покращено переклад кнопок ігрового меню під час бою.

Для встановлення розпакуйте архів так, щоб папка `UA_Forever` опинилася в `Interface/AddOns`, після чого виконайте `/reload` або перезапустіть гру.

## ClassicUA translations

We use Ukrainian texts and terminology from ClassicUA for classic quests,
NPCs, items, spells, gossip, books, zones, and basic interface strings. We
adapted those texts for Forever and added new translations. UA Forever has its
own Camelot integration; it does not load ClassicUA's old UI hooks.

ClassicUA: [GitHub](https://github.com/greenya/ClassicUA) ·
[CurseForge](https://www.curseforge.com/wow/addons/classicua).

Classic translations can be outdated when Forever changes a spell or quest.
The bundled client catalog declares `1.60.1.70205` in its manifest;
`/uaf scan` reports a build mismatch when the running client differs.

## Commands

- `/uaf [status|on|off]` and `/uaf dev on|off`
- `/uaf ui`, `/uaf capture [seconds]`, `/uaf scan`, `/uaf report`
- `/uaf menus` (історичний лічильник меню), `/uaf autoscan on|off`
- `/uaf owner`, `/uaf tooltip [rows]`, `/uaf aura [seconds]`, `/uaf window [seconds]`

Scanned IDs, missing translations, menu captures, and diagnostics are saved in
`UA_ForeverDB` when the client reloads or exits. Run the translation audits in
`tools/` when changing dictionaries. Contributor instructions are in
[`CONTRIBUTING_TRANSLATIONS.md`](CONTRIBUTING_TRANSLATIONS.md).

У **Налаштування → Додатки → UA Forever** можна увімкнути автоскан
неперекладеного контенту. Він збирає нові предмети з текстом підказок, діалоги
й імена NPC, тексти та задачі квестів, навички, закляття, аури й вислови NPC
до `UA_ForeverDB.scan.auto`. Кнопка **Показати зібрані дані** відкриває експорт
частинами: натисніть **Виділити для Ctrl+C**, потім Ctrl+C і вставте текст на
сайті. Кнопка **Форма для надсилання** показує адресу
[форми збору даних](https://forms.gle/b2oGGebJGTxZsnfn8) для копіювання й
відкриття в браузері. Користувач сам надсилає дані. WoW записує `SavedVariables` на диск під
час `/reload` або виходу з гри.
Після надсилання всіх частин натисніть **Очистити дані** у вікні експорту та
підтвердьте дію. Це видаляє `UA_ForeverDB.scan.auto`, локальну runtime/hook
діагностику поточної сесії та очищує видимий export.
