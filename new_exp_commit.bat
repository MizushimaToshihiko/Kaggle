@echo off
setlocal EnableDelayedExpansion

rem ===== 固定設定: Kaggleリポジトリのローカルパス =====
set REPO_ROOT=C:\Users\toshi\Documents\Kaggle

rem ===== 固定設定: コンペティションごとのルートディレクトリ※コンペごとに変える =====
set CMP_ROOT=ps-s6e4-Predicting-Irrigation-Need

rem ===== 固定設定: 実験フォルダのベースパス =====
set EXP_BASE=%REPO_ROOT%\%CMP_ROOT%\experiments

rem ===== 引数チェック =====
set SUFFIX=%~1
if "%SUFFIX%"=="" (
  echo Usage:
  echo   new_exp.bat short_name
  echo Example:
  echo   new_exp.bat nelder-mead_core12
  exit /b 1
)

rem ===== リポジトリ存在確認 =====
if not exist "%REPO_ROOT%" (
  echo Error:
  echo   REPO_ROOT が見つかりません。
  echo   %REPO_ROOT%
  exit /b 1
)

if not exist "%EXP_BASE%" (
  echo Error:
  echo   experiments ディレクトリが見つかりません。
  echo   %EXP_BASE%
  exit /b 1
)

cd /d "%REPO_ROOT%"

rem ===== 今日の日付を YYYYMMDD で取得 =====
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"') do set TODAY=%%I

rem ===== 当日分の最大連番を探す =====
set MAXNUM=0

for /d %%D in ("%EXP_BASE%\exp_%TODAY%_*") do (
    set NAME=%%~nxD
    rem NAME 例: exp_20260331_003_nelder-mead_core12
    rem 先頭16文字 "exp_YYYYMMDD_" の次の3文字を連番として切り出す
    set NUMSTR=!NAME:~13,3!
    rem 数値として評価
    set /a NUMVAL=1!NUMSTR! - 1000 2>nul
    if !NUMVAL! GTR !MAXNUM! set MAXNUM=!NUMVAL!
)

set /a NEXTNUM=MAXNUM+1

if %NEXTNUM% LSS 10 (
    set PADNUM=00%NEXTNUM%
) else if %NEXTNUM% LSS 100 (
    set PADNUM=0%NEXTNUM%
) else (
    set PADNUM=%NEXTNUM%
)

set EXP_ID=exp_%TODAY%_%PADNUM%_%SUFFIX%
set EXP_DIR=%EXP_BASE%\%EXP_ID%

rem ===== template存在確認 =====
if not exist "%CMP_ROOT%\templates\experiment\config.yaml" (
  echo Error:
  echo   template の config.yaml が見つかりません。
  exit /b 1
)

if not exist "%CMP_ROOT%\templates\experiment\result.md" (
  echo Error:
  echo   template の result.md が見つかりません。
  exit /b 1
)

if not exist "%CMP_ROOT%\templates\experiment\review.md" (
  echo Error:
  echo   template の review.md が見つかりません。
  exit /b 1
)

rem ===== 実験フォルダ作成 =====
mkdir "%EXP_DIR%" 2>nul

rem ===== templateから3ファイルをコピー =====
copy /Y "%CMP_ROOT%\templates\experiment\config.yaml" "%EXP_DIR%\config.yaml" >nul
copy /Y "%CMP_ROOT%\templates\experiment\result.md" "%EXP_DIR%\result.md" >nul
copy /Y "%CMP_ROOT%\templates\experiment\review.md" "%EXP_DIR%\review.md" >nul

echo.
echo Created:
echo   %REPO_ROOT%\%EXP_DIR%
echo.
dir "%EXP_DIR%"

echo.
echo EXP_ID=%EXP_ID%

endlocal