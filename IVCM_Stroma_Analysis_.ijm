//IVCM Stroma Analysis.ijm
//
//This script helps to analyse corneal stromal macrophage morphology and dynamics (Dancing Index)
//Before running, trace the same cell for all frames and save it as ROI.zip, save all ROIs from a video in the same folder
//
//Author: Mengliang Wu (mengliang.wu@unimelb.edu.au)
//June 2024
//License: BSD3

//Copyright 2024 Mengliang Wu, The Univeristy of Melbourne (Department of Optometry and Vision Sciences)

macro "IVCM IC measure Action Tool - C059T3e16M" {
close("Results");
run("8-bit");
Image.removeScale();
run("Set Measurements...", "area centroid perimeter bounding shape feret's display redirect=None decimal=3");
indir = getDirectory("Select a ROI folder");
title = File.getName(indir);
list = getFileList(indir);
for (i = 0; i < list.length; i++) {
	path = indir + list[i];
	roiManager("open", path);
    n = nResults; 
    roi_count = roiManager("count");
    roi_array = newArray(roi_count);
    field_array = newArray(roi_count);
    for (j = 0; j < roi_count; j++) {
        roi_array[j] = j;
        roiManager("select", j);
        run("Convex Hull");
        roiManager("add");
        field_array[j] = j+roi_count;
    }
    roiManager("Deselect");
    roiManager("measure");
    roiManager("select", field_array);
    roiManager("delete");
    for (j = 1; j < roi_count; j++) {
    	centroid_x0 = getResult("X", n+roi_count-j-1);
        centroid_y0 = getResult("Y", n+roi_count-j-1);
        area0 = getResult("Area", n+roi_count-j-1);
        area1 = getResult("Area", n+roi_count-j);
        box_x1 = getResult("BX", n+roi_count-j);
        box_y1 = getResult("BY", n+roi_count-j);
        centroid_x1 = getResult("X", n+roi_count-j);
        centroid_y1 = getResult("Y", n+roi_count-j);
        relative_x = (centroid_x1 - centroid_x0);
        relative_y = (centroid_y1 - centroid_y0);
        new_position_x = (box_x1 - relative_x);
        new_position_y = (box_y1 - relative_y);
        roiManager("select", roi_count-j);
        Roi.move(new_position_x, new_position_y);
    	roiManager("Add");
        roiManager("select", newArray(roi_count-j-1,roi_count));
        roiManager("combine");
        roiManager("Add");
        roiManager("select", newArray(roi_count-j-1,roi_count));
        roiManager("AND");
        roiManager("Add");
        roiManager("select", newArray(roi_count+1,roi_count+2));
        roiManager("measure");
        roiManager("select", newArray(roi_count,roi_count+1,roi_count+2));
        roiManager("delete");
        area_Combined = getResult("Area", n+roi_count+roi_count);
        area_Overlay = getResult("Area", n+roi_count+roi_count+1);
        Table.deleteRows(n+roi_count+roi_count,n+roi_count+roi_count+1);
        dance_index = (area_Combined - area_Overlay)/(area0 + area1);
        setResult("Dancing", n+roi_count-j, dance_index);
        distance = sqrt(pow(relative_x, 2)+pow(relative_y, 2));
        setResult("Distance", n+roi_count-j, distance);
    }
    //Sx = getResult("X", n+roi_count-1) - getResult("X", n);
    //Sy = getResult("Y", n+roi_count-1) - getResult("Y", n);
    Blank = -1;
    setResult("Distance", n, Blank);
    setResult("Dancing", n, Blank);
	for (k = 0; k < roi_count; k++) {
        field_area = getResult("Area", n+roi_count+k);
	    setResult("Field area", n+k, field_area);
	    setResult("Cell No.", n+k, i+1);
	 }
	 Table.deleteRows(n+roi_count,n+roi_count+roi_count);
	 roiManager("Deselect");
     roiManager("delete");
}
//close("*");
close("ROI Manager");
//Table.deleteColumn("X");
//Table.deleteColumn("Y");
Table.deleteColumn("BX");
Table.deleteColumn("BY");
Table.deleteColumn("Width");
Table.deleteColumn("Height");
Table.deleteColumn("FeretX");
Table.deleteColumn("FeretY");
Table.deleteColumn("FeretAngle");
Table.deleteColumn("MinFeret");
//Table.deleteColumn("AR");
Dialog.create("Message");
Dialog.addMessage("Analysis Done!");
Dialog.show();
}
