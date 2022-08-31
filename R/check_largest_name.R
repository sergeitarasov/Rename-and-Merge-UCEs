# Check what is the largest ID in Coleo dataset
#   should be 1814
base_num_probe <- get_attr(coleo.probe, "base_num") %>% unlist
base_num_loci <- get_attr(coleo.loci, "base_num") %>% unlist
min(base_num_probe)
max(base_num_probe)
min(base_num_loci)
max(base_num_loci)

# in scarabs
get_attr(in.probe, "base_num") %>% unlist %>% unique %>% max
get_attr(in.loci, "base_num") %>% unlist %>% unique %>% max
