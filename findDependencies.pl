#! /usr/bin/perl

# Author David Kanda
# Date Modified 1/29/2015
# Description Creates an array of package names that are elements
# 	of the dependency tree of that package plus the root package
# pre yum-utils package 'yumdownloader' must be installed
# 	user executing script has root permission for command 'yumdownloader'
#	yum repo licensed to RHEL server
# post file returned containing initial package name + all its dependencies' names
# param $initialPackageName the name of the package we are finding the dependencies of

my $initialPackageName = "firefox-31.4.0-1.el5_11.i386";
# start the rpmList with the initial package name that we want
# 	to search the depencies of
my @rpmList = ($initialPackageName);
my $outfile = 'log.txt';

open (FILE, ">> $outfile") || die "problem opening $outfile\n";

foreach my $rpmName(@rpmList)
{
	print $rpmName;
    my $getRPMName = `yumdownloader --resolve --urls $rpmName`;

    if ( $getRPMName =~ /Nothing to download/gi )
    {
    	# nothing to dl here
    }
    else
    {
	    #run command to download rpm package
        my $output = `sudo yumdownloader --resolve --urls $rpmName`;
        # convert rpmList to hash to quickly check for duplicates
        my %rpmHash = map { $_ => 1 } @rpmList;

        while ($output =~ /\/([\w\d\.\-!\(\):<>\?,]*)\.rpm/g) 
        {
        	if(!exists($rpmHash{$1})) 
        	{
        		print FILE $1. "\n";
        		push(@rpmList, $1);
        		$rpmHash{$1} = "";
        	}
    	}
	}
}
close(FILE);