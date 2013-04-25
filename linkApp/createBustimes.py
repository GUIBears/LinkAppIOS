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
				Time char
				)""")
				
f = open("times list", "r")

timeLines = f.readlines()

day = ""
place = ""
time = ""
id = 1
for line in timeLines:
	
	if(line[0:1] == '@'):
		day = line[1:].strip()
	elif(line[0:1] == '$'):
		place = line[1:].strip()
	elif (line[0:1] == '%'):
		sys.exit()
	else:
		time = line.strip();
		c.execute("insert into BusTimes values ( ? , ? , ?, ? )",(str(id), str(day), str(place), str(time)))
		print id, day, place, time
		id+=1
		con.commit()

con.commit()