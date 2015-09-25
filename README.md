# stopandfrisk
Processing animation of NYPD stop and frisk data.

## Instructions
1. Use `process-saf.r` to convert [NYPD's stop and frisk data](http://www.nyc.gov/html/nypd/html/analysis_and_planning/stop_question_and_frisk_report.shtml) into a simpler format. Note that this script assumes the data is in SPSS's `POR` format, which is no longer necessary, since the NYPD started releasing the data in `CSV` form.

2. Make sure the output of `process-saf.r` is named `saf.tsv` in the `data/` directory.

3. Run `saflight.pde` or `safdark.pde` to visualize the data. `saflight` is fairly straightforward; I don't have a clear recollection of what `safdark` is actually doing, and it clearly needs some love.

## Notes
As a sample, the repository contains a compressed `saf.tsv.gz` file in the `data/` directory. This file contains NYPD stop and frisks from January 1, 2012 through the very early morning of March 11, 2012. If you don't want to run the `R` script to process new NYPD data, you can decompress `saf.tsv.gz` and use it to see how the program works.
