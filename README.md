# macrophage_dancing_analysis_macro
This script can be added in Fiji (ImageJ) to help analyse corneal stromal macrophage morphology and dynamics (Dancing Index) in Fun-IVCM videos.

Before running, cell tracing should be performed manually
 - Trace the same cell for all frames (Shortcut "T" to add into ROI manager) and save the ROIs as .zip (one .zip for each cell), save all ROIs from a video in the same folder

All parameters in results are in the unit of pixel.

Field area is the convex hull area of the cell shape.

The result gives Dancing Index as "non-overlapped area/total area" after co-centralisation of the two cell shapes from two time-points. The value should then be devided by time to get the final Dancing Index.

Author: Mengliang Wu (mengliang.wu@unimelb.edu.au)

June 2024

License: BSD3

Copyright 2024 Mengliang Wu, The Univeristy of Melbourne (Department of Optometry and Vision Sciences)
