###############################################################################
#
# This script renames and combines UCE probes 
# between two sets: previously developed one (e..g, Faircloth for Coleoptera)
# and a newly designed one (e.g. Scarabaienae set).
#
# The main aim is to "align" both set of probes under the same names.
#
# Author: Sergei Tarasov, 2022
#
###############################################################################
#   ____________________________________________________________________________
#   Workflow                                                                 ####
# Data:
#   1. Set (fasta file) of previous (old) probes (e..g, Faircloth for Coleoptera)
#   2. Set of loci fished out using previous probes
#   3. Set of new probes
#   4. Loci fished out using the new probes
#
# Workflow:
#   1. Rename the new probes and loci to make them not intersect with the old ones
#   2. Blast the old loci against the new loci
#   3. Based on blast, get shared loci between the old and new set (they should have different names)
#       Shared loci means that corresponding probes are the same too.
#   4. Now you have three set of probes (loci): probes specific to the old set, shared probes between old and new set,
#       and loci unique to the new set.
#   5. Rename the shared probes: if old and new loci are the same, rename the new probe with the name of the old probe
#   6. Concatenate probes: concatenated probes specific to the old set with the set from step 5.


source('R/dependencies.R')
base_dir <- getwd()

#   ____________________________________________________________________________
#   Read in data and set parameters                                         ####

# New probes and loci (Scarabs)
in.loci<- read.fasta("data/UCE_loci/2k_scarab_probe_monolithic.fasta", seqtype = "DNA") %>% add_base_pref
in.probe <- read.fasta("data/Probes/Scarab_2Kv1_final_probe_set.fasta", seqtype = "DNA") %>% add_base_pref(get_p_num = T)

# Old probes and loci (Coleoptera from Faircloth)
coleo.loci<- read.fasta("data/UCE_loci/all_coleoptera_scarab_probe_monolithic.fasta", seqtype = "DNA") %>% add_base_pref
coleo.probe <- read.fasta("data/Probes/Coleoptera_1kv1_scarab_subset.fasta", seqtype = "DNA") %>% add_base_pref(get_p_num = T)

# This parameter controls the staring id for new names
# It is chosen to be higher than any id in the old probe names
#   uncomment this line to get the largest id
#     rstudioapi::navigateToFile("R/check_largest_name.R")
START_BASE_NUM=2000

#   ____________________________________________________________________________
#   Go to Step 1. Rename old sets                                           ####

rstudioapi::navigateToFile("R/1_Rename.R")




