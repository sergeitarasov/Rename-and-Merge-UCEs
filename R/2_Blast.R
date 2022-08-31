

#   ____________________________________________________________________________
#   Blast the old loci against the new loci                                 ####

# setwd
dir <- "New_names_fasta"
setwd(file.path('data', dir))

# 1. Copy Coleoptera loci to "data/New_names_fasta"
# 2. Run Blast:
com <- "makeblastdb -in scarab_loci.fasta -dbtype nucl"
system(com)

com <- 'blastn -task blastn  -query all_coleoptera_scarab_probe_monolithic.fasta -db scarab_loci.fasta -perc_identity 95 -outfmt "7 qacc sacc evalue qstart qend sstart send" -out blast_new.txt'
system(com)

# remove everything from env
setwd(base_dir)
rm(list = ls())
source('R/dependencies.R')
base_dir <- getwd()
dir <- "New_names_fasta"

# Read Blast table
blast_out <- read.table(file.path('data', dir, 'blast_new.txt'), sep='\t', stringsAsFactors = F)
colnames(blast_out) <- c("query acc.", "subject acc.", "evalue", "q. start", "q. end", "s. start", "s. end")
blast_out <-as_tibble(blast_out)
blast_out <-mutate(blast_out, trimmed.query=trim_names(`query acc.`), trimmed.subject=trim_names(`subject acc.`))
blast_out


#   ____________________________________________________________________________
#   Got to Steps 3-6. Merge data                                            ####

rstudioapi::navigateToFile("R/3-6_Merge.R")




