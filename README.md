# worldskills
## Структура контракта:
### Контракты:
#### 1. Permissions - основной функционал - обозначение владельца контракта, администратора и модификаторов для управленческих функций.
    - Поля
        1. Владелец - инициализируется тем, кто загрузил контракт(owner)
        2. Администратор - назначается владельцем(administrator)
    -Функции и модификаторы:
        1. Модификатор - "только владелец". Все функции с этим модификатором исполняются только владельцем контракта.(onlyOwner)
        2. Модификатор - "только администратор". Все функции с этим модификатором могут испольняться администратором и владельцем.(onlyAdmin)
        3. Функция смены владельца - меняет адрес владельца. Исполняется только владельцем. (changeOwner)
        4. Функция добавления админа - меняет адрес админитратора. Исполняется только владельцем (addAdmin)
*Для всех арифметических операций используется библиотека SafeMath. Для защиты от переполнения стэка*
#### 2. Zharcoin - контракт нашего токена. Содержит все основные функции по ERC20.
    
    - Поля
        1. Имя, символ, кол-во знаков после запятой. Основные для ERC20 компоненты.
        2. Две bool переменные - canTransfer. Определяет возможность перевода средств между счетами.
        3. Переменная totalSupply, которая является общим количеством выпущенных токенов. 
        4. Словари:
            - Балансы счетов: ключ - адрес аккаунта, значение ключа - количество токенов на адресе.
            - Словарь т.н. разрешений. Для обозначения того, сколько одному адресу можно снять токенов с другого адреса.
     - Пользовательские функции
        1. Узнать баланс. Принимает на вход адрес, выводит баланс токенов на этом адресе. (balanceOf)
        2. Совершить перевод. Принимает на вход адрес получателя и сумму. Адрес отправителя инциализирует со значением отправителя транзакии. (transfer)
        3. Разрешить снять сумму. Принимает на вход аргументы: адрес, которому разрешено снимать, количество, которое разрешено снимать. (aprove)
        4. Узнать разрешенное количество. Принимает на вход два адреса: владельца суммы и того, кому разрешено снять. (allowance)
        5. Перевести со счета. Аргументы: адрес куда перевести, откуда перевести, сколько перевести. Если есть разрешенное количество для снятие, тот, кому разрешили, может обращаться с ними как угодно.
      - Административные функции:
        1. Начать/остановить передачу токенов. Меняет значение глобальной переменной canTransfer. (startTransfer, stopTransfer)
        2. Чеканить. Выпускаем больше токенов в обращение. Прибавляет значение к totalSupply, отправляет выпущенные токены, на какой-либо счет выбранный администратором.
        3. Сжечь. Убирает какое-то количество токенов со счета, не добавляя их в totalSupply.;
        

ГУЙ:
1)Хоум пейдж с инфой о проекте
2)Страница с инфой о продажах
3)Страница с инфой о балансе кошелька
4)Страница заказов
5)Страница рекомендованных прайсов на жратву








