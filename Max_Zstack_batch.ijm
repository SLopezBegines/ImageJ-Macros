// Define the helper functions first
function findMaxima(array) {
    maxIdx = 0;
    for (i = 1; i < array.length; i++) {
        if (array[i] > array[maxIdx]) {
            maxIdx = i;
        }
    }
    return maxIdx;
}
// Function to generate a new file path with an incremental suffix if the file already exists
function getUniqueFilePath(basePath) {
    path = basePath;
    suffix = 0;
    while (File.exists(path)) {
        suffix += 1;
        path = basePathWithoutExtension + "_" + d2s(suffix, 0) + extension;
    }
    return path;
}



// Extract directory and file name
// Prompt user to select folder for saving results
dir = getDirectory("choose where to save");
fileName = "log.txt";

// Initialize arrays to store image names and IDs
names = newArray(nImages); 
ids = newArray(nImages); 

// Set measurements
run("Set Measurements...", "area mean standard min perimeter feret's integrated stack display add redirect=None decimal=2");


// Define number of planes to select around the maximum and the desired channel
nPlanes = 11; // Change this to the desired number of planes
channel = 4; // Set this to the desired channel

// Initialize log file content
logContent = "Log of selected planes:\n";

// Iterate through each image
for (q = 0; q < ids.length; q++) { 
    selectImage(q + 1); 
    ids[q] = getImageID(); 
    names[q] = getTitle(); 
    selectWindow(names[q]);
    getDimensions(w, h, channels, slices, frames);
    print(ids[q] + " = " + names[q] + "   Z= " + slices); 
    print("-------");
    run("8-bit");
    zslice = slices;
    // Process the specified channel
    Stack.setChannel(channel);
	//Set LUTs to each channel and/or contrast
	Stack.setChannel(1);//GFP
	run("Green");
	Stack.setChannel(2);//NeuN
	run("Magenta");
	Stack.setChannel(3);//DAPI
	run("Cyan");
	Stack.setChannel(4);//Autofluor
	run("Red");

    // Measure intensity for each slice
    intensityResults = newArray(slices);
    for (slice = 1; slice <= slices; slice++) {
        Stack.setSlice(slice);
        run("Measure");
        intensityResults[slice - 1] = getResult("Mean", nResults - 1);
    }
    
    // Find the plane with the maximum intensity
    maxPlane = findMaxima(intensityResults);
    print("Channel " + channel + " max intensity at plane: " + (maxPlane + 1));

    // Calculate the range of planes to select
    startPlane = 1;
    endPlane = nPlanes;
    if (maxPlane >= floor(nPlanes / 2)) {
        startPlane = maxPlane - floor(nPlanes / 2);
     if(startPlane <= 0){
    	startPlane = 1;
    	}
    }
    if ((zslice - maxPlane) > floor(nPlanes / 2)) {
        endPlane = maxPlane + floor(nPlanes / 2);
        if (endPlane < nPlanes) {
        	endPlane = nPlanes;
        }
    }
    
    if(zslice - maxPlane <= nPlanes){
    	startPlane = zslice - nPlanes+1;
    	endPlane = zslice;
    }
    
    
    
    
selectWindow(names[q]);
   run("Make Substack...", "channels=1-"+channels+" slices="+startPlane+ "-"+endPlane);
   //length = lengthOf(names[q])-4;//Remove ".tif" from string name

	// Get the substring from the beginning to the new length
   //outputString = substring(names[q], 0, length);
   //outputString = outputString + "-"+*;
   //selectWindow(outputString);

   title = getTitle(); 
   //selectWindow(names[q]);
   getDimensions(w, h, channels, slices, frames);
   saveAs("tiff", dir+title);
  
    // Remove trailing whitespace manually
    logContent += "Image: " + names[q] + ", Channel: " + channel + ", Z_start: " + zslice + ", Z_finish: " + slices + ", Maxplane: "+ maxPlane +", Start plane: "+ startPlane +", End plane: "+ endPlane +"\n";


//selectWindow(names[q]);
//close(); 
//selectWindow(outputString);
//close(); 

}


// Split file name into base name and extension
dotIndex = lastIndexOf(fileName, ".");
if (dotIndex == -1) {
    baseName = fileName;
    extension = "";
} else {
    baseName = substring(fileName, 0, dotIndex);
    extension = substring(fileName, dotIndex);
}

// Combine directory and base file name
basePath = dir + baseName;
basePathWithoutExtension = basePath;

// Get the unique file path
uniquePath = getUniqueFilePath(basePath + extension);

// Save log content to the unique file path
//logContent = getLog();
File.saveString(logContent, uniquePath);
print("Saved log to: " + uniquePath);

// Save log content to log.txt
//path = dir + "log.txt";
//File.saveString(logContent, path);


// Clean up
if (isOpen("Results")) { 
    selectWindow("Results");
    saveAs("Measurements", dir +"Results.csv");
    selectWindow("Results");
    run("Close"); 
}

while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      }  

if (isOpen("Log")) {
	selectWindow("Log");
	saveAs("Text", dir +"Log2.txt");
	run("Close" );
}
