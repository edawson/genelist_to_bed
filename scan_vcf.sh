## Read BED file of choice
## MAF -> bed
basedir=""
vcf=$2
sortvcf=$(basename $vcf .vcf).sorted.vcf
ref_fai=Homo_sapiens_assembly19.fasta.fai

#grep -v "Hugo" ${maf} | cut -f 1,5,6,7,16,17 -d "	" | awk '{print $2,$3,$4,$1,$5,$6}' | sed "s/ /	/g" > x.bed && exit

bedtools=bedtools2/bin/bedtools
vcflib=vcflib

## Scan within 1000bp of genes in list
## filter with vcflib

## consequence call with bcftools csq
    ## sort VCF
${bedtools} sort -faidx ${ref_fai} ${vcf} > ${sortvcf} &&
    grep "#" $sortvcf | head -n 2000 > header.$(basename $sortvcf .vcf).txt && \
        echo "Intersecting dbsnp" && \
        time ${bedtools} intersect -sorted -v -a $sortvcf -b ~/dbsnp_134_b37.leftAligned.vcf > $(basename $sortvcf .vcf).db.vcf && \
        echo "Intersecting repeatmasker" && \
        cat header.$(basename $sortvcf .vcf).txt $(basename $sortvcf .vcf).db.vcf > tmp.$sortvcf && mv tmp.$sortvcf $(basename $sortvcf .vcf).db.vcf && \
        ${bedtools} intersect -sorted -v -a $(basename $sortvcf .vcf).db.vcf -b repeatmasker.bed > $(basename $sortvcf .vcf).db.rpt.vcf && \
        echo "Reheadering" && \
        cat header.$(basename $sortvcf .vcf).txt $(basename $sortvcf .vcf).db.rpt.vcf > tmp.$sortvcf && mv tmp.$sortvcf $(basename $sortvcf .vcf).db.rpt.vcf && \
        rm $(basename $sortvcf .vcf).db.vcf && \
        echo "Filtering for quality" && \
        ${vcflib}/bin/vcffilter -s -f "QUAL > 20 & QUAL / AO > 10 & SAF > 0 & SAR > 0 & RPR > 1 & RPL > 1" -g "DP > 30 " $(basename $sortvcf .vcf).db.rpt.vcf > $(basename $sortvcf .vcf).db.rpt.vcfilt.vcf && rm $(basename $sortvcf .vcf).db.rpt.vcf && \
        echo "Processed $vcf"

