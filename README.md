# MyGit1C
Конфа запиленная для себя для быстрого переноса изменений из базы в базу по коммитам. За красотой кода не следил. Выкладывается как есть, используется для себя, до релиза дойдет неизвестно когда.
Принцип работы:
1) Выбираются коммиты
2) Из базы, подключенной к EDT через дискретную выгрузку выгружаются файлы, связанные с этими коммитами
3) В базу, подключенную к хранилищу через дискретную загрузку загружаются файлы с этими коммитами

Возможности:
1) Выгрузка\Загрузка объектов по коммитам
2) Выгрузка\Загрузка объектов по дереву метаданных (пока сыро, но работает)
3) Захват метаданных в хранилище по коммитам\дереву метаданных
