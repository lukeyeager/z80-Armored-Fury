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
set outdir=bin

echo --- Assembling code ---
tools\TASM -80 -x -b -c src\%prog%.asm %outdir%\%prog%.bin %outdir%\%prog%.lst
echo --- Converting output ---
cd %outdir%
binpac8x.py %prog%.bin %prog%.8xp
cd ..
echo --- Done ---

rem Pause for one second
ping -n 2 127.0.0.1 >nul
