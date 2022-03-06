@echo off
set /P mizfile=Enter .miz File:
echo %mizfile%
npm run jtff-inject --mission=%mizfile%
pause