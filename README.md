# Snow-albedo-feedback
This repository include the codes used to compute snow-albedo feedback for a suite of CMIP3 and CMIP5 models as well as the intermediate and final output.

# References

Hall A, and X Qu, 2006: Using the current seasonal cycle to constrain snow albedo feedback in future climate change. Geophysical Research Letters, 33, L03502. DOI: 10.1029/2005GL025127.

Qu X and A Hall, 2014: On the persistent spread in snow-albedo feedback. Climate Dynamics, 42(1-2), 69-81. DOI: 10.1007/s00382-013-1945-z. 

# Input
------------

| Frequency | Variable |  CMOR lables |  Unit  |  File Format |
|:----------  |:--------------------|:----------------|:---------------|:------------|
| monthly mean |downward shortwave flux at surface | rsds |  W m-2  | nc
|             | upward shortwave flux at surface | rsus |  W m-2  | nc
|             |surface temperature | tas  | K | nc 
| constant    |land cover          | sftlf |  |nc

These variables were downloaded from https://esgf-node.llnl.gov/search/esgf-llnl/.
Sample input data is provided as compressed nc files. To use these data for the testing purpose, however, one needs to change the part of the code where data is read. 

# Output

Intermediate output: climatological mean surface albedo and surface air tmeperature averaged over northern hemisphere extratropical land masses in a suite of CMIP3 and CMIP5 models They are saved in the following files, respectively: surface_albedo_temperature_in_current_future_climate_CMIP3.nc and surface_albedo_temperature_in_current_future_climate_CMIP5.nc.

Final output: The strength of snow-albedo feedback in a suite of CMIP3 and CMIP5 models (snow_albedo_feedback.nc).

Is a script to draw the figure included ?: Yes
