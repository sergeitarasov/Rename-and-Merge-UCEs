

#   ____________________________________________________________________________
#   Steps 3-6. Merge Data                                                   ####

##  ............................................................................
##  Step 3-4.                                                                 ####
#    Based on blast, get shared loci between the old and new set (they should have different names).
#       Shared loci (eval==0) means that corresponding probes are the same too.

setwd(base_dir)

# Select old names that match eval=0, they are shared loci
blast_shared <- blast_out %>% filter(evalue==0.0)
shared.loci=filter(blast_out, evalue==0.0)$`query acc.` %>% unique()
shared.loci.base=filter(blast_out, evalue==0.0)$`query acc.` %>% trim_names %>% unique()

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### check for consistency                                                   ####
# i.e, each base_prefix of old shared locus should match only one type  of base_prefix of new shared locus

q.base <-blast_shared$trimmed.query %>% unique

is.cons=TRUE
for (base in q.base){
  rows <- which(blast_shared$trimmed.query==base)
  sub <- blast_shared$trimmed.subject[rows]
  if (length(unique(sub))!=1){
    print(base)
    is.cons=FALSE
  }
}
# should be True
print(is.cons)

# Check those unique that occur more than ones
blast_out %>% filter(evalue==0.0) %>% group_by(`query acc.`) %>% filter(n()>1)

# if all is ok proceed to the next step


##  ............................................................................
##  Read in new data                                                        ####

dir <- "New_names_fasta"

# New names (Scarabs)
in.loci<- read.fasta(file.path('data', dir, 'scarab_loci.fasta'), seqtype = "DNA") %>% add_base_pref
in.probe <- read.fasta(file.path('data', dir, 'scarab_probes.fasta'), seqtype = "DNA") %>% add_base_pref(get_p_num = T)

# Old probes and loci (Coleoptera from Faircloth)
coleo.loci<- read.fasta("data/UCE_loci/all_coleoptera_scarab_probe_monolithic.fasta", seqtype = "DNA") %>% add_base_pref
coleo.probe <- read.fasta("data/Probes/Coleoptera_1kv1_scarab_subset.fasta", seqtype = "DNA") %>% add_base_pref(get_p_num = T)


##  ............................................................................
##  5. Rename the shared probes:                                            ####
#   for shared loci -> rename accordingly scarab.probes to coleo.probes

# add attribute to eahc probe
for (probe in 1:length(in.probe)){
  attr(in.probe[[probe]], "full_name_old") <- NA
}

in.pref.probe <- get_attr(in.probe, "base_pref") %>% unlist 
for (base in q.base){
  # base is the new name
  # to.rename contains that base to rename
  to.rename <- filter(blast_shared, trimmed.query==base)$trimmed.subject[1]
  rename.probe <- which(in.pref.probe==to.rename)
  for (probe in rename.probe){
    new.id <- str_split(base, "-")[[1]][2] %>% as.numeric()
    attr(in.probe[[probe]], "base_num") <- new.id
    upd <- update_seq_probe(in.probe[probe])
    in.probe[probe] <- upd
    names(in.probe)[probe] <- names(upd)
  }
}

# save csv log
dir <- "New_names_csv"
dir.create(file.path('data', dir))

# read previous
csv <- read.csv(file.path('data', dir, 'probes_renamed_step-1.csv')) %>% tibble()
# new
probe.sav <- tibble('from_5'=get_attr(in.probe, "full_name_old") %>% unlist,
                    'to_5'=get_attr(in.probe, "name") %>% unlist)

# combine
probe.sav <- bind_cols(csv, probe.sav)
write.csv(probe.sav, file.path('data', dir, 'probes_renamed_step-5.csv'))



##  ............................................................................
##  6. Concatenate probes:                                                 ####
#   get coleo-specific probes and merge them with step 5

# selelect coleo specific probes
coleo.probe.base <- get_attr(coleo.probe, "base_pref") %>% unlist
coleo.bases <- blast_out$trimmed.query %>% unique
coleo.specific.loci <- coleo.bases[!(coleo.bases %in% shared.loci.base)]

coleo.specific.probes <- list()
for (locus in coleo.specific.loci){
  prb <- which(coleo.probe.base==locus)
  coleo.specific.probes <-append(coleo.specific.probes, coleo.probe[prb])
}

# merge data
out.probes <- append(coleo.specific.probes, in.probe)


##  ............................................................................
##  Save fasta                                                              ####

dir <- "output_probes"
dir.create(file.path('data', dir))

seq.names <- get_attr(out.probes, "Annot")
seq.names <-lapply(seq.names, function(x) str_sub(x, 2, -1))
write.fasta(out.probes, names=seq.names, file.out=file.path('data', dir, 'scarab_probes_merged.fasta'))
