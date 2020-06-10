#!/usr/env/bin/perl
# 安装NeoPredPipe包
# 这个包里边包含的内容比较多。首先我将程序包放在阿里云上，当需要安装当时候，直接从阿里云上把压缩包拉下来
# 然后修改压缩包当中的两个关键配置文件。

use strict;
use warnings;
use Getopt::Long;

our $url='https://jijiantuchuang-markdown.oss-cn-shenzhen.aliyuncs.com/20-3-7/NeoPredPipe.plus.tar.gz';
our $path=();
our $typeII=();
our $help;

GetOptions(
 'i|install=s' => \$path,
 'type2' => \$typeII,
 'h|help' => \$help);

my %usage=();
$usage{'null'} = <<_NULL_;
tip: biopython == 1.70 should be installed before running this script!
     if tcsh is not available, it can be installed following instruction!

usage: $0 -install PATH/To/Install [-type2]
    -i|install      NeoPredPipe installation path
    -type2          Using netMHCIIpan instead of netMHCpan for typeII neoantigen calling 
    -h|help         Show this message
  link of installation packages:
    $url
_NULL_

unless($path){
    print $usage{'null'} ;
    exit();
}
if($help){
    print $usage{'null'} ;
    exit();
}

unless(`which tcsh`){
    # 首先提示安装tcsh，否则程序无法正常运行
    print "Please install tcsh first!\n";
    print "sudo apt-get install tcsh\n";
    print "or in centOS:\n";
    print "sudo yum install tcsh\n";
    exit();
}

$path=~s/NeoPredPipe$//;

unless(-e $path){system "mkdir -p $path";}

chdir($path);

system("wget -c $url");
system('tar zxf NeoPredPipe.plus.tar.gz');
unlink('NeoPredPipe.plus.tar.gz');

# 配置文件1: NeoPredPipe的主配置文件
open O,">./NeoPredPipe/usr_paths.ini";
print O "[annovar]\n";
print O "convert2annovar = $path/NeoPredPipe/Tool/annovar/convert2annovar.pl\n";
print O "annotatevariation = $path/NeoPredPipe/Tool/annovar/annotate_variation.pl\n";
print O "coding_change = $path/NeoPredPipe/Tool/annovar/coding_change.pl\n";
print O "gene_table = $path/NeoPredPipe/Tool/annovar/humandb/hg19_refGene.txt\n";
print O "gene_fasta = $path/NeoPredPipe/Tool/annovar/humandb/hg19_refGeneMrna.fa\n";
print O "humandb = $path/NeoPredPipe/Tool/annovar/humandb\n";
print O "[netMHCpan]\n";
if($typeII){
    print O "netMHCpan = $path/NeoPredPipe/Tool/netMHCIIpan-3.2/netMHCIIpan\n";
}else{
    print O "netMHCpan = $path/NeoPredPipe/Tool/netMHCpan-4.0/netMHCpan\n";
}

print O "[PeptideMatch]\n";
print O "peptidematch_jar = $path/NeoPredPipe/Tool/PeptideMatchCMD_1.0.jar\n";
print O "reference_index = $path/NeoPredPipe/Tool/hg38.pep.fa.fai\n";
print O "[blast]\n";
print O "blastp =$path/NeoPredPipe/Tool/blastp\n";
close O;

# 配置文件2: netMHCpan的主文件
my $out=();
open I,"<./NeoPredPipe/Tool/netMHCpan-4.0/netMHCpan";
while(<I>){
    if(m/setenv\tNMHOME\t/){
        $_="setenv\tNMHOME\t$path/NeoPredPipe/Tool/netMHCpan-4.0\n";
    }
    $out.=$_;
}
close I;

open O,">./NeoPredPipe/Tool/netMHCpan-4.0/netMHCpan";
print O $out;
close O;

# 配置文件3: netMHCIIpan的主文件
$out=();
open I,"<./NeoPredPipe/Tool/netMHCIIpan-3.2/netMHCIIpan";
while(<I>){
    if(m/setenv\tNMHOME\t/){
        $_="setenv\tNMHOME\t$path/NeoPredPipe/Tool/netMHCIIpan-3.2\n";
    }
    $out.=$_;
}
close I;

open O,">./NeoPredPipe/Tool/netMHCIIpan-3.2/netMHCIIpan";
print O $out;
close O;
