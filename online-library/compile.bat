@echo off
echo Установка путей...

set JAVA_HOME=C:\Program Files\Java\jdk-11.0.xx
set TOMCAT_HOME=C:\tomcat9
set PROJECT_DIR=C:\tomcat9\webapps\online-library

set SRC_DIR=%PROJECT_DIR%\src
set CLASSES_DIR=%PROJECT_DIR%\WEB-INF\classes
set LIB_DIR=%PROJECT_DIR%\WEB-INF\lib

echo Создаем папку для классов...
if not exist "%CLASSES_DIR%" mkdir "%CLASSES_DIR%"

echo Формируем classpath...
set CLASSPATH="%TOMCAT_HOME%\lib\servlet-api.jar"
for %%f in ("%LIB_DIR%\*.jar") do set CLASSPATH=!CLASSPATH!;"%%f"

echo Компилируем Java классы...
"%JAVA_HOME%\bin\javac" -cp %CLASSPATH% -d "%CLASSES_DIR%" -encoding UTF-8 "%SRC_DIR%\com\example\portal\*.java" "%SRC_DIR%\com\example\portal\**\*.java"

if %ERRORLEVEL% equ 0 (
    echo ✅ Компиляция успешно завершена!
    echo Классы созданы в: %CLASSES_DIR%
) else (
    echo ❌ Ошибка компиляции!
)

pause