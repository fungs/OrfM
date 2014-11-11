require 'rspec'
require 'bio-commandeer'

orfm = File.expand_path(File.dirname(__FILE__) + '/../orfm')

describe "orfm" do
  it "should run with defaults on a single file" do
    input = %w(>638202197:1-99 ATGGATGCTGAAAAAAGATTGTTCTTAAAGGCATTAAAGGAAAAGTTTGAAGAAGACCCAAGAGAAAAATACACTAAGTTCTATGTCTTTGGCGGATGG).join("\n")
    expected = %w(>638202197:1-99_1_1_1 MDAEKRLFLKALKEKFEEDPREKYTKFYVFGGW).join("\n")+"\n"
    Bio::Commandeer.run("#{orfm}", :stdin => input).should == expected
  end

  it "should work with a longer -m " do
    input = ['>638202197 NP_247840 methyl coenzyme M reductase I, subunit alpha (mcrA) [Methanocaldococcus jannaschii DSM 2661: NC_000909] (+)strand',
<<EOS
ATGGATGCTGAAAAAAGATTGTTCTTAAAGGCATTAAAGGAAAAGTTTGA
AGAAGACCCAAGAGAAAAATACACTAAGTTCTATGTCTTTGGCGGATGGA
GACAGTCAGCAAGAAAAAGAGAATTCGTTGAGGCAGCACAAAAATTAATT
GAGAAGAGAGGAGGAATTCCATTTTACAACCCAGATATTGGAGTTCCATT
GGGGCAGAGAAAATTAATGCCTTACAAAGTTTCAAATACAGATGCAATTG
TTGAAGGGGATGACTTACACTTCATGAACAACGCTGCAATGCAGCAGTTC
TGGGATGACATAAGAAGAACAGTTATCGTTGGGATGGATACAGCTCACGC
TGTTCTTGAAAAGAGATTGGGGGTAGAGGTTACTCCAGAAACAATTAATG
AATACATGGAAACTATTAACCACGCTCTCCCAGGAGGAGCAGTTGTTCAG
GAGCACATGGTTGAGGTCCACCCAGCATTAGTCTGGGACTGTTACGCTAA
GATATTCACTGGAGATGACGAATTAGCAGATGAGATTGACAAGAGGTTCT
TAATTGACATTAACAAGTTGTTCCCAGAAGAGCAGGCAGAACAAATCAAG
AAGGCAATCGGTAAGAGAACATACCAAGTTTCAAGAGTTCCAACATTAGT
CGGTAGAGTTTGTGATGGGGGAACAATAGCAAGATGGAGTGCTATGCAGA
TTGGAATGTCATTCATTACAGCTTACAAGCTCTGTGCTGGGGAGGCAGCA
ATTGCTGACTTCTCATACGCTGCAAAGCACGCTGATGTCATTCAGATGGC
TTCATTCTTGCCAGCAAGAAGAGCAAGAGGGCCAAATGAACCAGGAGGTA
TCTTCTTCGGAGTCTTGGCAGATATTGTTCAAACATCAAGAGTTTCAGAT
GACCCAGTTGAACAGTCATTAGAGGTTGTTGCTGCTGGGGCTATGTTGTA
TGACCAAATCTGGTTAGGAGGATACATGTCTGGAGGAGTCGGATTTACAC
AGTATGCTACAGCAACCTATACAGATGACATCTTGGATGACTTCTCATAC
TACGGATATGACTACATAACCAAGAAATATGGAGGATGCAACAGCGTAAA
ACCAACAATGGATGTTGTTGAAGATATTGCTACTGAAGTAACTTTATATG
GTTTAGAGCAGTATGACACCTTCCCAGCATTGTTAGAAGACCACTTCGGA
GGTTCCCAAAGAGCAGGGGTTACAGCTGCTGCAGCAGGTATTACAACTGC
ATTAGCTACAGGAAACTCAAACGCTGGAGTTAACGGATGGTATCTAAGCC
AGATATTGCACAAAGAATACCACAGCAGATTAGGATTCTATGGTTATGAC
TTACAAGACCAGTGTGGAGCAGCCAACTCATTATCATTCAGAAACGATGA
AGGTTCCCCATTAGAATTGAGAGGGCCTAACTATCCAAACTACGCAATGA
ACGTTGGTCACCAAGGAGAATATGCTGGAATTACACAGGCTGCACACTCA
GCAAGAGGAGACGCATTTGCATTGAACCCATTAATTAAGGTTGCATTTGC
AGACCCATCATTAGTCTTTGACTTCACACATCCAAGAAAAGAGTTTGCAA
GAGGTGCTTTAAGAGAATTCGAGCCAGCTGGAGAAAGAGATCCAATCATC
CCAGCTCACTAA
EOS
      ].join("\n")
    outname = '>638202197_1_1_1 NP_247840 methyl coenzyme M reductase I, subunit alpha (mcrA) [Methanocaldococcus jannaschii DSM 2661: NC_000909] (+)strand'
    outseq = <<EOS
MDAEKRLFLKALKEKFEEDPREKYTKFYVFGGWRQSARKREFVEAAQKLIEKRGGIPFYN
PDIGVPLGQRKLMPYKVSNTDAIVEGDDLHFMNNAAMQQFWDDIRRTVIVGMDTAHAVLE
KRLGVEVTPETINEYMETINHALPGGAVVQEHMVEVHPALVWDCYAKIFTGDDELADEID
KRFLIDINKLFPEEQAEQIKKAIGKRTYQVSRVPTLVGRVCDGGTIARWSAMQIGMSFIT
AYKLCAGEAAIADFSYAAKHADVIQMASFLPARRARGPNEPGGIFFGVLADIVQTSRVSD
DPVEQSLEVVAAGAMLYDQIWLGGYMSGGVGFTQYATATYTDDILDDFSYYGYDYITKKY
GGCNSVKPTMDVVEDIATEVTLYGLEQYDTFPALLEDHFGGSQRAGVTAAAAGITTALAT
GNSNAGVNGWYLSQILHKEYHSRLGFYGYDLQDQCGAANSLSFRNDEGSPLELRGPNYPN
YAMNVGHQGEYAGITQAAHSARGDAFALNPLIKVAFADPSLVFDFTHPRKEFARGALREF
EPAGERDPIIPAH
EOS
    outseq.gsub!("\n",'')

    Bio::Commandeer.run("#{orfm} -m 300", :stdin => input).should == "#{outname}\n#{outseq}\n"
  end

  it 'should toy example with internal frame 2 ORF' do
    input = %w(>eg AATGTGAA).join("\n")
    expected = %w(>eg_2_2_1 M).join("\n");
    expected = <<EOS
>eg_2_2_1
M
>eg_1_1_2
NV
>eg_3_3_3
CE
>eg_1_4_4
HI
>eg_2_5_5
SH
>eg_3_6_6
FT
EOS
    Bio::Commandeer.run("#{orfm} -m3", :stdin => input).should == expected
  end

  it 'should be able to handle n characters' do
    input = %w(>eg TTAANA).join("\n")
    expected = %w(>eg_1_1_1 LX).join("\n")+"\n";
    Bio::Commandeer.run("#{orfm} -m6", :stdin => input).should == expected
  end

  it 'should be able to handle lower case characters' do
    input = %w(>eg TTAAaA).join("\n")
    expected = %w(>eg_1_1_1 LK).join("\n")+"\n";
    Bio::Commandeer.run("#{orfm} -m6", :stdin => input).should == expected
  end
end
