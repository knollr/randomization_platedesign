# Clinical Matching

## randomization

Do you have hundreds of samples and want to randomize your data for multiple clinical parameters to avoid batch effects in (bulk) RNAseq? Then this script is perfect for you!

All you need to execute is one function *randomize_data* which randomizes your *input_data* for the clinical parameters of your choice. These can either be numerical (e.g. age) or categorical (e.g. sex, center). 

The only information you need to provide are:<br/>
*n_samples_per_batch*: number of samples in each batch. E.g. 24 samples per RNA extraction batch is common. <br/>
*n_batches*: amount of extraction rounds (if empty: default is the rounded result from total n samples divided by n_samples_per_batch)<br/>
*randomize_numeric*: numeric metadata to randomize, must be a column in input.<br/>
*randomize_categorical*: categorical metadata to randomize, must be a column in input.<br/>

The randomization will stop automatically after a certain time. If you want to choose a specific amount of permutations, you can use the *n_perm* parameter. 

## plate desing (optional)

The randomization script above is mostly used for bulk RNA-seq experiments. It would be nice to have 96-well plate layout, as the samples will be processed in that manner. This helps the handling person in the lab and gives a nice overview.

This can be easily done using the *create_plate_design* function. Please choose which labels should be put on the 96-well plate distribution (*variables_to_include*), e.g. randomized order and donor ID are important. After selecting a path and filename (*path*) a nice excel file will be generated depicting the 96-well plates in the respective sheets which are colored by 24-batches (column-wise).


For any question contact me at:<br/>
rainer.knoll@dzne.de
