randomize_data <- function(input = input_data,
                           n_samples_per_batch = 24,
                           n_batches =  NULL, #
                           randomize_numeric = c("age"),
                           randomize_categorical = c("center", "sex"),
                           reproducible = T, 
                           n_perm = NULL){
  
  # other functions
  weight_numeric <- function(num_param, n_b = n_batches, new_dat = new_data, column_name = "new_groups") {
    collect <- vector()
    for (n in 1:n_b) {
      collect <- c(collect, mean(new_dat[new_dat[[column_name]] == n,][[num_param]]))
    }
    result_int <- sd(collect/mean(collect))
    return(result_int)
  }
  
  weight_categoric <- function(cat_param, new_dat = new_data, column_name = "new_groups") {
    collect <- vector()
    sd_out <- apply(table(new_dat[[cat_param]], new_dat[[column_name]])/rowSums(table(new_dat[[cat_param]], new_dat[[column_name]])), 
                    1,
                    sd)
    result_int <- sum(sd_out)
    return(result_int)
  }
  # start
  
  if(is.null(n_batches)) n_batches = nrow(input_data)/n_samples_per_batch
  if(reproducible == T) set.seed(42)
  
  ## Running the model
  
  # Defining the new groups according to the parameter set
  new_groups <- vector()
  for (group_num in 1:n_batches) {
    
    new_groups <- c(new_groups, rep(group_num, n_samples_per_batch))
    
    rm(group_num)
    
  }
  # If the number of samples is not divisible for the group correctly (e.g. the last group os smaller), we need a correction
  if (n_samples_per_batch*n_batches != dim(input)[1]) {
    new_groups <- new_groups[1:dim(input)[1]]
  }
  
  ### Preparing a container for the results
  
  # Generate a place to collect the results
  permutation <- list()
  permutation$orders <- vector() # This is the container for the list order
  permutation$reults <- Inf # This is the container for the final score
  
  ### Permutations
  
  # Initialize a counter
  counter <- 0
  permut <- 0
  time_vector <- c(Sys.time())
  
  repeat {
    # Add a counter for the permuation - Just to see how fast it goes
    permut <- permut + 1
    
    if (permut %% 50000 == 0) print(paste("Permutation:", permut, sep = " "))
    
    if(!is.null(n_perm)) if(permut == n_perm) break # This is because is not possible to set a for loop to infinite, in this case I need the repeat function with a break rule
    
    # Generate a new random order of the data
    random_order <- sample(seq(1:dim(input)[1]), dim(input), replace = FALSE)
    # Adding the new groups to the data table with the new order
    new_data <- input[random_order, ]
    new_data$new_groups <- new_groups # This is the new grouping which we should test
    # From here I can add the rules
    result_int <- 0
    
    ## Optimization of numeric
    if (!is.null(randomize_numeric)) {
      
      for (variable_num in randomize_numeric) {
        result_int <- result_int + weight_numeric(variable_num)
      }
    }
    
    ## Optimization of categorical
    if (!is.null(randomize_categorical)) {
      
      for (variable_cat in randomize_categorical) {
        
        result_int <- result_int + weight_categoric(variable_cat)
        
      }
      
    }
    
    # If the result is better save it!
    if (result_int < permutation$reults) {
      
      permutation$orders <- random_order
      permutation$reults <- result_int
      
      counter <- counter + 1
      
      print(paste("I just got better:", counter, sep = " "))
      
      time_vector <- c(time_vector, Sys.time())
      
      if(is.null(n_perm)){
        # time taken since last enhancement
        if(counter -1 > 0){
          time_taken <- round(difftime(time_vector[counter] ,time_vector[counter - 1], units = "secs"))
          if(time_taken > 1*30) break
        }    
        
      }
 
      
    }
    
  }
  print("finished")
  best_match <- input[permutation$orders, ]
  best_match$randomized_order <- 1:nrow(best_match)
  best_match$batch <- new_groups
  return(best_match)  
  
} 



plot_numeric <- function(random_data = random_data, randomize_numeric = "age"){
  
  tmp <- random_data
  tmp$variable <- tmp[[randomize_numeric]]
  
  p <- ggplot(tmp, aes(x = as.factor(batch), y = variable, fill = as.factor(batch)))+
    geom_boxplot(alpha = 1)+
    scale_fill_manual(values = my_colors) + 
    geom_hline(yintercept = mean(tmp$variable), linetype = "dashed") +
    theme_bw() + 
    theme(aspect.ratio = 1/2, axis.text = element_text(size = 12), axis.title = element_text(size = 14), plot.title = element_text(size = 16)) + 
    ggtitle(paste("Permutation result:", randomize_numeric))+
    xlab("Batch")+
    ylab(randomize_numeric)
  
  print(p)
}


plot_categorical <- function(random_data = random_data, randomize_categorical = "sex"){
  
  tmp <- random_data
  tmp$variable <- tmp[[randomize_categorical]]
  
  p <- ggplot(tmp, aes(x = as.factor(batch), fill = variable))+
    geom_bar(alpha = 1, color = "black")+
    scale_fill_manual(values = my_colors) + 
    theme_bw() + 
    theme(aspect.ratio = 1/2, axis.text = element_text(size = 12), axis.title = element_text(size = 14), plot.title = element_text(size = 16)) + 
    ggtitle(paste("Permutation result:", randomize_categorical))+
    xlab("Batch")+
    ylab(randomize_categorical)
  
  print(p)
}

