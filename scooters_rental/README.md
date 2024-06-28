# Аренда самокатов
 
## Описание проекта
Вы аналитик популярного сервиса аренды самокатов GoFast. Вам передали данные о некоторых пользователях из нескольких городов, а также об их поездках. Проанализируйте данные и проверьте некоторые гипотезы, которые могут помочь бизнесу вырасти.

Сервисом можно пользоваться двумя способами:
- Без подписки: абонентская плата отсутствует, стоимость одной минуты поездки — 8 рублей, стоимость старта (начала поездки) — 50 рублей.
- С подпиской Ultra: абонентская плата — 199 рублей в месяц, стоимость одной минуты поездки — 6 рублей, стоимость старта — бесплатно.

## Данные
- Пользователи — users_go.csv
    * user_id - уникальный идентификатор пользователя
    * name -имя пользователя
    * age - возраст
    * city - город
    * subscription_type - тип подписки (free, ultra)

- Поездки — rides_go.csv
    * user_id - уникальный идентификатор пользователя
    * distance - расстояние, которое пользователь проехал в текущей сессии (в метрах)
    * duration - продолжительность сессии (в минутах) — время с того момента, как пользователь нажал кнопку «Начать поездку» до момента, как он нажал кнопку «Завершить поездку»
    * date - дата совершения поездки

- Подписки — subscriptions_go.csv
    * subscription_type - тип подписки
    * minute_price - стоимость одной минуты поездки по данной подписке
    * start_ride_price - стоимость начала поездки
    * subscription_fee - стоимость ежемесячного платежа

## Задача
Проанализировать данные о пользователях и поездках в сервисе аренды самокатов GoFast, чтобы выявить закономерности и проверить гипотезы, способствующие оптимизации бизнес-процессов и увеличению эффективности сервиса.

## Используемые библиотеки
* *pandas*
* *numpy*
* *scipy*
* *matplotlib*