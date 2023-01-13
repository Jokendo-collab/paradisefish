#!/usr/bin/perl -I$HOME/my_program3/perl_pm
use strict;
use warnings;
use Data::Dumper;
use Cwd qw(abs_path getcwd);
use File::Basename qw(basename dirname fileparse);
use czl_io::base_io;
use czl_io::fasta;
use czl_io::gff qw(load_gffs load_gene_annot2 stat);

sub usage()
{
print<<EOF;
Usage:
  $0 MODULE <-i GFF3 FILE> <-o OUT_PREFIX>
==============================
Modules:
 stat
 add_attr          : add/replace attributes for gene/rna/exon
 annot
 remap_info_name
 generate_id
 longest_transcript: keep only longest transcript for each gene
 all_orf           : get all ORF de novo for each transcript
 longest_orf       : get longest ORF de novo for each transcript
 seq               : fetch sequence
 convert           : convert to other format
 sort              : sort by group gene/mRNA together
 to_gene_order     : transform to order of genes
 validate          : validate genome and genes

==============================
Options:
 Common:
  -if FORMAT  : gtf or [gff3]
  -of FORMAT  : output format [gff3|gtf|bgpe]
  -cseq STR   : charactor for collapsing names
  -species STR: species
  -g FILE.fa  : genome fasta file
	-gff-grouped: if gff is grouped by genes and transcripts

 add_attr
  -gattrf File : three columns file (ID, attr_name, attr_value) for gene
  -tattrf File : three columns file (ID, attr_name, attr_value) for transcript or RNA
  -eattrf File : three columns file (ID, attr_name, attr_value) for exon

 remap_info_name:
  -gattr OLD=>NEW : map gene info attribute name from OLD to NEW
  -tattr OLD=>NEW : map transcript info attribute name from OLD to NEW
  -eattr OLD=>NEW : map exon info attribute name from OLD to NEW

 annot:
  -gattr OLD=>NEW : map gene info attribute name from OLD to NEW
  -tattr OLD=>NEW : map transcript info attribute name from OLD to NEW
  -attr-ovl-frac STR  : atribution name for max overlap fraction for transcript
  -attr-ovl STR       : atribution name for max overlap length for transcript
  -attr-length STR    : atribution name for max overlapped target length for transcript
  -attr-target STR    : atribution name for max overlapped target for transcript
 all_orf:
  -min-len N : minimal ORF nuc size [0]
  -max-len N : maximal ORF nuc size [unlimited]


==============================
Output:
 annot:
  OUT_PREFIX
 remap_info_name:
  OUT_PREFIX
 generate_id
  {OUT_PREFIX}gff
  {OUT_PREFIX}new_to_old_gid
  {OUT_PREFIX}new_to_old_tid
EOF
}

