#!/usr/bin/env Rscript

#===========================================================
# R script for plotting the distance vs contact count
# for significant interactions

# Author: Sourya Bhattacharyya
# Vijay-Ay lab, LJI
#===========================================================

library(optparse)

#================================================
option_list = list(
  	make_option(c("--IntFile"), type="character", default=NULL, help="FitHiChIP significant interaction file."),
  	make_option(c("--OutFile"), type="character", default=NULL, help="Output file storing the distance vs contact count plot."),
  	make_option(c("--TitleStr"), type="character", default=NULL, help="Title string to be employed in the plot. Default NULL means that no title will be employed in the plot.")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

OutDir <- dirname(opt$OutFile)

tempOutFile <- paste0(OutDir, '/temp_CC_Dist.bed')

# first print the distance vs interaction count in a text file
# where the first column is distance, and the second column is interaction count
system(paste("awk \'function abs(v) {return v < 0 ? -v : v} {print abs($5-$2)}\'", opt$IntFile, "| sort -k1,1n | uniq -c | awk \'{if (NR>1) {print $2\"\t\"$1}}\' - > ", tempOutFile))

InpData <- read.table(tempOutFile, header=F, sep="\t", stringsAsFactors=F)
pdf(opt$OutFile, width=6, height=4)
if (is.null(opt$TitleStr)) {
	par(mar=c(5,5,2,2)+0.1)
}
plot(InpData[,1], InpData[,2], type="l", lty=1, lwd=2, cex=0.5, cex.lab=1.5, col="black", xlab="Interaction Distance", ylab="No of interactions", xlim=c(0, max(InpData[,1])))
if (!is.null(opt$TitleStr)) {
	title("FitHiChIP - distance vs contact count")
}
dev.off()

# now remove the temporary file
system(paste("rm", tempOutFile))


