
trim_names <- function(x){
  x <- str_split( x, fixed("_"))
  lapply(x, function(x) x[1]) %>% unlist
}


get_attr <- function(list, attr){
  lapply(list, function(x) attr(x, attr))
}

add_base_pref <- function(list, get_p_num=FALSE){
  # i=1
  for (i in seq_along(list)){
    nm=attr(list[[i]], "name")
    attr(list[[i]], "base_pref")=trim_names(nm)
    attr(list[[i]], "base_num")=get_num(nm)
    if (get_p_num){
      attr(list[[i]], "p_num")=get_p_num(nm)
    }
  }
  return(list)
}

#str_match("uce-1522_p14", "_p\\s*(.*?)\\s*$")
get_p_num <- function(a){
  #a <- "uce-425_p7" 
  res <- str_match(a, "_p\\s*(.*?)\\s*$")
  as.numeric(res[,2])
}


get_num <- function(a){
  #a <- "uce-425_p7" 
  res <- str_match(a, "-\\s*(.*?)\\s*_")
  as.numeric(res[,2])
}

# seq <- in.probe[1]
# update given base_num and p_num
# update_seq(seq)
update_seq_probe <- function(seq){
  base_pref_old <- attr(seq[[1]], "base_pref")
  full_name_old <- attr(seq[[1]], "name")
  attr(seq[[1]], "full_name_old") <- full_name_old
  #--
  base_num <- attr(seq[[1]], "base_num")
  p_num <- attr(seq[[1]], "p_num")
  
  base_pref <- paste0('uce-', base_num)
  full_name <- paste0(base_pref, '_p', p_num) 
  attr(seq[[1]], "base_pref") <- base_pref
  attr(seq[[1]], "name") <- full_name
  #---
  str <- attr(seq[[1]], "Annot")
  str <- str_replace(str, full_name_old, full_name)
  str <-str_replace(str, base_pref_old, base_pref)
  attr(seq[[1]], "Annot") <- str
  #--
  names(seq) <- full_name
  return(seq)

}

# seq <- in.loci[1]
update_seq_loci <- function(seq){
  base_pref_old <- attr(seq[[1]], "base_pref")
  full_name_old <- attr(seq[[1]], "name")
  suffix_old <- str_match(full_name_old, "_\\s*(.*?)\\s*$")[,2]
  attr(seq[[1]], "full_name_old") <- full_name_old
  #--
  base_num <- attr(seq[[1]], "base_num")
  #p_num <- attr(seq[[1]], "p_num")
  
  base_pref <- paste0('uce-', base_num)
  full_name <- paste0(base_pref, '_', suffix_old) 
  attr(seq[[1]], "base_pref") <- base_pref
  attr(seq[[1]], "name") <- full_name
  #---
  str <- attr(seq[[1]], "Annot")
  #str <- str_replace(str, full_name_old, full_name)
  str <-str_replace_all(str, base_pref_old, base_pref)
  attr(seq[[1]], "Annot") <- str
  #--
  names(seq) <- full_name
  return(seq)
  
}