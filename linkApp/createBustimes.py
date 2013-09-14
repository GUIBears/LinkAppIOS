#!/usr/bin/python
# -*- coding: utf8 -*-
import sqlite3
import sys

con = sqlite3.connect('bustimes.db')
c = con.cursor()

c.execute("DROP TABLE IF EXISTS BusTimes")
c.execute("""CREATE TABLE BusTimes
				(id char PRIMARY KEY,
				Day char,
				Place char,
				Time char,
				M char)""")
				
f = open("times list", "r")

timeLines = f.readlines()

day = ""
place = ""
time = ""
id = 1
m = ''
for line in timeLines:
	if(line[0:1] == '@'):
		day = line[1:].strip()
	elif(line[0:1] == '$'):
		place = line[1:].strip()
	elif(line[0:1] == '!'):
		m = line[1:].strip();
		print m;
	elif(line[0:1] == '/'):
		continue;
	elif (line[0:1] == '%'):
		sys.exit()
	else:
		time = line.strip();
		c.execute("insert into BusTimes values ( ? , ? , ? , ? , ? )",(str(id), str(day), str(place), str(time), str(m)))
		print id, day, place, time
		id+=1
		con.commit()

con.commit()