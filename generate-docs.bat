@echo off
lime build windows
haxelib run dox -t types.xml --title Brainyverse API Documentation --include-private -o ./docs