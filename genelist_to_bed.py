import sys
import pyensembl

def gene_to_interval(gene, release=75):
    data = pyensembl.EnsemblRelease(release)
    ret = None
    try:
        ret = data.genes_by_name(gene)[0]
    except:
        sys.stderr.write(" ".join(["Gene not found: ", gene, "\n"]))
    if ret is not None:
        return (str(ret.contig), str(ret.start), str(ret.end), str(ret.name))
    else:
        return ret


def genes_to_intervals(gene_list):
    gti = gene_to_interval
    ret = []
    for i in gene_list:
        r = gti(i)
        if r is not None:
            ret.append(r)
    return ret


if __name__ == "__main__":
    
    g_list = []
    gen_l = []
    with open(sys.argv[1], "r") as ifi:
        for line in ifi:
            tokens = line.strip().split()
            g = tokens[0]
            g_list.append(g)
    r = genes_to_intervals(g_list)
    for i in r:
        print "\t".join(i)
