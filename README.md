# stopandfrisk
Processing animation of NYPD stop and frisk data.

## Instructions
1. Use `process-saf.r` to convert [NYPD's stop and frisk data](http://www.nyc.gov/html/nypd/html/analysis_and_planning/stop_question_and_frisk_report.shtml) into a simpler format. Note that this script assumes the data is in SPSS's `POR` format, which is no longer necessary, since the NYPD started releasing the data in `CSV` form.

2. Make sure the output of `process-saf.r` is named `saf.tsv` in the `data/` directory.

3. Run `stopandfrisk.pde` to visualize the data.
