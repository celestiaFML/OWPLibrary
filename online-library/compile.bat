@echo off
echo setuping roots...

set JAVA_HOME=C:\Program Files\Java\jdk-25
set TOMCAT_HOME=C:\tomcat
set PROJECT_DIR=C:\tomcat\webapps\online-library

set SRC_DIR=%PROJECT_DIR%\src
set CLASSES_DIR=%PROJECT_DIR%\WEB-INF\classes
set LIB_DIR=%PROJECT_DIR%\WEB-INF\lib

echo creating folders...
if not exist "%CLASSES_DIR%" mkdir "%CLASSES_DIR%"

echo forming classpath...
set CLASSPATH="%TOMCAT_HOME%\lib\servlet-api.jar"
for %%f in ("%LIB_DIR%\*.jar") do set CLASSPATH=!CLASSPATH!;"%%f"

echo compiling Java classes...
"%JAVA_HOME%\bin\javac" -cp %CLASSPATH% -d "%CLASSES_DIR%" -encoding UTF-8 "%SRC_DIR%\com\example\portal\*.java" "%SRC_DIR%\com\example\portal\**\*.java"

if %ERRORLEVEL% equ 0 (
    echo ✅ compiling done
    echo classes was made in: %CLASSES_DIR%
) else (
    echo ❌ error compiling
)

pause