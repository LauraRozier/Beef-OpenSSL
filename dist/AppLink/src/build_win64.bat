@ECHO OFF

cl /c /EHsc AppLink.c
lib /OUT:"..\dist\Win64\AppLink.lib" AppLink.obj
DEL /Q /S AppLink.obj
