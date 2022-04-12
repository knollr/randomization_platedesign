# Clinical Matching

Did you ever needed to match 100s of samples in different sequencing batches? No? Good... But in case you will ever need to do it this script will help you to get it done properly.

In this script you can input a table *start_data* including the clinical parameters of the samples you want to batch correctly and after defining some parameters you can run an endless loop to get the best combination of samples!

The only information you need to provide are:<br/>
*n_group* = number of groups/batched<br/>
*group_size* = number of samples in each batch<br/>
*n_perm* = if you want to define a maximum number of permutations to be performed you can change this number from Inf to a specific value. From initial testing not much improvement after 5 million permutations.

**But how does it work?**

## Minimizing the difference between groups
This script tries to minimize the difference between the groups/batches by looking at the normalized standard deviation between groups. This can be done for both numeric and categorical variable. You need to define which numeric and which categorical variable to optimize. <br/>
This can be defined with two vectors.

*numeric_to_optimize* = For numeric variables<br/>
*categorical_to_optimize* = For categorical variable<br/>

Two simple functions take care of calculating the standard deviation, you can check them in the *source* subfolder.

This script was tested on the docker image: bioconductor/bioconductor_docker:RELEASE_3_13

For eny question contact me at:<br/>
lorenzo.bonaguro@dzne.de