#!/usr/bin/perl
# Parse the ATI/AMD personality initialization functions
# found in the ATIFramebuffer/ATI*Controller kext(s).
# Locate the ConnectorInfo table address and length
#
# getopt/usage handling and some extra option processing contributed by
# zhell at insanelymac.com 
#
# Copyright (c) 2011-2014 B.C. <bcc24x7@gmail.com> (bcc9 at insanelymac.com).
# All rights reserved.

use File::Basename;
use Getopt::Long qw(:config auto_help);
use Pod::Usage;

my $version = "0.15";
my $arch = "x86_64";
my $sledir = "/System/Library/Extensions";
my $verbose = 0;
my $vmaddr;
my $fileoff;
my $arch_offset = 0;
my $ddcmd;
my $tmpfile = "/tmp/x";

#Given a hex string in an operand string, strip off preceeding 0x and any index
#register, just leaving the hex value itself.  Convert result to decimal.
sub hexstrtoint
{
    my($prefix, $val, $post) = split(/0x|\(/, $_[0], 3);
    return hex($val);
}

#find first fileoff (decimal), first vmaddr (hex)
sub parse_seg
{
    my $dump = $_[0];
    my $ignore;

    open(IN, "$dump |") || die "Cannot open $dump for input\n";
    while ($_ = <IN>) {
	if (!/Load command/) {
	    next;
	}
	while (!/Section/) {
	    $_ = <IN>;
	    if (/vmaddr/) {
		($ignore, $vmaddr) = split(/vmaddr /, $_, 2);
		$vmaddr = hexstrtoint($vmaddr);
	    }
	    if (/fileoff/) {
		($ignore, $fileoff) = split(/fileoff /, $_, 2);
	    }
	}
	close(IN);
	return;
    }
    die "Couldn't parse segment information";
}

sub parse_fat
{
    my $dump = $_[0];

    open(IN, "$dump |") || die "Cannot open $dump for input\n";
    while ($_ = <IN>) {
	if (!/architecture $arch/i) {
	    next;
	}
	while (!/offset/) {
	    $_ = <IN>;
	}
	my($ignore, $offset) = split(/offset /, $_, 2);
	if ($verbose > 1) {
	    printf "Offset for architecture %s is %d\n", $arch, $offset;
	}
	close(IN);
	return $offset;
    }
    die "Couldn't find segment for $arch architecture";
}

sub parse_instr
{
    my $dump = $_[0];
    my $cnt;

    open(IN, "$dump |") || die "Cannot open $dump for input\n";
    while ($_ = <IN>) {
	if (!/createInfo/) {
	    next;
	}

	my @loadaddr = ();
	my @movl = ();
	my @leal = ();
	my @loadnext = ();
	my $storeinst;
	my $countinst;
	my $loadop;
	my $countop;
	my $track_relative_addr = 0;
	my $pc;
	my $got_load = 0;

	if ($arch eq "i386") {
#As of 10.7 the compiler is optimizing the code a bit better, and now we
#always should look at a movl instruction for the load address
	    if ($osxvers >= "10.7") {
		$loadop = "movl.+,%edx\$";
	    } else {
		$loadop = "addl";
	    }
	    $countop = "movb.+0x03\\(%e";
	} else {
	    $loadop = "leaq";
	    if ($osxvers >= "10.9") {
		$countop = "mov[bw].+0x01\\(%r";
	    } else {
		$countop = "movb.+0x03\\(%rsi";
	    }
	}
	my($personality) = split /Info/, $_, 2;
	print "Personality: " . $personality . "\n";
	while (!/ret$/) {
	    $_ = <IN>;
	    if ($verbose > 1) {
		print $_;
	    }
	    if ($got_load) {
		push(@loadnext, $_);
		$got_load =0;
	    }
	    if (/$countop/) {
		$countinst = $_;
	    }
	    if (/$loadop/) {
		push(@loadaddr, $_);
		$got_load = 1;
	    }
	    if (/movl.+0x0c\(%eax\)/) {
		push(@movl, $_);
	    }
	    if (/leal/) {
		push(@leal, $_);
	    }
	}
	if ($#loadaddr == -1) {
	    $storeinst = $movl[-1];
	} else {
	    $storeinst = $loadaddr[-1];
	}
	if ($osxvers >= "10.7") {
# XXX wormy case is still special - uses leal instruction
	    if (!$storeinst) {
		$storeinst = $leal[-1];
	    }
	}
	if (!$storeinst) {
	    print "Error: table not found\n";
	} else {
	    my($addr, $operator, $operands) = split(/\t/, $countinst, 3);
	    my($op1, $op2) = split(/,/, $operands, 2);

	    if ($op1 eq "%al" || $op1 eq "%dl" || $op1 eq "%bl") {
		# XXX The "Wormy" personality case
		#register has count which is dynamically computed...
		$op1 = "0x02";
	    }

	    $cnt = hexstrtoint($op1) & 0xff;
	    print "ConnectorInfo count in decimal: " . $cnt . "\n";
	    if ($arch eq "x86_64") {
		if ($cnt == 1) {
		    #load instruction may not be last
		    my $index;

		    for ($index = 0; $index <= $#loadnext; $index++) {
			if ($loadnext[$index] =~ /0x10\(%rsi\)/) {
			    $storeinst = $loadaddr[$index];
			    if ($verbose > 1) {
				print "Found load at index " . $index . "\n";
			    }
			}
		    }
		}
	    }

	    my($addr, $operator, $operands) = split(/\t/, $storeinst, 3);
	    my($op1, $op2) = split(/,/, $operands, 2);
	    $op1 = hexstrtoint($op1);
	    if ($arch eq "x86_64") {
		$pc = hex($addr);
		$op1 = $op1 + $pc + 7;
	    }
	    if ($verbose) {
		printf "Effective address for ConnectorInfo table in hex: %x\n" , $op1;
	    }
	    my $diskaddr = $arch_offset + $fileoff + ($op1 - $vmaddr);
	    printf "Disk offset in decimal %d\n", $diskaddr;
	    system("rm -f " . $tmpfile);
	    if ($?) {
		printf "Cannot setup temp file %s\n", $tempfile;
		exit(1);
	    }
	    system($ddcmd . $diskaddr . " count=" . ($cnt*16) . " 2> /dev/null");
	    if ($?) {
		printf "dd command failed\n";
		exit(1);
	    }
	    system("od -Ax -tx1 " . $tmpfile);
	    if ($?) {
		printf "od command failed\n";
		exit(1);
	    }

	    if ($verbose) {
		print "Prep Store instruction: " . $storeinst;
		printf "Count instruction: " . $countinst;
	    }
	}
    }
    close(IN);
}

sub main()
{
    my $allkext = 0;
    my $kextarg = 0;
    my $oldstylekext;
    my $dump;
    my $dumpl;
    my $lipo;
    my $pipecmd;
    my $otool_base_cmd, $have_otool;

    GetOptions (
        'a' => \$allkext, #Use if you have 10.6 2011 MBP kexts installed
        'x' => \$arg_x,
        'i386' => \$arg_i386,
	'o=s' => \$osxvers,
        'v+' => \$verbose,
        's=s' => \$sledir
	) || pod2usage(1);

    if (!$osxvers) {
	chomp($osxvers = `sw_vers -productVersion`);
    }
    printf "Script version %s\n", $version;
    if ($verbose) {
	printf "OS version: %s\n", $osxvers;
    }

    
    if ($arg_i386) {
	$arch = "i386";
    }
    if ($arg_x) {
	$arch = "x86_64";
    }

    if ($osxvers >= "10.7") {
	$allkext = 1;
    }

    my @kexts = ();
    $oldstylekext =
	"$sledir/ATIFramebuffer.kext/Contents/MacOS/ATIFramebuffer";
	
    # If anything is left in ARGV, consider it the name of a KEXT to parse
    if ($ARGV[0]) {
	# Parse only specified KEXT
	if (-d $ARGV[0] && $ARGV[0] =~ '\.kext$') {
	    $kextarg = $ARGV[0];
	} elsif (-d "$sledir/$ARGV[0]") {
	    $kextarg = $sledir ."/". $ARGV[0];
	} else {
	    pod2usage(-msg => "Invalid argument:  $ARGV[0]");
	}
	if ($verbose) {
	    printf "Using KEXT %s\n", $kextarg;
	}
	# Supplied kext overrides defaults
	$allkext = 0;
    }

    if ($allkext) {
	@kexts = <$sledir/{ATI,AMD}*Controller.kext/Contents/MacOS/*Controller>;
    } elsif ($kextarg) {
	@kexts = <$kextarg/Contents/MacOS/*Controller>;
    } else {
	push(@kexts, $oldstylekext);
    }

    chomp($have_otool=`which otool`);
    if ($have_otool eq "") {
	printf "This script requires otool to be installed in the standard location.
otool is part of the package 'Command Line Tools' for Xcode, available
at https://developer.apple.com/downloads/index.action\n";
	exit(1);
    }
    $otool_base_cmd = "otool -Q -arch " . $arch;
    for ($index = 0; $index <= $#kexts; $index++) {
	my($kextbin) = $kexts[$index];
	printf "Kext %s\n", $kextbin;
	$dump= $otool_base_cmd . " -vt " . $kextbin . " | c++filt";
	$dumpl = $otool_base_cmd . " -l " . $kextbin;
	#See if kext is fat or not
	$isfat = system("lipo -info " . $kextbin . "|grep Non > /dev/null");
	if ($isfat) {
	    $lipo = "lipo -detailed_info " . $kextbin;
	    $arch_offset = parse_fat($lipo);
	}
	parse_seg($dumpl);
	if ($verbose > 1) {
	    printf "Architecture offset: %d vmaddr: %d file offset: %d\n",
	    $arch_offset, $vmaddr, $fileoff;
	}
	$ddcmd = "dd if=" . $kextbin . " of=" . $tmpfile . " bs=1 skip=";
	parse_instr($dump);
    }
}

main();
exit(0);

=head1 NAME

ati-personality.pl -- Parse ATI personality definitions from KEXTs

=head1 SYNOPSIS

ati-personality.pl  [OPTIONS] [KEXT]

KEXT is the optional name of a kernel extension to search instead of the
standard set.

Description:

This script will parse the ATI/AMD personality initialization routines and
calculate the effective address of the ConnectorInfo table, as well as the
number of table entries.  The script currently defaults to outputing
information for all personalities found in the ATI/AMD kexts in the 
system standard kext directory.  In OSX 10.6, these personalities are all
found in the ATIFramebuffer kext.  As of OSX 10.7, the connectorinfo has been
separated out across several ATI controller kexts, instead of ATIFramebuffer.
The script detects the set of kexts to search automatically for 10.6 thru
10.8 (except for the case covered by the -a switch).

Options:

  -h		    Print this usage information
  -s=[SLE]          Look for KEXTs in directory SLE.  Default: /System/Library/Extensions
  -i386             Architecture i386 (only applicable thru osx 10.7)
  -v                Verbose output (only useful for developers)
  -a                Specify if you use OS X 10.6 2011 MacBook Pro KEXTs
                    [DEPRECATED]

Examples:

=over 8

=item B<ati-personality.pl -386>

  to output 32-bit kext information

=item B<ati-personality.pl>

  to output 64-bit kext information (the default)

=item B<ati-personality.pl ATI6000Controller.kext>

  to output personality information for just the specified controller

=item B<ati-personality.pl "/Volumes/OSX/System/Library/Extensions/ATI6000Controller.kext">

same as above except uses the provided path instead of /System/Library/Extensions

=item B<ati-personality.pl -s /Volumes/10.7/System/Library/Extensions>

outputs all personality information for the ATI kexts found at an alternate mount point.
=cut
