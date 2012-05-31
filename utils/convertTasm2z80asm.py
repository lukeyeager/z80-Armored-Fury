#!/usr/bin/python
#
#	Luke Yeager
#	May 2012
#
#	This file converts Z80 assembly files written for the TASM compiler (windows) into
#	code written for the z80asm compiler (linux, version 1.8)

import sys
import os
import re

def main():
	for i in range(1, len(sys.argv)):
		convertFile(sys.argv[i])

def convertFile(fileName):
	tmpFile = 'out.tmp'

	print "Converting file: \"", fileName, '\"...'

	with open(fileName, 'r') as fileIn:
		fileOut = open(tmpFile, 'w')

		for line in fileIn:
			# Fix tabs
			line = re.sub(r'    ', '\t', line)

			# Fix list/nolist
			line = re.sub(r'\.nolist', ';.nolist', line)
			line = re.sub(r'\.list', ';.list', line)

			# fix include
			line = re.sub( '#include', 'include', line)

			# Fix equ
			m = re.match( r'^(\w+)(\s+)(.equ|equ|.EQU|EQU|\=)(\s+.+)$', line)
			if m:
				line = m.group(1) + ':' + m.group(2) + "equ" + m.group(4) + '\n'

			# Fix b_call
			m = re.match( r'^(.*)(b_call|B_CALL)\((.+)\)(.*)$', line)
			if m:
				line = m.group(1) + 'b_call\t' + m.group(3) + '\t' + m.group(4) + '\n'
			
			# Fix db / dw
			line = re.sub(r'\.db|\.DB', 'db', line)
			line = re.sub(r'\.dw|\.DW', 'dw', line)
			
			# Fix org
			line = re.sub(r'\.org|\.ORG', 'org', line)
			
			# Fix end
			line = re.sub(r'\.end|\.END|end|END', 'end', line)
			
			fileOut.write(line)

	fileOut.close()

	os.rename(tmpFile, fileName)

main()
