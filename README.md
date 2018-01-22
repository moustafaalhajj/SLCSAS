# semantic_analyser
This program extracts form a corpus of text files sentences that satisfy a set of linguistic rules

This program takes texts as an input from files in 'corpus' folder, and generates as output some html files in which sentences satisfying specific linguistic rules are extracted. This program splits text into sentences then recognizes sentences satisfying a set of specific rules.

Install first activestate on your computer from here https://www.activestate.com/activeperl/downloads

Create the 'corpus' and put into it all your txt files to process

All txt files must be in utf8 encoding

Create 'rules.txt' and put into it following lines: 
#Enter rules starting at the fifth line, one rule by line. Use > to separate markers, enter - before every negative marker
lang = en #(en,ar,fr)
max_distance_positive = 20 #distance in number of words that separates two consecutive positive markers 
max_distance_negative = 12 #distance in number of words that seperates negative markers from positive markers only at the beginning and at the end of sentences
Enter here the rules, for example: said>that 
End file 'rules.txt' (do not include this line in 'rules.txt')

To use it, type
Double clic the file 'sematicAnalysis.pl'
a file results.html will be created and opened.

Any questions or comments, please send me an e-mail at moustafa DOT alhajj AT gmail DOT com (Do not include spaces)

This program has been created by Moustafa Al-Hajj, associate professor at CSLC: http://cslc.univ-ul.com

