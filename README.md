# TradeApp
### Куренков Даниил 4-21 ИСП-6

TradeApp – это демонстрационное приложение для управления торговой базой данных, созданное на основе MS SQL, C# WPF и Entity Framework. Проект включает в себя модуль импорта данных из Excel-файлов и пользовательский интерфейс с авторизацией, динамической капчей и списком товаров с функциями поиска и фильтрации.

## Описание
Основные возможности проекта:

База данных Trade: Создана на основе SQL-скрипта, содержащего таблицы:
Role – роли пользователей.
User – данные пользователей.
Order – заказы.
Product – товары (с изображениями).
OrderProduct – связь заказов и товаров.
Pickups – информация о пунктах выдачи (если требуется).
Импорт данных из Excel: Данные импортируются из файлов (например, user_import.xlsx, products_import.xlsx, order_import.xlsx, pickups_import.xlsx) с использованием технологии OPENROWSET.
Пользовательский интерфейс (WPF):
Окно авторизации (LoginWindow) с проверкой логина/пароля и динамической капчей при неудачных попытках.
Главное окно (MainWindow) с отображением списка товаров, реализованным с поддержкой поиска, фильтрации по производителю и сортировки.
Отображение фотографий товаров осуществляется через класс-конвертер ImageConverter, который берет пути из базы и преобразует их в объекты BitmapImage для корректного отображения.
Entity Framework: Используется для работы с базой данных, позволяя осуществлять CRUD-операции.

MS SQL Server (локальный сервер EDELWEISS\SQLEXPRESS).
Visual Studio с поддержкой разработки WPF-приложений.
NuGet-пакеты:
Microsoft.EntityFrameworkCore.SqlServer.
Microsoft ACE OLEDB драйвер.
Данные Excel-файлы и SQL-скрипты находятся в папке ресурсов:
Excel-файлы: user_import.xlsx, products_import.xlsx, order_import.xlsx, pickups_import.xlsx
Изображения товаров: resources\Images
Логотипы: resources\Images\icons

## Структура проекта

TradeApp (WPF приложение)
App.config – файл конфигурации приложения (строка подключения).
TradeContext.cs – класс контекста Entity Framework для доступа к базе.
Models: Классы моделей (User, Role, Product и т.д.).
Views:
LoginWindow.xaml и LoginWindow.xaml.cs – окно авторизации.
MainWindow.xaml и MainWindow.xaml.cs – главное окно со списком товаров.
Converters:
ImageConverter.cs – класс для преобразования путей к изображениям в BitmapImage.
SQL Скрипты:
Скрипты для создания базы данных, таблиц и импорта данных из Excel.
resources:
Images: Фотографии товаров.
Images\icons: Логотипы и иконки.
Excel файлы: Файлы импорта данных (user_import.xlsx, products_import.xlsx, order_import.xlsx, pickups_import.xlsx).
