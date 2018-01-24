# semantic_analyser
This program extracts, form a corpus of text files (in arabic, french or english), sentences satisfying a set of linguistic rules.

This program takes as an input texts from files (txt files), and generates as output html files containing sentences satisfying specific set of linguistic rules. This program splits first text into sentences then recognizes and extracts sentences satisfying specified rules.

To use it

Install first activestate on your computer from here https://www.activestate.com/activeperl/downloads

Create the 'corpus' directory and put into it all your txt files to process

All txt files must be in utf8 encoding

Create 'rules.txt' and put into it following lines (Don't include empty lines):

######Begin file 'rules.txt' (Do not include this line)#########<br>

#Enter rules starting at the fifth line, one rule by line. Use > to separate markers, enter - before every negative marker

lang = en #(en,ar,fr)

max_distance_positive = 20 #distance in number of words that separates two consecutive positive markers 

max_distance_negative = 12 #distance in number of words that seperates negative markers from positive markers only at the beginning and at the end of sentences

Enter here the rules, for example: -doesn't>said>that 

########End file 'rules.txt' (do not include this line in 'rules.txt')######

Double clic the file 'sematicAnalysis.pl' a file results.html will be created and then visualised in your default internet browser.

Text highlighted in yellow marks positive markers

Text highlighted in red marks the context in which there is no negative marker, move your mouse over this zone to see which negative marker 

This program has been created by Moustafa Al-Hajj, associate professor at CSLC: http://cslc.univ-ul.com

Any questions or comments, please send me an e-mail at moustafa DOT alhajj AT gmail DOT com (Do not include spaces)
