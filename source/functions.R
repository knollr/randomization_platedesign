weight_numeric <- function(num_param) {
  
  collect <- vector()
  
  for (group in 1:n_groups) {
    
    collect <- c(collect, mean(new_data[new_data$new_groups == group,][[num_param]]))
    
    rm(group)
    
  }
  
  result_int <- sd(collect/mean(collect))
  
  return(result_int)
  
}

weight_categoric <- function(cat_param) {
  
  collect <- vector()
  
  
  sd_out <- apply(table(new_data[[cat_param]], new_data[["new_groups"]])/rowSums(table(new_data[[cat_param]], new_data[["new_groups"]])), 
                  1,
                  sd)
  
  result_int <- sum(sd_out)
  
}

my_colors <- c("#89C5DA", "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", "#5F7FC7", 
                     "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", "#AD6F3B", "#CD9BCD", 
                     "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", "#8569D5", "#5E738F", "#D1A33D", 
                     "#8A7C64", "#599861", "#89C5DA", "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", "#5F7FC7", 
                     "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", "#AD6F3B", "#CD9BCD", 
                     "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", "#8569D5", "#5E738F", "#D1A33D", 
                     "#8A7C64", "#599861")
