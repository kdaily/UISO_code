# Rerun GSEA on differentially expressed genes detected with limma

# Path to your GSEA jar file
gsea_jar=/var/preserve/src/gsea2-2.0.13.jar

# Output directory
outputdir=./data/GSEA/

# Standard CHIP file for all comparisons
# Built from the variance filtered list of probesets/genes
chipfile=./data/GSEA/tumor_classic_variant_filter.chip

label=tumor_vs_uiso_filter
rankfile=./data/GSEA/${label}.rnk
java -cp ${gsea_jar} xtools.gsea.GseaPreranked -gmx gseaftp.broadinstitute.org://pub/gsea/gene_sets/c2.cp.kegg.v3.1.symbols.gmt -collapse true -mode Max_probe -norm meandiv -nperm 1000 -rnk ${rankfile} -scoring_scheme weighted -rpt_label ${label} -chip ${chipfile} -include_only_symbols true -make_sets true -plot_top_x 50 -rnd_seed 1 -set_max 500 -set_min 15 -zip_report false -out ${outputdir} -gui false

label=tumor_vs_classic_filter
rankfile=./data/GSEA/${label}.rnk
java -cp ${gsea_jar} xtools.gsea.GseaPreranked -gmx gseaftp.broadinstitute.org://pub/gsea/gene_sets/c2.cp.kegg.v3.1.symbols.gmt -collapse true -mode Max_probe -norm meandiv -nperm 1000 -rnk ${rankfile} -scoring_scheme weighted -rpt_label ${label} -chip ${chipfile} -include_only_symbols true -make_sets true -plot_top_x 50 -rnd_seed 1 -set_max 500 -set_min 15 -zip_report false -out ${outputdir} -gui false

label=tumor_vs_variant_filter
rankfile=./data/GSEA/${label}.rnk
java -cp ${gsea_jar} xtools.gsea.GseaPreranked -gmx gseaftp.broadinstitute.org://pub/gsea/gene_sets/c2.cp.kegg.v3.1.symbols.gmt -collapse true -mode Max_probe -norm meandiv -nperm 1000 -rnk ${rankfile} -scoring_scheme weighted -rpt_label ${label} -chip ${chipfile} -include_only_symbols true -make_sets true -plot_top_x 50 -rnd_seed 1 -set_max 500 -set_min 15 -zip_report false -out ${outputdir} -gui false
