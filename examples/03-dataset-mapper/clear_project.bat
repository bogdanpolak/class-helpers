@echo off
echo Deleting Delphi temporary files ...
del /s *.dcu 2> nul
del /s *.exe 2> nul
del /s *.dll 2> nul
del /s *.bpl 2> nul
del /s *.dcp 2> nul
del /s *.~* 2> nul
del /s *.local 2> nul
del /s *.identcache 2> nul
del /s *.stat 2> nul
echo Done.