if ($#ARGV<0) { usage(); exit 0; }

my $prog = shift @ARGV;
my $in_gff_file;
my $in_gff_file2;
my $gff_grouped=1;
my $genome_fa;
my $out_prefix;
my $attr_ovl_frac;
my $attr_ovl;
my $attr_length;
my $attr_target;
my $codon_type = 'general';

my $gff_ver=3;
my $ifmt;
my $ofmt;
my %attrs;
my $collapse_sep;
my %gene_attrs;
my %tran_attrs;
my %exon_attrs;
my %gene_attrs1;
my %tran_attrs1;
my %exon_attrs1;
my $is_input_sort_by_chr = 0;
my $gid_prefix="";
my $tid_prefix="";
my $min_len=0;
my $max_len=undef;
my $sp;

my $file;

for (my $k=0; $k<=$#ARGV; $k++) {
	my $name = $ARGV[$k];
	$name=~s/^-//;
	$name=~s/^-//;
	if ($ARGV[$k] =~ m/^(-i)$/) {
		$in_gff_file = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-i2)$/) {
		$in_gff_file2= $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-o)$/) {
		$out_prefix = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-g)$/) {
		$genome_fa = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^-(species|sp)$/) {
		$sp = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-codon-table)$/) {
		$codon_type = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-gff-grouped)$/) {
		$gff_grouped = $ARGV[++$k];;
	} elsif ($ARGV[$k] =~ m/^(-attr)$/) {
		$k++;
		foreach my $aa ( split /\s*[,:;]+\s*/, $ARGV[$k]) {
			my ($u,$v) = split /=>/, $aa;
			if (defined $v) { $attrs{$u} = $v; }
			else { $attrs{$u} = $u; }
		}
	} elsif ($ARGV[$k] =~ m/^(-gattr|--gene-attr)$/) {
		$k++;
		foreach my $aa ( split /\s*[,:;]+\s*/, $ARGV[$k]) {
			my ($u,$v) = split /=>/, $aa;
			if (defined $v) { $gene_attrs{$u} = $v; }
			else { $gene_attrs{$u} = $u; }
		}
	} elsif ($ARGV[$k] =~ m/^(-tattr|--tran-attr)$/) {
		$k++;
		foreach my $aa ( split /\s*[,:;]+\s*/, $ARGV[$k]) {
			my ($u,$v) = split /=>/, $aa;
			if (defined $v) { $tran_attrs{$u} = $v; }
			else { $tran_attrs{$u} = $u; }
		}
	} elsif ($ARGV[$k] =~ m/^(-eattr|--exon-attr)$/) {
		$k++;
		foreach my $aa ( split /\s*[,:;]+\s*/, $ARGV[$k]) {
			my ($u,$v) = split /=>/, $aa;
			if (defined $v) { $exon_attrs{$u} = $v; }
			else { $exon_attrs{$u} = $u; }
		}
	} elsif ($ARGV[$k] =~ m/^(-gattrf|--gene-attr-file)$/) {
		my $fin=base_io::czl_open($ARGV[++$k],'r');
		while (<$fin>) {
			s/\s+$//;
			my @t = split /\t/;
			$gene_attrs1{$t[0]} = [$t[1],$t[2]];
		}
		close $fin;
	} elsif ($ARGV[$k] =~ m/^(-tattrf|--tran-attr-file)$/) {
		my $fin=base_io::czl_open($ARGV[++$k],'r');
		while (<$fin>) {
			s/\s+$//;
			my @t = split /\t/;
			$tran_attrs1{$t[0]} = [$t[1],$t[2]];
		}
		close $fin;
	} elsif ($ARGV[$k] =~ m/^(-eattrf|--exon-attr-file)$/) {
		my $fin=base_io::czl_open($ARGV[++$k], 'r');
		while (<$fin>) {
			s/\s+$//;
			my @t = split /\t/;
			$exon_attrs1{$t[0]} = [$t[1],$t[2]];
		}
		close $fin;
	} elsif ($ARGV[$k] =~ m/^(\-|)-attr-ovl-frac$/) {
		$attr_ovl_frac = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(\-|)-attr-ovl$/) {
		$attr_ovl = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(\-|)-attr-length$/) {
		$attr_length = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(\-|)-attr-target$/) {
		$attr_target = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-if)$/) {
		++$k;
		$ifmt = $ARGV[$k];
		if ($ARGV[$k] eq "gtf") { $gff_ver = 2; }
		elsif ($ARGV[$k] eq "gff3") { $gff_ver = 3; }
		elsif ($ARGV[$k] eq "biggenepred" || $ARGV[$k] eq "bgp") { $gff_ver = 0; $ifmt="bgp";}
		else { die "GFF format can NOT be $ARGV[$k]\n"; }
	} elsif ($ARGV[$k] =~ m/^(-of)$/) {
		$ofmt = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-csep|--collapse-sep)$/) {
		$collapse_sep = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-ist|--input-sort-by-chr)$/) {
		$is_input_sort_by_chr = 1;
	} elsif ($ARGV[$k] =~ m/^(-gp|--gene-id-prefix)$/) {
		$gid_prefix = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-tp|--transcript-id-prefix)$/) {
		$tid_prefix = $ARGV[++$k];
	} elsif ($name =~ m/^min[-_]len$/) {
		$min_len = $ARGV[++$k];
	} elsif ($name =~ m/^max[-_]len$/) {
		$max_len = $ARGV[++$k];
	} elsif ($ARGV[$k] =~ m/^(-h|--help|-help)$/) {
		usage();
		exit 0;
	} else {
		die "No option '$ARGV[$k]'\n";
	}
}

if (%attrs) {
    if (!%gene_attrs) { %gene_attrs = %attrs; }
    if (!%tran_attrs) { %tran_attrs = %attrs; }
}

my $seq;
if ($genome_fa) {
    $seq = fasta::load_all_seq_hash_ref($genome_fa, -1);
}
my $codon_table = gff::load_codon_table2($codon_type);

if (!$ifmt) { $ifmt=gff::detect_gene_format_from_filename($in_gff_file); }
if (!$ifmt) { die "Fail to detect gene annotation format.\n"; }

