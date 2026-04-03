@echo off
setlocal EnableDelayedExpansion

REM ===== Fixed paths =====
set "REPO_ROOT=C:\Users\toshi\Documents\Kaggle"
set "CMP_ROOT=ps-s6e4-Predicting-Irrigation-Need"
set "EXP_BASE=%REPO_ROOT%\%CMP_ROOT%\experiments"

REM ===== Argument =====
set "SUFFIX=%~1"
if "%SUFFIX%"=="" (
  echo Usage:
  echo   new_exp_commit_fixed.bat short_name
  echo Example:
  echo   new_exp_commit_fixed.bat cat_strict_baseline
  exit /b 1
)

REM ===== Checks =====
if not exist "%REPO_ROOT%" (
  echo Error: REPO_ROOT not found
  echo   %REPO_ROOT%
  exit /b 1
)

if not exist "%EXP_BASE%" (
  echo Error: EXP_BASE not found
  echo   %EXP_BASE%
  exit /b 1
)

cd /d "%REPO_ROOT%"

REM ===== Today =====
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"') do set "TODAY=%%I"

REM ===== Find next number =====
set "MAXNUM=0"
for /d %%D in ("%EXP_BASE%\exp_%TODAY%_*") do (
    set "NAME=%%~nxD"
    set "NUMSTR=!NAME:~13,3!"
    set /a NUMVAL=1!NUMSTR! - 1000 2>nul
    if !NUMVAL! GTR !MAXNUM! set "MAXNUM=!NUMVAL!"
)

set /a NEXTNUM=MAXNUM+1

if %NEXTNUM% LSS 10 (
    set "PADNUM=00%NEXTNUM%"
) else (
    if %NEXTNUM% LSS 100 (
        set "PADNUM=0%NEXTNUM%"
    ) else (
        set "PADNUM=%NEXTNUM%"
    )
)

set "EXP_ID=exp_%TODAY%_%PADNUM%_%SUFFIX%"
set "EXP_DIR=%EXP_BASE%\%EXP_ID%"

REM ===== Template paths =====
set "TPL_DIR=%REPO_ROOT%\%CMP_ROOT%\templates\experiment"
set "TPL_CONFIG=%TPL_DIR%\config.yaml"
set "TPL_RESULT=%TPL_DIR%\result.md"
set "TPL_REVIEW=%TPL_DIR%\review.md"

if not exist "%TPL_CONFIG%" (
  echo Error: template config.yaml not found
  echo   %TPL_CONFIG%
  exit /b 1
)

if not exist "%TPL_RESULT%" (
  echo Error: template result.md not found
  echo   %TPL_RESULT%
  exit /b 1
)

if not exist "%TPL_REVIEW%" (
  echo Error: template review.md not found
  echo   %TPL_REVIEW%
  exit /b 1
)

REM ===== Create folder and copy files =====
mkdir "%EXP_DIR%" 2>nul
copy /Y "%TPL_CONFIG%" "%EXP_DIR%\config.yaml" >nul
copy /Y "%TPL_RESULT%" "%EXP_DIR%\result.md" >nul
copy /Y "%TPL_REVIEW%" "%EXP_DIR%\review.md" >nul

REM ===== Replace headings and yaml keys =====
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$expId = '%EXP_ID%';" ^
  "$title = '%SUFFIX%';" ^
  "$resultFile = '%EXP_DIR%\result.md';" ^
  "$reviewFile = '%EXP_DIR%\review.md';" ^
  "$configFile = '%EXP_DIR%\config.yaml';" ^
  "if (Test-Path $resultFile) {" ^
  "  $text = Get-Content -LiteralPath $resultFile -Raw -Encoding UTF8;" ^
  "  $text = [regex]::Replace($text, '(?m)^#\s*実験名\s*$', '# 実験名`r`n' + $expId, 1);" ^
  "  $text = [regex]::Replace($text, '(?m)^##\s*タイトル\s*$', '## タイトル`r`n' + $title, 1);" ^
  "  Set-Content -LiteralPath $resultFile -Value $text -Encoding UTF8;" ^
  "}" ^
  "if (Test-Path $reviewFile) {" ^
  "  $text = Get-Content -LiteralPath $reviewFile -Raw -Encoding UTF8;" ^
  "  $text = [regex]::Replace($text, '(?m)^#\s*実験名\s*$', '# 実験名`r`n' + $expId, 1);" ^
  "  Set-Content -LiteralPath $reviewFile -Value $text -Encoding UTF8;" ^
  "}" ^
  "if (Test-Path $configFile) {" ^
  "  $text = Get-Content -LiteralPath $configFile -Raw -Encoding UTF8;" ^
  "  if ($text -match '(?m)^title\s*:') {" ^
  "    $text = [regex]::Replace($text, '(?m)^title\s*:.*$', 'title: ' + $title, 1);" ^
  "  } else {" ^
  "    $text = 'title: ' + $title + '`r`n' + $text;" ^
  "  }" ^
  "  if ($text -match '(?m)^exp_id\s*:') {" ^
  "    $text = [regex]::Replace($text, '(?m)^exp_id\s*:.*$', 'exp_id: ' + $expId, 1);" ^
  "  } else {" ^
  "    $text = 'exp_id: ' + $expId + '`r`n' + $text;" ^
  "  }" ^
  "  Set-Content -LiteralPath $configFile -Value $text -Encoding UTF8;" ^
  "}"

echo.
echo Created:
echo   %EXP_DIR%
echo.
dir "%EXP_DIR%"
echo.
echo EXP_ID=%EXP_ID%

endlocal
