# Semantic Analyser
This program is made for linguistics researchers, who create linguistic rules and want to extract and classify sentences following a set of semantic categories.

This program extracts, from a corpus of arabic, french or english documents, sentences satisfying a set of linguistic rules and belonging to defined semantic categories. Linguistic markers (whether they are positive or negative) are highlited in extracted sentences helping linguistics to verify the validity of their linguistic rules. 

## Input of the program

    1. Text files .txt stored in the 'corpus' directory

    2. A set of linguistic rules defined in the file 'rules.txt' in the following format:

    PM or -NM>PM or -NM>etc. -> SC

    Where 

        PM: a Positive Marker

        AM: a Negative Marker

        SC: a Semantic Category

        Note the use of '-' symbol before negative markers, '>' symbol to indicate 'followed by' and '->' to enter after it the semantic category

    For example, to write the following linguistic rule for the semantic category 'CITATION': 'said' not preceded by 'does not' and followed by 'that', one should write the following rule: -does not>said>that -> citation

## Output of the program

    html files showing extracted sentences grouped by semantic categories where positive markers are highlighted in yellow and the context of negative markers are highlighted in red. Negative markers appear when moving the mouse over contexts in red.

    This program splits texts into sentences and then researches in sentences positive and negative markers in order they appear in rules definied in 'rules.txt'.

## To use it

    1. Download files from GitHub : https://github.com/moustafaalhajj/semantic_analyser

    2. Install activestate on your computer from here https://www.activestate.com/activeperl/downloads

    3. Create the 'corpus' directory and put into it all your text files .txt to process

        All txt files must be in utf8 encoding

    4. Create 'rules.txt' (you can download it) and put into it following lines in the same order (Don't include empty lines):

    #Enter rules starting at the fifth line, one rule by line.

    lang = en #(en,ar,fr)

    max_distance_positive = 20 #the max distance (in number of words) separating two consecutive positive markers

    max_distance_negative = 12 #the min distance (in number of words) seperating negative markers from positive markers. max_distance_negative is only considered when negative markers appear at the begining and at the end of rules, otherwise for negative markers between positive markers max_distance_negative is not considered.

    Enter here the rules, for example: -doesn't>said>that -> citation

    ########End file 'rules.txt' (do not include this line in 'rules.txt')######

    5. Double clic the file 'semanticAnalyser.pl', then the file results.html will be created and visualised in your default internet browser.