my $annot;
if ($prog eq "stat") {
    if ($gff_ver!=0) { $annot = gff::load_gff2($in_gff_file, $gff_ver); }
    elsif (defined $ifmt) { $annot = gff::load_gene_annot2($in_gff_file, $ifmt); }
    else { exit 1; }
    gff::stat($annot, $seq, $out_prefix);
} elsif ($prog eq "annot") {
    gff::gff_annot_name_using_gff($in_gff_file, $in_gff_file2, $out_prefix, \%gene_attrs, \%tran_attrs, $is_input_sort_by_chr, $seq, {full_frac=>0.8, attr_ovl_frac=>$attr_ovl_frac, attr_ovl=>$attr_ovl, attr_length=>$attr_length, attr_target=>$attr_target});
} elsif ($prog eq "add_attr") {
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table, undef, $gff_grouped);
    if (!defined $annot) { exit 255; }
    if (%gene_attrs1) {
        foreach my $id (keys(%gene_attrs1)) {
            if (!exists $annot->{gene}{$id}) {next;}
            my $g = $annot->{gene}{$id};
            my ($u, $v) = @{$gene_attrs1{$id}};
            if ($u eq 'Name') {
							$g->{symbol} = $v;
							delete $g->{info}{Name};
						}
            else { $g->{info}{$u} = $v; }
        }
    } 
    if (%tran_attrs1) {
        foreach my $id (keys(%tran_attrs1)) {
            if (!exists $annot->{rna}{$id}) {next;}
            my $g = $annot->{rna}{$id};
            my ($u, $v) = @{$tran_attrs1{$id}};
            if ($u eq 'Name') {
							$g->{symbol} = $v;
							delete $g->{info}{Name};
						} else { $g->{info}{$u} = $v; }
        }
    } 
    if (%exon_attrs1) {
        foreach my $id (keys(%exon_attrs1)) {
            if (!exists $annot->{exon}{$id}) {next;}
            my $g = $annot->{exon}{$id};
            my ($u, $v) = @{$exon_attrs1{$id}};
            if ($u eq 'Name') {
							$g->{symbol} = $v;
							delete $g->{info}{Name};
						}
            else { $g->{info}{$u} = $v; }
        }
    } 
    gff::store_gene_annot2($annot, $out_prefix, $ofmt);
} elsif ($prog eq "remap_info_name") {
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt);
    $file = $out_prefix;
	gff::gff_remap_info_names2($annot, \%gene_attrs, \%tran_attrs, \%exon_attrs, $collapse_sep);
    gff::store_gene_annot2($annot, $out_prefix, $ofmt);
} elsif ($prog eq "generate_id") {
    gff::gff_generate_id($in_gff_file, $out_prefix.'gff', $out_prefix.'new_to_old_gid', $out_prefix.'new_to_old_tid', $gid_prefix, $tid_prefix, 8, 1, 1);
} elsif ($prog eq "longest_transcript") {
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table);
    if (!defined $annot) { exit 255; }
    foreach my $g ( sort {$a->{seqid} cmp $b->{seqid} or $a->{begin}<=>$b->{begin} } values(%{$annot->{gene}}) ) {
        my $gid = $g->{id};
        if (@{$g->{transcripts}}==0) {
            gff::delete_gene($annot,$gid);
            next;
        }
        if (@{$g->{transcripts}}<2) { next; }
        my $t0 = $g->{longest_transcript};
        my $c0 = $g->{longest_cds};
		if (defined $c0) { $t0=$c0; }
        my @tids;
        foreach my $t (@{$g->{transcripts}}) {
            if ($t->{id} ne $t0->{id}) { push @tids, $t->{id}; }
        }
        foreach my $tid (@tids) {
            gff::delete_transcript($annot,$tid);
        }
    }
    gff::store_gene_annot2($annot, $out_prefix, $ofmt);
} elsif ($prog eq "seq") {
    if (defined $ifmt) { $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table); }
    gff::transcript_seq_by_type($annot, $seq, $out_prefix, 'T,E,C1,Cn,P,UTR,UU2000,DD2000', $sp, $codon_table);
} elsif ($prog eq "convert") {
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table, undef, $gff_grouped);
    gff::store_gene_annot2($annot, $out_prefix, $ofmt);
} elsif ($prog eq "validate") {
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table);
	my ($ret,$msg) = gff::validate_gene_annot2($annot, $seq);
	if ($ret==0) { print "Good\n"; }
	else { print join("\n", @$msg), "\n"; }
} elsif ($prog eq "sort") {
    if ($ifmt=~m/^(gff|gff3)$/i) {
        my $fin = base_io::czl_open($in_gff_file, 'r');
        my %gene;
        my %rna;
        my %exon;
        my %cds;
        my $n=0;
        my @gids;
        while (<$fin>) {
            ++$n;
            if (m/^#/) { next; }
            s/\s+$//;
            my @t=split /\t/;
            if (@t<9) { warn "Line $n do not have 9 fields.\n"; ;next; }
            my $feat=$t[2];
            my $info = gff::czl_parse_gff_attr($t[8], 3);
            my $id=$info->{ID};
            my $parent=$info->{Parent};
            if ($feat eq 'gene') {
                $gene{$id}{line} = $_;
                push @gids, $id;
            } elsif ($feat eq 'mRNA' || $feat=~m/^transcript$/) {
                $rna{$id}{line} = $_;
                $rna{$id}{parent} = $parent;
                if (defined $parent) { push @{$gene{$parent}{rna}}, $id; }
            } elsif ($feat eq 'exon') {
                if (!defined $id) {
                    $id = "${parent}_E$t[3]";
                    $t[8]="ID=$id;$t[8]";
                }
                $exon{$id}{line} = join "\t", @t;
                $exon{$id}{parent} = $parent;
                $exon{$id}{begin} = $t[3]-1;
                $exon{$id}{end} = $t[4];
                push @{$rna{$parent}{exon}}, $id;
            } elsif ($feat=~m/^CDS$/i) {
                if (!defined $id) {
                    $id = "${parent}_C$t[3]";
                    $t[8]="ID=$id;$t[8]";
                }
                $cds{$id}{line} .= join "\t", @t;
                $cds{$id}{parent} = $parent;
                $cds{$id}{begin} = $t[3]-1;
                $cds{$id}{end} = $t[4];
                push @{$rna{$parent}{cds}}, $id;
            }
        }
        close $fin;
        foreach my $tid (keys(%rna)) {
            if (!defined $rna{$tid}{parent}) {
                my $gid=$tid;
                my @t=split /\t/, $rna{$tid}{line};
                $t[2]='gene';
                $gene{$gid}{line} = join "\t", @t;
                push @{$gene{$gid}{rna}}, $tid;
                $rna{$tid}{parent} = $gid;
                $rna{$tid}{line} .= "Parent=$gid;";
                push @gids, $gid;
            } else {
                my $gid = $rna{$tid}{parent};
                if (!exists $gene{$gid}) {
                    my @t=split /\t/, $rna{$tid}{line};
                    $t[2]='gene';
                    $gene{$gid}{line} = join "\t", @t;
                    push @{$gene{$gid}{rna}}, $tid;
                    $rna{$tid}{parent} = $gid;
                    $rna{$tid}{line} .= "Parent=$gid;";
                    push @gids, $gid;
                }
            }
        }
        foreach my $gid (@gids) {
            foreach my $tid (@{$gene{$gid}{rna}}) {
                my $t = $rna{$tid};
                if (exists $t->{cds}) {
                    if (!exists $t->{exon}) {
                        foreach my $id (@{$t->{cds}}) {
                            my @t1=split /\t/, $cds{$id}{line};
                            $t1[2]='exon';
                            %{$exon{$id}} = %{$cds{$id}};
                            $exon{$id}{line} = join "\t", @t1;
                            $exon{$id}{cds} = $id;
                            push @{$t->{exon}}, $id;
                        }
                    } else {
                        @{$t->{exon}} = sort {$exon{$a}{begin}<=>$exon{$b}{begin}} @{$t->{exon}};
                        @{$t->{cds}} = sort {$cds{$a}{begin}<=>$cds{$b}{begin}} @{$t->{cds}};
                        my $ei=0;
                        my $ci=0;
                        my @eids=@{$t->{exon}};
                        my @cids=@{$t->{cds}};
                        while ($ei<@eids && $ci<@cids) {
                            my $eid = $t->{exon}[$ei];
                            my $cid = $t->{cds}[$ci];
                            if ($cds{$cid}{begin}>=$exon{$eid}{begin}
                                && $cds{$cid}{end}<=$exon{$eid}{end}) {
                                $exon{$eid}{cds}=$cid;
                                $ei++;
                                $ci++;
                            } elsif ($cds{$cid}{begin}>=$exon{$eid}{end}) {
                                $ei++;
                            } elsif ($cds{$cid}{end}<=$exon{$eid}{begin}) {
                                my @t1=split /\t/, $cds{$cid}{line};
                                $t1[2]='exon';
                                %{$exon{$cid}} = %{$cds{$cid}};
                                $exon{$cid}{line} = join "\t", @t1;
                                $exon{$cid}{cds} = $cid;
                                push @{$t->{exon}}, $cid;
                                $ci++;
                            }
                        }
                    }
                }
            }
        }
        my $fout = base_io::czl_open($out_prefix, 'w');
        foreach my $gid (@gids) {
            print $fout $gene{$gid}{line}, "\n";
            foreach my $tid (@{$gene{$gid}{rna}}) {
                print $fout $rna{$tid}{line}, "\n";
                foreach my $eid (@{$rna{$tid}{exon}}) {
                    print $fout $exon{$eid}{line}, "\n";
                    my $cid = $exon{$eid}{cds};
                    print $fout $cds{$cid}{line}, "\n";
                }
            }
        }
        close $fout;
    }
} elsif ($prog eq "to_order") { # convert genes to orders
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table);
    if (!defined $annot) { exit 255; }
    my $gene=$annot->{gene};
    my @gids = sort {$gene->{$a}{seqid} cmp $gene->{$a}{seqid} or $gene->{$a}{begin}<=>$gene->{$b}{begin}} keys(%$gene);
	my $seqid;
	my @ord1;
	my @ord2;
	my $fout1=base_io::czl_open($out_prefix.'ord.id', 'w') or die "Fail to create file ${out_prefix}ord.id}";
	my $fout2=base_io::czl_open($out_prefix.'ord.name', 'w') or die "Fail to create file ${out_prefix}ord.name}";
	foreach my $gid (@gids) {
		my $g = $gene->{$gid};
		if (!defined $seqid || $g->{seqid} ne $seqid) {
			if (@ord1) { print $fout1 ">$seqid\n", join(' ', @ord1), "\n"; }
			if (@ord2) { print $fout2 ">$seqid\n", join(' ', @ord2), "\n"; }
			@ord1=();
			@ord2=();
			$seqid=$g->{seqid};
		}
		if (!exists $g->{symbol}) { warn "Gene $g->{id} NOT have symbol.\n"; }
		if ($g->{strand} ne '-') { push @ord1, $g->{id}; push @ord2, $g->{symbol};}
		else { push @ord1, '-'.$g->{id}; push @ord2, '-'.$g->{symbol};}
	}
	if (@ord1) { print $fout1 ">$seqid\n", join(' ', @ord1), "\n"; }
	if (@ord2) { print $fout2 ">$seqid\n", join(' ', @ord2), "\n"; }
	close $fout1;
	close $fout2;
} elsif ($prog eq "all_orf") { # get all de-novo ORF
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table);
    if (!defined $annot) { exit 255; }
	foreach my $t (values(%{$annot->{rna}})) {
		my $orfs = gff::transcript_all_orf($t, $seq->{$t->{id}}, $codon_table, $min_len, $max_len);
		my $j=0;
		foreach my $orf (reverse sort {$a->[2]<=>$b->[2]} @$orfs) {
			my $t1 = gff::transcript_clone($t);
			my ($s, $tbeg, $tlen, $tseq1) = @$orf;
			++$j;
			if ($j>=1000) { last; }
			$t1->{id} .= '_p' . sprintf("%3i",$j);
			gff::transcript_set_cds_from_tpos_noseq($t1, $tbeg, $tbeg+$tlen, $s);
			gff::transcript_set_start_stop_codon_and_utr($t1);
			gff::transcript_validate_start_codon($t1, $seq->{$t->{seqid}});
			gff::transcript_validate_stop_codon($t1, $seq->{$t->{seqid}});
			gff::transcript_set_exon_phase($t1);
			gff::transcript_set_cds_status($t1);
			gff::gene_append_transcript($annot, $t->{parent}, $t1);
		}
	}
    gff::store_gene_annot2($annot, $out_prefix, $ofmt);
} elsif ($prog eq "longest_orf") { # get longest de-novo ORF
    $annot = gff::load_gene_annot2($in_gff_file, $ifmt, $seq, $codon_table);
    if (!defined $annot) { exit 255; }
	set_longest_orf_fixstrand($annot, $seq, $codon_table);
    gff::store_gene_annot2($annot, $out_prefix, $ofmt);
}
