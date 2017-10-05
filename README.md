# Snow-albedo-feedback
This repository include the codes used to compute snow-albedo feedback for a suite of CMIP3 and CMIP5 models as well as the intermediate and final outpu.

# References

Hall A, and X Qu, 2006: Using the current seasonal cycle to constrain snow albedo feedback in future climate change. Geophysical Research Letters, 33, L03502. DOI: 10.1029/2005GL025127.

Qu X and A Hall, 2014: On the persistent spread in snow-albedo feedback. Climate Dynamics, 42(1-2), 69-81. DOI: 10.1007/s00382-013-1945-z. 

# Input
------------

| Frequency | Variable |  CMOR lables |  Unit  |  File Format |
|:----------  |:--------------------|:----------------|:---------------|:------------|
| monthly mean |downward shortwave flux at surface | rsds | %  | nc
|             |Surface temperature | tas  | K | nc 
| constant    |land cover          | sftlf |  |nc

These variables were downloaded from https://esgf-node.llnl.gov/search/esgf-llnl/.
Sample input data is provided as compressed nc files. To use these data for the testing purpose, however, one needs to change the part of the code where data is read. 

# Output

Intermediate output: time series of low cloud cover, EIS and SST during the period of 1900-1999. They are saved in the following files, respectively: low_cloud_time_series_1900_1999_CMIP5.nc, EIS_time_series_1900_1999_CMIP5.nc and SST_time_series_1900_1999_CMIP5.nc 

Final output: EIS and SST slope averaged over five regions from 36 CMIP models [figures and nc file (SST_EIS_slope_CMIP5.nc), which only contains values for 18 CMIP5 models].

Is a script to draw a figure in the paper included ?: No
