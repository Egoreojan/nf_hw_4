## Задание 1

Предположим, вы разработчик базы данных команды развития проекта и вам поручено создать
надёжный механизм работы с данными в схеме Booking.
По техническому заданию, запросы к базе будут приходить из внешних сервисов, например вебсайта
или АРМ оператора в виде неких REST-запросов.
Вам выпала роль создать функции, реализующие вставку, изменение, удаление и запрос записей из
всех таблиц схемы Booking.
Эти функции будут необходимы далее, чтобы ваши коллеги смогли бы реализовать обращение к ним
с помощью REST-запроса.
По договорённости с коллегами, функции должны:
1. Иметь название по шаблону fn_<название операции>_<название таблицы>
2. Работать только с одной записью за один раз - возвращать одну запись, удалять одну запись,
изменять одну запись или вставлять одну запись.
3. При изменении записи необходим следующий алгоритм работы: удалить старую запись,
вставить новую запись (учесть, что первичный ключ должен сохраниться)
4. Все операции запроса записи и удаления должны идентифицировать нужную запись по
первичному ключу. (Первичные ключи отмечены знаком # в диаграмме
https://postgrespro.ru/docs/postgrespro/14/demodb-schema-diagram)
5. Функции, возвращающие записи, должны возвращать тип - курсор
6. Функции, удаляющие, изменяющие или вставляющие записи должны вернуть -1, если
произошла ошибка, причём, в консоль необходимо вывести текст ошибки, 0, если при
удалении или изменении записи по ключу не было найдено ни одной записи или 1, если
операция произведена успешно.
Таблицы, для которых следует написать функции:
Booking, Tickets, Flights, Ticket_flight, Boarding_passes

[Функции таблицы Bookings](./results/task1/bookings_functions.sql)

[Функции таблицы Tickets](./results/task1/tickets_functions.sql)

[Функции таблицы Flights](./results/task1/flights_functions.sql)

[Функции таблицы Ticket_flight](./results/task1/ticket_flight_functions.sql)

[Функции таблицы Boarding_passes](./results/task1/boarding_passes_functions.sql)

## Задание 2
Посовещавшись с более опытными коллегами вы поняли, что, скорее всего, заказчик захочет
расширить существующий функционал. Проанализировав предыдущие проекты, вы предполагайте,
что первым делом заказчик захочет получать больше информации из таблицы «Flights». Поэтому вы
решили добавить к списку работ создание нескольких перегруженных функций вида
fn_select_flight()..., которые должны:
1. Если передаётся один параметр flight_id, просто вызвать функцию, созданную на предыдущем
этапе.
2. Если передаётся параметр shcedual_departure, должна быть вызвана функция, которая вернёт
курсор со всеми записями, удовлетворяющими этому условию (равенство).
3. Если передаётся параметр shcedual_departure и знак отнощения («>», «<»), то должна быть
вызвана функция, которая вернёт курсор, удавлетворяющий неравенству («shcedual_departure > a_shcedual_departure» или «shcedual_departure < a_shcedual_departure» соответственно).

[Перегруженная функция FN_SELECT_FLIGHT](./results/task2/fn_select_flight.sql)
[Вспомогательные функции FN_SELECT_FLIGHT](./results/task2/fn_helper.sql)