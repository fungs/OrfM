OrfM
====

A simple and not slow open reading frame (ORF) caller. No bells or whistles like frameshift detection, just a straightforward goal 
of returning a FASTA file of open reading frames over a certain length from a FASTA/Q file of nucleotide sequences. 

Install
----
```sh
make
```

Running
----
To find all reading frames greater than 96 nucleotides in length:
```sh
orfm <seq_file> >orfs.fa
```
The `<seq_file>` can be a FASTA or FASTQ file, gzipped or uncompressed. The default is 96
because this is the correct number for 100bp so that each of the 6 frames can be translated.
Using 99 would mean that the third frame forward (and the corresponding reverse frame) cannot 
possibly returned as an ORF because this would entail it encapsulating bases 2-101, and 101>100.

Not too slow
-----
It runs in reasonable time compared to e.g. `translate` from the `biosequid` package, `getorf` from the `emboss` toolkit, and `prodigal` a more nuanced gene caller. For a 300MB compressed fastq file:
```
orfm -m 33 the.fq.gz >orfs.fa
  #=> 42 seconds

translate -l 33 110811_E_1_D_nesoni_single.fa >110811_E_1_D_nesoni_single.biosquid.m33.fa
  #=> 43 seconds
  
pigz -cd the.fq.gz |fq2fa |getorf -sequence /dev/stdin -minsize 33 -outseq >orfs.fa
  #=> 3 min 17 sec

pigz -cd 110811_E_1_D_nesoni_single.fq.gz |fq2fa |prodigal -q -p meta -i /dev/stdin -a 110811_E_1_D_nesoni_single.prodigal.faa -o /dev/null
  #=> 16 min 6 sec
```
While `translate` is as fast as OrfM, it does not appear to be able to handle fastq files even on `stdin`, and does not output a standard FASTA format file.

Contributing to OrfM
----
Patches most welcome. There is a few tests, which can be tested after installing `ruby`, as well as the `rspec` and `bio-commandeer` rubygems.
```sh
make test
```

Credits
----
Compiled into the code is `kseq.h` from [seqtk](https://github.com/lh3/seqtk) and an 
implementation of the [Alo-Corasick algorithm](https://en.wikipedia.org/wiki/Aho%E2%80%93Corasick_string_matching_algorithm)
from [strmat](http://web.cs.ucdavis.edu/~gusfield/strmat.html) modified [slightly](https://github.com/aurelian/ruby-ahocorasick).
Both are MIT licenced. A few GNU `libc` libraries are used too.

Software by Ben J. Woodcroft, currently unpublished. Released under LGPL - see the LICENSE.txt for licensing details.
