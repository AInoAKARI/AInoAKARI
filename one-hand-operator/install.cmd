@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/AInoAKARI/AInoAKARI/main/one-hand-operator/install.ps1' | iex"
set EXIT_CODE=%ERRORLEVEL%
echo.
if not "%EXIT_CODE%"=="0" (
  echo 導入に失敗しました。上の表示をスクリーンショットしてください。
) else (
  echo 導入完了。右手だけで操作できます。
)
pause
exit /b %EXIT_CODE%
