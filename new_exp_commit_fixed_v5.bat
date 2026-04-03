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
  echo   new_exp_commit_fixed_v5.bat short_name
  echo Example:
  echo   new_exp_commit_fixed_v5.bat cat_strict_baseline
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

REM ===== Build temporary PowerShell script =====
set "TMP_PS1=%TEMP%\new_exp_commit_update.ps1"

> "%TMP_PS1%" echo param(
>> "%TMP_PS1%" echo   [string]$ExpDir,
>> "%TMP_PS1%" echo   [string]$ExpId,
>> "%TMP_PS1%" echo   [string]$Title
>> "%TMP_PS1%" echo )
>> "%TMP_PS1%" echo $resultFile = Join-Path $ExpDir 'result.md'
>> "%TMP_PS1%" echo $reviewFile = Join-Path $ExpDir 'review.md'
>> "%TMP_PS1%" echo $configFile = Join-Path $ExpDir 'config.yaml'
>> "%TMP_PS1%" echo.
>> "%TMP_PS1%" echo if ^(Test-Path $resultFile^) ^{
>> "%TMP_PS1%" echo   $lines = Get-Content -LiteralPath $resultFile -Encoding UTF8
>> "%TMP_PS1%" echo   for ^($i = 0; $i -lt $lines.Count; $i++^) ^{
>> "%TMP_PS1%" echo     if ^($lines[$i] -eq '# 実験名' -and $i + 1 -lt $lines.Count^) ^{ $lines[$i + 1] = $ExpId ^}
>> "%TMP_PS1%" echo     if ^($lines[$i] -eq '## タイトル' -and $i + 1 -lt $lines.Count^) ^{ $lines[$i + 1] = $Title ^}
>> "%TMP_PS1%" echo   ^}
>> "%TMP_PS1%" echo   Set-Content -LiteralPath $resultFile -Value $lines -Encoding UTF8
>> "%TMP_PS1%" echo ^}
>> "%TMP_PS1%" echo.
>> "%TMP_PS1%" echo if ^(Test-Path $reviewFile^) ^{
>> "%TMP_PS1%" echo   $lines = Get-Content -LiteralPath $reviewFile -Encoding UTF8
>> "%TMP_PS1%" echo   for ^($i = 0; $i -lt $lines.Count; $i++^) ^{
>> "%TMP_PS1%" echo     if ^($lines[$i] -eq '## 実験名' -and $i + 1 -lt $lines.Count^) ^{ $lines[$i + 1] = $ExpId ^}
>> "%TMP_PS1%" echo   ^}
>> "%TMP_PS1%" echo   Set-Content -LiteralPath $reviewFile -Value $lines -Encoding UTF8
>> "%TMP_PS1%" echo ^}
>> "%TMP_PS1%" echo.
>> "%TMP_PS1%" echo if ^(Test-Path $configFile^) ^{
>> "%TMP_PS1%" echo   $lines = Get-Content -LiteralPath $configFile -Encoding UTF8
>> "%TMP_PS1%" echo   $inExperiment = $false
>> "%TMP_PS1%" echo   for ^($i = 0; $i -lt $lines.Count; $i++^) ^{
>> "%TMP_PS1%" echo     if ^($lines[$i] -match '^\s*experiment\s*:\s*$'^) ^{ $inExperiment = $true; continue ^}
>> "%TMP_PS1%" echo     if ^($inExperiment -and $lines[$i] -match '^[^\s]'^) ^{ $inExperiment = $false ^}
>> "%TMP_PS1%" echo     if ^($inExperiment -and $lines[$i] -match '^\s{2}exp_id\s*:'^) ^{ $lines[$i] = '  exp_id: ' + $ExpId; continue ^}
>> "%TMP_PS1%" echo     if ^($inExperiment -and $lines[$i] -match '^\s{2}title\s*:'^) ^{ $lines[$i] = '  title: "' + $Title + '"'; continue ^}
>> "%TMP_PS1%" echo   ^}
>> "%TMP_PS1%" echo   Set-Content -LiteralPath $configFile -Value $lines -Encoding UTF8
>> "%TMP_PS1%" echo ^}

powershell -NoProfile -ExecutionPolicy Bypass -File "%TMP_PS1%" -ExpDir "%EXP_DIR%" -ExpId "%EXP_ID%" -Title "%SUFFIX%"
if errorlevel 1 (
  echo Error: PowerShell update step failed
  exit /b 1
)

del "%TMP_PS1%" >nul 2>nul

echo.
echo Created:
echo   %EXP_DIR%
echo.
dir "%EXP_DIR%"
echo.
echo EXP_ID=%EXP_ID%

endlocal
