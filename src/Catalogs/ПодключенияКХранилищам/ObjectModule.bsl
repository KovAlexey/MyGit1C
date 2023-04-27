
Процедура ПередЗаписью(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПодключенияКХранилищам.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПодключенияКХранилищам КАК ПодключенияКХранилищам
	|ГДЕ
	|	ПодключенияКХранилищам.Ссылка <> &Ссылка
	|	И ПодключенияКХранилищам.Владелец = &Владелец
	|	И ПодключенияКХранилищам.СвязанныйПроект = &СвязанныйПроект";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("СвязанныйПроект", СвязанныйПроект);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Уже есть подключение для такого проекта");
	КонецЕсли;
	
КонецПроцедуры
