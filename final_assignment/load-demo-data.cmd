@echo off
chcp 65001 >nul
echo Importing demo data into note_app ...
mysql -u root -pcjw2295cjw --default-character-set=utf8mb4 note_app < "%~dp0src\main\resources\demo_data.sql"
if %ERRORLEVEL% neq 0 (
  echo Failed. Check MySQL is running and password in db.properties matches.
  exit /b 1
)
echo.
echo Done. Login: demo / demo123
echo Open Knowledge Graph after login: /graph
