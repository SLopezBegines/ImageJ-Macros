dir = getDirectory("Choose a Directory"); 
names = newArray(nImages); 
ids = newArray(nImages); 


for (q=0; q < ids.length; q++){ 
	selectImage(q+1); 
	ids[q] = getImageID(); 
	names[q] = getTitle(); 
	selectWindow(names[q]);
	getDimensions(w, h, channels, slices, frames);
	print(ids[q] + " = " + names[q] + "   Z= " + slices); 
	print("-------");

	run("8-bit");
	//run("Median...", "radius=2 stack");
	//run("Arrange Channels...", "new=13245");
	
	//Set LUTs to each channel and/or contrast
	Stack.setChannel(1);//DAPI
	run("Cyan");
	Stack.setChannel(2);//568 Lipof
	run("Magenta");
	Stack.setChannel(3);//GFP 0.5ns
	run("Red");
	Stack.setChannel(4);//GFP 2.7ns GFP
	run("Green");
//	Stack.setChannel(5);//GFP Tau Contrast
//	run("Yellow");
//	Stack.setChannel(6);//GFP 647
//	run("Grays");
//	setMinAndMax(15, 215);
	

/*
//Quantification by Z
	makeRectangle(587,573,100,100);
	waitForUser("Do something, then click OK."); //STOP and continues when I press OK
	//Roi.setPosition(2, 1, 1);
	roiManager("Add");//para incluir el ROI en el ROI manager (manualmente sería presionando t)
	n = roiManager("count");
	roiManager("Select", n-1);
	roiManager("Rename",names[q]);
		for (j=0; j<channels; j++) {
			Stack.setChannel(j+1);
			for (v=0; v<slices; v++) {
				Stack.setSlice(v+1);
				run("Measure");
			}
		}
		
*/


	selectWindow(names[q]);
//	run("Z Project...");
	// Add function to create substack with desired number of slices
	run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]"); 
	//run("Z Project...", "start=1 stop=13 projection=[Max Intensity]"); 
	selectWindow("MAX_" + names[q]);
	run("Duplicate...", "duplicate");
	Property.set("CompositeProjection", "Sum");
	Stack.setDisplayMode("composite");
	Stack.setActiveChannels("1111");
	run("RGB Color");

	selectWindow("MAX_" + names[q]);
	run("Split Channels");

	/*
	selectWindow(names[q]);
	run("Split Channels");
	for(i=1; i<=(channels);i++) { 
        		selectWindow("C"+ i +"-" + names[q]);
        		title=getTitle();
        		saveAs("tiff", dir+title+" invertedLUT");
				close();
	}
	*/
}


//Save Everything

//dir = getDirectory("Choose a Directory"); 
print("Saving...");
ids=newArray(nImages); 
for (i=0;i<nImages;i++) { 
	selectImage(i+1); 
	title = getTitle(); 
	//title=replace(title, "\\. ", "");
	print(title); 
	ids[i]=getImageID(); 
	saveAs("tiff", dir+title);
	
}
/*
roiManager("Save",dir+'ROIset.zip');
selectWindow("Results");
saveAs("Measurements. ", dir +"Results.csv");
selectWindow("Log");
saveAs("Text", dir +"Log.txt");
*/
while (nImages>0){ 
	selectImage(nImages); 
	close(); 
	}
if (isOpen("Results")) {
	selectWindow("Results"); 
	run("Close" );
	}
	if (isOpen("Log")) {
	selectWindow("Log");
	saveAs("Text", dir +"Log.txt");
	run("Close" );
	}