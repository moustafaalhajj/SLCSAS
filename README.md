# semantic_analyser
Form a corpus of text files in arabic, french or english, this program extracts sentences satisfying a set of defined linguistic rules.

INPUT OF THE PROGRAM

1. Texts from files (files .txt in 'corpus' repertory)

2. A set of linguistic rules defined in 'rules.txt' in the following format:

    a_positive_linguistic_marker or -a_negative_linguistic_marker>another_positive_linguistic_marker or -another_negative_linguistic_marker>etc. 

    Note the use of '-' symbol before negative markers and '>' symbol to indicate followed by

    For example, to write the following linguistic rule : 'said' not preceded by 'does not' and followed by 'that', one should write the following rule: -does not>said>that 

OUTPUT OF THE PROGRAM 

html files showing extracted sentences where positive markers are highlighted in yellow and the context of negative markers are highlighted in red. Negative markers appear when moving the mouse over contexts in red.  

This program splits texts into sentences and then researches in sentences positive and negative markers in order they appear in rules definied in 'rules.txt'.

TO USE IT

1. Install first activestate on your computer from here https://www.activestate.com/activeperl/downloads

2. Create the 'corpus' directory and put into it all your files .txt to process

    All txt files must be in utf8 encoding

3. Create 'rules.txt' (if does not exist) and put into it following lines in the same order (Don't include empty lines):

    #Enter rules starting at the fifth line, one rule by line.

    lang = en #(en,ar,fr)

    max_distance_positive = 20 #the max distance (in number of words) separating two consecutive positive markers 

    max_distance_negative = 12 #the min distance (in number of words) seperating negative markers from positive markers. Only negative markers at the begining and at the end of rules are used, negative markers between positive markers are not used.

    Enter here the rules, for example: -doesn't>said>that 

    ########End file 'rules.txt' (do not include this line in 'rules.txt')######

4. Double clic the file 'sematicAnalysis.pl', then the file results.html will be created and visualised in your default internet browser.


This program has been created by Moustafa Al-Hajj, associate professor at CSLC: http://cslc.univ-ul.com

Any questions or comments, please send me an e-mail at moustafa DOT alhajj AT gmail DOT com (Do not include spaces)
