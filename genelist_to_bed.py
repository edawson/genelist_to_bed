import sys
import pyensembl

if __name__ == "__main__":
    data = pyensembl.EnsemblRelease(75)
    
    g_list = []
    gen_l = []
    with open(sys.argv[1], "r") as ifi:
        for line in ifi:
            tokens = line.strip().split()
            g = tokens[0]
            g_list.append(g)
    for i in g_list:
        try:
            gen_l.append(data.genes_by_name(i)[0])
        except:
            sys.stderr.write(" ".join(["Gene not found: ", i, "\n"])) 
    for i in gen_l:
        print "\t".join([str(i.contig), str(i.start), str(i.end), str(i.name)])
