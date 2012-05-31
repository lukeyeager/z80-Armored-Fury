@echo off
rem		Copyright 2010 Luke Yeager
rem	
rem		This file is part of Armored Fury.
rem
rem		Armored Fury is free software: you can redistribute it and/or modify
rem		it under the terms of the GNU General Public License as published by
rem		the Free Software Foundation, either version 3 of the License, or
rem		(at your option) any later version.
rem
rem		Armored Fury is distributed in the hope that it will be useful,
rem		but WITHOUT ANY WARRANTY; without even the implied warranty of
rem		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem		GNU General Public License for more details.
rem
rem		You should have received a copy of the GNU General Public License
rem		along with Armored Fury. If not, see <http://www.gnuorg/licenses/>.
rem
rem
rem		make.bat

set prog=ArmoredF

echo Compiling...
tools\TASM -80 -x -b src\%prog%.asm %prog%.obj %prog%.lst
echo Converting...
tools\BinTo8xpEng
echo Cleaning up...
del %prog%.obj
del %prog%.lst
echo Done.