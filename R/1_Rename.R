
#   ____________________________________________________________________________
#   1. Rename Probes and Loci                                               ####

# this two vars will be used for checking
Len.prb <- get_attr(in.probe, "base_num") %>% unlist %>% unique %>% length
Len.loci <-get_attr(in.loci, "base_num") %>% unlist %>% unique %>% length

in_probes <- get_attr(in.probe, "base_num") %>% unlist %>% unique
in_base_num_probe_all <- get_attr(in.probe, "base_num") %>% unlist
in_base_num_loci_all <- get_attr(in.loci, "base_num") %>% unlist
new.id=START_BASE_NUM

for (unique in in_probes){
  #print(i)
  x <- which(in_base_num_probe_all==unique)
  for (probe in x){
    attr(in.probe[[probe]], "base_num") <- new.id
    upd <- update_seq_probe(in.probe[probe])
    in.probe[probe] <- upd
    names(in.probe)[probe] <- names(upd)
  }
  x <- which(in_base_num_loci_all==unique)
  for (probe in x){
    attr(in.loci[[probe]], "base_num") <- new.id
    upd <- update_seq_loci(in.loci[probe])
    in.loci[probe] <- upd
    names(in.loci)[probe] <- names(upd)
  }
  new.id=new.id+1
}

# check if all is ok
get_attr(in.probe, "base_num") %>% unlist %>% unique %>% max
get_attr(in.probe, "base_num") %>% unlist %>% unique %>% min
get_attr(in.loci, "base_num") %>% unlist %>% unique %>% max
get_attr(in.loci, "base_num") %>% unlist %>% unique %>% min

# should be the same
Len.prb
get_attr(in.probe, "base_num") %>% unlist %>% unique %>% length
Len.loci
get_attr(in.loci, "base_num") %>% unlist %>% unique %>% length


##  ............................................................................
##  Save fasta                                                              ####

dir <- "New_names_fasta"
dir.create(file.path('data', dir))

seq.names <- get_attr(in.probe, "Annot")
seq.names <-lapply(seq.names, function(x) str_sub(x, 2, -1))
write.fasta(in.probe, names=seq.names, file.out=file.path('data', dir, 'scarab_probes.fasta'))

seq.names <- get_attr(in.loci, "Annot")
seq.names <-lapply(seq.names, function(x) str_sub(x, 2, -1))
write.fasta(in.loci, names=seq.names, file.out=file.path('data', dir, 'scarab_loci.fasta'))


##  ............................................................................
##  Save csv for log                                                        ####

# save csv with old and new names for contorol
dir <- "New_names_csv"
dir.create(file.path('data', dir))

probe.sav <- tibble('from'=get_attr(in.probe, "full_name_old") %>% unlist,
                   'to'=get_attr(in.probe, "name") %>% unlist)

loci.sav <- tibble('from'=get_attr(in.loci, "full_name_old") %>% unlist,
                  'to'=get_attr(in.loci, "name") %>% unlist)

write.csv(probe.sav, file.path('data', dir, 'probes_renamed_step-1.csv'))
write.csv(loci.sav, file.path('data', dir, 'loci_renamed_step-1.csv'))


#   ____________________________________________________________________________
#   Go to Step 2. Blast                                                      ####

rstudioapi::navigateToFile("R/2_Blast.R")
