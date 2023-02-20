
&НаКлиенте
Процедура ОбновитьКоммиты(Команда)
	ОбновитьКоммиты1НаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоммиты1НаСервере()
	Каталог = ГитХранилище.Каталог;

	КомандыЗапуска = Новый Массив;
	КомандыЗапуска.Добавить("cmd /C");
	КомандыЗапуска.Добавить("git log --pretty=""%H || %an || %ad ||  %s"" --date=format:%Y%m%d%H%M%S");

	ВремФайл = ПолучитьИмяВременногоФайла(".txt");

	Команда = СтрСоединить(КомандыЗапуска, " ");
	ИтоговаяКоманда = Новый Массив;
	ИтоговаяКоманда.Добавить(Команда);
	ИтоговаяКоманда.Добавить(ВремФайл);

	Команда = СтрСоединить(ИтоговаяКоманда, " > ");

	ЗапуститьПриложение(Команда, Каталог, Истина);

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ВремФайл, КодировкаТекста.UTF8);
	УдалитьФайлы(ВремФайл);

	КоммитМета = Метаданные.Справочники.Коммиты.Реквизиты;

	ТЗКоммиты = Новый ТаблицаЗначений;
	ТЗКоммиты.Колонки.Добавить("Идентификатор", КоммитМета.Идентификатор.Тип);
	ТЗКоммиты.Колонки.Добавить("Автор", КоммитМета.Автор.Тип);
	ТЗКоммиты.Колонки.Добавить("Дата", КоммитМета.Дата.Тип);
	ТЗКоммиты.Колонки.Добавить("Описание", КоммитМета.Описание.Тип);
	Для Сч = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		Строка = ТекстовыйДокумент.ПолучитьСтроку(Сч);

		РазделеннаяСтрока = СтрРазделить(Строка, "||", Ложь);

		НоваяСтрока = ТЗКоммиты.Добавить();
		Для СчКолонка = 0 По ТЗКоммиты.Колонки.Количество() - 1 Цикл
			Значение = СокрЛП(РазделеннаяСтрока[СчКолонка]);
			Если ТипЗнч(НоваяСтрока[СчКолонка]) = Тип("Дата") Тогда
				Значение = Дата(Значение);
			КонецЕсли;

			НоваяСтрока[СчКолонка] = Значение;
		КонецЦикла;
	КонецЦикла;

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТЗ.Идентификатор КАК Идентификатор,
	|	ТЗ.Автор КАК Автор,
	|	ТЗ.Дата КАК Дата,
	|	ТЗ.Описание КАК Описание
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.Идентификатор КАК Идентификатор,
	|	ВТ.Автор КАК Автор,
	|	ВТ.Дата КАК Дата,
	|	ВТ.Описание КАК Описание,
	|	Коммиты.Ссылка КАК Ссылка
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Коммиты КАК Коммиты
	|		ПО ВТ.Идентификатор = Коммиты.Идентификатор
	|ГДЕ
	|	(Коммиты.Ссылка ЕСТЬ NULL
	|			ИЛИ &Все)";  
	Запрос.УстановитьПараметр("Все", Все);
	Запрос.УстановитьПараметр("ТЗ", ТЗКоммиты);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			СправочникОбъект = Справочники.Коммиты.СоздатьЭлемент();
		КонецЕсли;
		
		СправочникОбъект.Наименование = Выборка.Описание;
		СправочникОбъект.Владелец = ГитХранилище;
		СправочникОбъект.Автор = Выборка.Автор;
		СправочникОбъект.Дата = Выборка.Дата;
		СправочникОбъект.Описание = Выборка.Описание;
		СправочникОбъект.Идентификатор = Выборка.Идентификатор;
		
		СправочникОбъект.ИзмененныеФайлы.Очистить();
		
		ФайлыВКоммите = РаботаСГитомКлиентСервер.ПолучитьСписокИзменений(СправочникОбъект.Владелец, СправочникОбъект.Идентификатор);
		СоответствиеПапкаМетаданные = РаботаСГитомКлиентСервер.ПолучитьСоответствияМетаданныхПапкам();
		
		Для Каждого СтрокаФайла Из ФайлыВКоммите Цикл
			НоваяСтрока = СправочникОбъект.ИзмененныеФайлы.Добавить();
			НоваяСтрока.ИмяФайла = СтрокаФайла.ИмяФайла;
			
			ОписаниеМета = РаботаСГитомКлиентСервер.РазобратьСтрокуНаМетаданные(СтрокаФайла.ИмяФайла, СоответствиеПапкаМетаданные);
			НоваяСтрока.ИмяМетаданных = ОписаниеМета.ПолныйПутьКМетаданному;
		КонецЦикла;

		
		СправочникОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