my_colors <- c("#89C5DA", "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", "#5F7FC7", 
               "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", "#AD6F3B", "#CD9BCD", 
               "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", "#8569D5", "#5E738F", "#D1A33D", 
               "#8A7C64", "#599861", "#89C5DA", "#DA5724", "#74D944", "#CE50CA", "#3F4921", "#C0717C", "#CBD588", "#5F7FC7", 
               "#673770", "#D3D93E", "#38333E", "#508578", "#D7C1B1", "#689030", "#AD6F3B", "#CD9BCD", 
               "#D14285", "#6DDE88", "#652926", "#7FDCC0", "#C84248", "#8569D5", "#5E738F", "#D1A33D", 
               "#8A7C64", "#599861")


create_plate_design <- function(random_data = random_data, 
                                variables_to_include = c("randomized_order", "donor", "PRECISE_ID"),
                                path = "plate_design.xlsx"){
  
  tmp <- random_data
  tmp$sample_num_plate <- rep(1:96, ceiling(nrow(tmp)/96))[1:nrow(tmp)]
  
  c_all <- vector()
  for(i in 1:c(ceiling(nrow(tmp)/96))){
    c_tmp <- rep(i, 96)
    c_all <- c(c_all, c_tmp)
  }
  
  tmp$plate <- c_all[1:nrow(tmp)]
  
  sub <- tmp[, variables_to_include]
  combine_columns <- function(row) paste0(row, collapse = " ")
  # Apply the combining function row-wise using apply
  combined <- apply(sub, 1, combine_columns)
  tmp$combined <- combined
  
  tmp_list <- list()
  
  for(i in unique(tmp$plate)){
    
    table_tmp <- tmp[tmp$plate == i, ]
    
    r1.1 <- as.data.frame(table_tmp$combined[1:8])
    r1.2 <- as.data.frame(table_tmp$combined[9:16])
    r1.3 <- as.data.frame(table_tmp$combined[17:24])
    
    r2.1 <- as.data.frame(table_tmp$combined[25:32])
    r2.2 <- as.data.frame(table_tmp$combined[33:40])
    r2.3 <- as.data.frame(table_tmp$combined[41:48])
    
    r3.1 <- as.data.frame(table_tmp$combined[49:56])
    r3.2 <- as.data.frame(table_tmp$combined[57:64])
    r3.3 <- as.data.frame(table_tmp$combined[65:72])
    
    r4.1 <- as.data.frame(table_tmp$combined[73:80])
    r4.2 <- as.data.frame(table_tmp$combined[81:88])
    r4.3 <- as.data.frame(table_tmp$combined[89:96])
    
    tmp_i <- cbind(r1.1, c(r1.2, r1.3, r2.1, r2.2, r2.3, r3.1, r3.2, r3.3, r4.1, r4.2, r4.3))
    colnames(tmp_i) <- paste0(as.character(1:12))
    row.names(tmp_i) <- LETTERS[1:8]
    
    tmp_list[[paste(i)]] <- tmp_i
    
  }
  
  # Create a workbook
  wb <- createWorkbook()
  
  # Loop through the list of data frames and add each one to a new sheet
  for (i in seq_along(tmp_list)) {
    # Extract dataframe and name
    df <- tmp_list[[i]]
    df_name <- paste0("plate_", names(tmp_list)[i])
    
    # Add a worksheet
    addWorksheet(wb, sheetName = df_name)
    
    # Write data frame to the sheet
    writeData(wb, sheet = df_name, x = df, rowNames = T)
    
    addStyle(wb, sheet = df_name, style = createStyle(halign = "center", valign = "center", fontSize = 14, textDecoration = "bold"), 
             gridExpand = T, cols = 1:13, rows = 1:13)
    
    addStyle(wb, sheet = df_name, style = createStyle(fgFill = "#a9a9a9", halign = "center", valign = "center", fontSize = 12, wrapText = T, border = c("top", "bottom", "left", "right")), 
             rows = 2:9, cols = c(5, 6, 7, 11, 12, 13), gridExpand = T)
    
    # Fill certain cells with grey color
    addStyle(wb, sheet = df_name, style = createStyle(fgFill = "#D3D3D3", halign = "center", valign = "center", fontSize = 12, wrapText = T, border = c("top", "bottom", "left", "right")), 
             rows = 2:9, cols = c(2, 3, 4, 8, 9, 10), gridExpand = T)
    
    setColWidths(wb, sheet = df_name, cols = 1:ncol(df)+1, widths = 17.15)
    
    # Adjust row height
    setRowHeights(wb, sheet = df_name, rows = 1:nrow(df)+1, heights = 48)
    setRowHeights(wb, sheet = df_name, rows = 1, heights = 25)
    
    
  }
  
  # Save the workbook
  saveWorkbook(wb, path, overwrite = TRUE)
  
}
