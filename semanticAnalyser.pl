# Semantic Analyser
# By Moustafa Al-Hajj
# This program checks rules to see sentences satisfying them.
# Its input is text files in 'corpus' folder, and its output is a html file 
# where sentences satisfying rules are recognized. 
use strict;

#Read all variable from rules.txt and store value in an associative table %var
my %var = ();
open(RULES,"<:encoding(UTF-8)","rules.txt") || die "Opening file problem";
while(<RULES>){
	my $rule = $_;
	chomp($rule);
	if ( $rule =~ /^\s*::((\w|_)+)\s*=\s*(.*)\s*/){
		 my $varname = $1; 
		 my $varvalue = $3;
		 $varvalue =~ s/\s*\|/\|/g;
		 $varvalue =~ s/\|\s*/|/g;
		 $var{$varname} = $varvalue;
	}
}
close(RULES);


#segObeyRule: For a given $seg and a given @markers this function tests if the list of positive markers in @markers is belonged to $seg and the list of negative markers does not belonged to $seg respecting the order of markers in @markers
sub segObeyRule {
	my %failure = (-1=>"none");
	my ($seg,$max_dist_positive,$max_dist_negative,@markers) = @_;
	my %marks = {};
	my $negmarker = "";
	my $t = 0;	my $o = 0;	my $n = 0;	my $m = 0;	my $r = 0;	my $pos = 0;
	my $firstpositive = 1;
	my $firstnegative = 1;
	
	my $rrr = 0;
	my $segres = "";
	my $temp = "";
	
	foreach my $marker(@markers){
		#if ($marker =~ /^-:((\w|_)+)/){
		#	$marker = "-".$var{$1};
		#}elsif($marker =~ /^:((\w|_)+)/){
		#	$marker = $var{$1};
		#}
		$marker =~ s/::((\w|_)+)/\($var{$1}\)/g;
		if($marker !~ /^-/ && $marker !~ /^RRR$/){
			#$marker = substr($marker,1);
			if($marker !~ /[:'",.;%!?]/ ){#if marker does not contain one of these characters
				$marker = "\\b$marker\\b";#add bondaries side to the marker, \b to match the left or right bondary of the term in $marker
			}
			START:
			if($seg =~ /$marker/gi){
				my $aaa = $';
				my $bbb = $&;
				my $ccc = $`;
				if ( ($bbb =~ /\w$/ && $aaa =~ /^\w/) || ($bbb =~ /^\w/ && $ccc =~ /\w$/) ){
						goto START;
				}
				my $between = $ccc;
				$temp = $between;
				$m = length($bbb);
				$r = length($aaa);
				$seg = $aaa;

				$n = length($between);
				$t += $n+$m;$o = $t-$m;
				######test distance betweeen markers######## 
				my $cw = 0;
				while ($between =~ /\b\w+\b/g ){
					$cw++;
				}
				if( $cw > $max_dist_positive && $firstpositive == 0){ return ($segres,%failure); }
				####################
				if($marks{$o}=~/^<\/[pn]/){
					$marks{$o} .= "<positive style='background-color:yellow;'>";
				}else{
					$marks{$o} = "<positive style='background-color:yellow;'>".$marks{$o};
				}
				if($marks{$t}=~/^<\/[pn]/){
					$marks{$t} .= "</positive>";
				}else{
					$marks{$t} = "</positive>".$marks{$t};
				}
				
				#####If there is a variable RRR to extract from $seg then keep $between in $segres
				if($rrr == 1){
					$segres .= "<li><span>".$temp."</span></li>"; 
					$rrr = 0;
				}
				if ($negmarker ne ""){
					$pos = $o-$n;
					if( $firstnegative == 1 && $firstpositive == 1 ){
						$firstnegative = 0;
						if ( $between =~ /(.*)((\b\w+[^\w]+){$max_dist_negative})/ ){
							$between = $2;
							$pos = $pos + ($o-length($between));
						}
					}
					if( $between =~ /\b$negmarker\b/i ){
						return ($segres,%failure);
					}
					
					if($between ne ""){
						if($marks{$pos}=~/^<\/[pn]/){
							$marks{$pos} .= "<negative class='tooltip'><NO-marker class='tooltiptext'>$negmarker</NO-marker>";
						}else{
							$marks{$pos} = "<negative class='tooltip'><NO-marker class='tooltiptext'>$negmarker</NO-marker>".$marks{$pos};
						}
						if($marks{$o}=~/^<\/[pn]/){
							$marks{$o} .= "</negative>";
						}else{
							$marks{$o} = "</negative>".$marks{$o};
						}
					}
					$negmarker = "";
				}
				if( $firstpositive == 1 ){
					$firstpositive = 0;
     			}
			}else{
				return ($segres,%failure);
			}

		}elsif($marker =~ /^-/){
			$negmarker = substr($marker,1);
		}elsif($marker =~ /RRR/){
			$rrr = 1;
		}
	}
	$temp = $seg;
	#####If there is a variable RRR to extract from $seg then keep $between in $segres
	if($rrr == 1){
		$segres .= "<li><span>".$temp."</span></li>"; 
		$rrr = 0;
	}
	
	if( $negmarker ne "" ){
		my $gg = 0; # to remove from the end in case of number of words greater than max_dist_negative 
		if ( $seg =~ /((\b\w+[^\w]+){$max_dist_negative})/ ){
			$seg = $1;
			$gg = length($');
		}
		if( $seg =~ /\b$negmarker\b/i ){
			return ($segres,%failure);
		}
		$pos = $o+$m;
		if($seg ne ""){
			if($marks{$pos}=~/^<\/[pn]/){
				$marks{$pos} .= "<negative class='tooltip'><NO-marker class='tooltiptext'>$negmarker</NO-marker>";
			}else{
				$marks{$pos} = "<negative class='tooltip'><NO-marker class='tooltiptext'>$negmarker</NO-marker>".$marks{$pos};
			}
			$pos = $o+$m+$r-$gg;
			if($marks{$pos}=~/^<\/[pn]/){
				$marks{$pos} .= "</negative>" ;
			}else{
				$marks{$pos} = "</negative>".$marks{$pos} ;
			}
		}
	}
	
	return ($segres,%marks); 
}

sub insertTags{
	my ($str,%positions) = @_;
	foreach my $k (keys(%positions)) {
		if($k =~ /^HASH/){
			delete $positions{$k};
		}
	}
	foreach my $pos (sort {$b <=> $a} keys %positions){
		substr($str, $pos, 0) = $positions{$pos};
	}
	return $str;
}
sub sentencesEn{
	my $para = shift;
	my @parts = split(/(?<!\W\w[.])(?<![A-Z]\w[.])(?<![A-Z]\w\w[.])(?<![A-Z]\w\w\w[.])(?<=[.])(\s+)?(?=[^a-z])/,$para);
	return @parts; 
}
sub sentencesAr{
	my $para = shift;
	my @parts = split(/(?<=(\.))(\s+)?(?=.)/,$para);
	return @parts; 
}

sub readtext{
	my($filename,$lang) = @_;
	open(TEXT,"<:encoding(UTF-8)","$filename");
	my @segments = ();
	my $origtext;
	while(my $segment = <TEXT>){
		$origtext .= $segment."<br/>";
		$segment =~ s/\x{064f}|\x{064e}|\x{064d}|\x{064c}|\x{064b}|\x{0652}|\x{0651}|\x{0650}|\x{061a}|\x{0619}|\x{0618}//g;
		$segment =~ s/(\x{0623}|\x{0625}|\x{0622})/\x{0627}/g;
		
		chomp($segment);
		my @parts = ();
		if($lang eq "ar"){
			@parts = sentencesAr($segment);
		}else{
			@parts = sentencesEn($segment);
		}
		push(@segments,@parts);
	}
	close(TEXT);
	return ($origtext,@segments);
}





#Create and open file results.html to write all results 
open(RES,">:encoding(UTF-8)","results.html");
print RES "<html>
	<head>
	<title>Semantic Analysis</title>\n
	<meta name=\"author\" content=\"Moustafa AL-HAJJ\" />\n
	<meta name=\"description\" content=\"Sematic analysis\" />\n
	<meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>
	<style>
		ol li {margin-bottom: 10px;font-size:18px;}
	</style>
	</head>
	<body style='background:#f7fcfe none repeat scroll 0 0;color: #253b80;'>
	<h1>Results</h1>
	<ol style='padding-left:40px;'>
	";
my $g;
my $lang = "NONE";
my $direction = "";
my $max_dist_positive = 100;
my $max_dist_negative = 100; 
my $origtext;
my @segments;

my $existingdir = "corpus";
my $dirresult = "corpus/results";
mkdir $existingdir unless -d $existingdir;
mkdir $dirresult unless -d $dirresult;

my $dir = 'corpus/';


opendir(DIR, $dir) or die $!;
while (my $file = readdir(DIR)) {
	next unless (-f "$dir/$file");
	next unless ($file =~ m/\.txt$/);
	open(RR,">:encoding(UTF-8)","$dir"."results/"."$file.html") || die $!;
	print RES "<li><a href='$dir"."results/"."$file.html'>$file</a></li>";
	
	open(RULES,"<:encoding(UTF-8)","rules.txt") || die "Opening file problem";
	$g = 0;
	my %rescateg=(); 
	while(<RULES>){
		my $rule = $_;
		$g++;
		if ( $g == 2 ) {
			if( $rule =~ /(\s+)?lang(\s+)?=(\s+)?(\w+)(\s+)?/){
				$lang = $4;
				($origtext,@segments) = readtext("$dir$file",$lang);
			}
			if ($lang eq "ar"){$lang = "rtl";$direction="right"}else{$lang = "ltr";$direction="left";}
			print RR "<html>
	<head>
	<title>Semantic Analysis</title>\n
	<meta name=\"author\" content=\"Moustafa AL-HAJJ\" />\n
	<meta name=\"description\" content=\"Sematic analysis\" />\n
	<meta http-equiv='Content-Type' content='text/html;charset=UTF-8'>
	<style>
	.tooltip {
		position: relative;
		display: inline-block;
		border-bottom: 1px dotted black;
		background-color:rgba(255,65,0,1);
	}
	.tooltip .tooltiptext {
		visibility: hidden;
		width: 120px;
		background-color: rgba(0, 0, 0, 0.6);
		color: #fff;
		text-align: center;
		border-radius: 6px;
		padding: 5px 0;
		/* Position the tooltip */
		position: absolute;
		z-index: 1;
		top: -5px;
		$direction: 101%;
	}
	.tooltip:hover .tooltiptext {
		visibility: visible;
	}
	ol li{white-space:pre-wrap;text-align:justify;}
	ol li ul {border: 1px solid red;}
	
	h4{font-family: Verdana, Arial, Helvetica, sans-serif;color: #6600FF;}
	</style>
	</head>
	 <body dir=$lang";
	if ($lang eq "rtl"){
		print RR " style='font-family:traditional arabic;font-size: 20px; font-weight: bold;background:#f7fcfe none repeat scroll 0 0;'";
	}elsif ($lang eq "ltr"){
		print RR " style='	font-family: \"Lucida Grande\",\"Lucida Sans Unicode\",Helvetica,Arial;
		font-size: 14px;
		font-style: normal;
		line-height: 24px;
		font-variant: normal;background:#f7fcfe none repeat scroll 0 0;'";
	}
	print RR ">";
	print RR "<h2 align=center color='brown' width='190px' style='background-color: lime;font-size: 100%;'>RESULT</h2>";
	#print RR "<ol  style='width:92%;'>	";
		}elsif ($g == 3){
			if( $rule =~ /(\s+)?max_distance_positive(\s+)?=(\s+)?(\d+)(\s+)?/ ){
				$max_dist_positive = $4;
			}
		}elsif ( $g == 4){
			if ($rule =~ /(\s+)?max_distance_negative(\s+)?=(\s+)?(\d+)(\s+)?/){
				$max_dist_negative = $4;
			}
		}elsif ($g >= 5){
			chomp($rule);
			if ( $rule !~ /^\s*::((\w|_)+)\s*=\s*(.*)\s*/){
				if( $rule !~ /^\s*$/){
					$rule =~ s/\s+$//;
					$rule =~ s/\x{064f}|\x{064e}|\x{064d}|\x{064c}|\x{064b}|\x{0652}|\x{0651}|\x{0650}|\x{061a}|\x{0619}|\x{0618}//g;
					$rule =~ s/(\x{0623}|\x{0625}|\x{0622})/\x{0627}/g;
					
					my @rc = split(/\s*-\s*>\s*/,$rule);
					
					
					my @markers = split(/\s*>\s*/,$rc[0]);
					foreach my $seg ( @segments ){
						my ($segres,%results) = segObeyRule($seg,$max_dist_positive,$max_dist_negative,@markers);
						if( $results{-1} ne "none" ) {
							if($segres ne ""){$segres = "<ul>".$segres."</ul>";}
							my $s = "<li>".insertTags($seg,%results).$segres."</li>";
							$rescateg{uc($rc[1])} .= $s;
							#print RR "<li>$s</li>\n";
						}
					}
				}
			}
		}
	}
	foreach my $k (keys(%rescateg)) {
		print RR "<h4>$k</h4>";
		print RR "<ol  style='width:92%;'>	";
		print RR $rescateg{$k};
		print RR "</ol>\n	";
	}
	print RR "<h2 align = center  style='background-color: lime;font-size: 100%;'>ORIGINAL TEXT</h2>";
	print RR "<div style='padding-left:30px;padding-right:30px;text-align:justify;'>$origtext</div>
	<br><br>
	<hr align=\"center\" color=\"brown\" width=\"190px\">
	<div align=\"center\" style=\"font-family: verdana; direction: ltr; font-size: 9px;\">
	CSLC tools 2018. All Rights Reserved.  </div>
	</body>
	</html>";
	close(RR);
	close(RULES);
}
closedir(DIR);

print RES "</ol>
</body>
</html>";
close(RES);
my $display = `start "" results.html`;
exit;
