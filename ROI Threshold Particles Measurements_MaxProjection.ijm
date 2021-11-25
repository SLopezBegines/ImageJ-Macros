
dir = getDirectory("Choose a Directory"); 
names = newArray(nImages); 
ids = newArray(nImages); 
print("Number of images: "+ nImages);

//First, select channel to quantify and desired Threshold
  Dialog.create("Float Image");
  Dialog.addSlider("channel to threshold:", 1, 5, 1);
 // Dialog.addSlider("channel to quantify:", 1, 4, 1);
  Dialog.addSlider("Threshold Min:", 1, 255, 1);
  Dialog.addSlider("Threshold Max:", 1, 255, 255);
  Dialog.addSlider("Particle Size:", 1, 10000, 1);
  Dialog.show();
  thresholdchannel = Dialog.getNumber();
 // quantifychannel = Dialog.getNumber();
  ThresholdMin = Dialog.getNumber();
  ThresholdMax = Dialog.getNumber();
  size = Dialog.getNumber();
  

print("Threshold Channel: " + thresholdchannel);
//print("Quantify Channel: " + quantifychannel);
print("Threshold Min: " + ThresholdMin);
print("Threshold Max: " + ThresholdMax);
print("Size Particle: " + size);
print("-----");

  //Open desired stack to quantify
for (q=0; q <ids.length; q++){ 
	    selectImage(q+1); 
        ids[q] = getImageID(); 
        names[q] = getTitle(); 
        selectWindow(names[q]);
        //Stack.setChannel(thresholdchannel);//
		//run("Enhance Contrast", "saturated=0.35 normalize");
        Stack.setDisplayMode("color");
      	run("Duplicate...", "duplicate");
      	duplicated=getTitle(); 
        selectWindow(duplicated);
      	selectWindow(names[q]);
	    getDimensions(w, h, channels, slices, frames);
	    Stack.getDimensions(w, h, channels, slices, frames);
   		Stack.getPosition(ch, sl, fr);
        print(ids[q] + " = " + names[q] + "   Z= " + slices); 
        run("8-bit");
        selectWindow(duplicated);
		run("Split Channels");
		selectWindow("C"+thresholdchannel+ "-" + duplicated);
		//Add here filter parameters
		run("Median...", "radius=2");
		run("Remove Outliers...", "radius=2 threshold=1 which=Bright");
		run("Threshold...");                 // to open the threshold window if not opened yet 
  		setThreshold(ThresholdMin, ThresholdMax);
  		setOption("BlackBackground", false);
  		run("Convert to Mask");
  		//Add here Watershed
        //run("Analyze Particles...", "size="+size+"-Infinity show=Outlines exclude include add stack");
        run("Analyze Particles...", "size="+size+"-Infinity show=Outlines exclude include add");
    	roiManager("Show All");       
		count=roiManager("count"); 
		array=newArray(count); 
        
        if (roiManager("Count") > 0){
	    for(i=0; i<count;i++) { 
        		array[i] = i; 
        }
				roiManager("Select", array);
				selectWindow(names[q]);
				for(i=1; i<=channels;i++) { 
        		Stack.setChannel(i);	
				roiManager("Measure");
        }
				roiManager("Save",dir + duplicated +'-ROIset.zip');
				print("N ROIs for '"+ duplicated +"' = "+ count);
								
        }
        if (roiManager("Count") == 0){
				print("ROI list empty");
			}
              	selectWindow("Drawing of C"+ thresholdchannel +"-" + duplicated);
				saveAs("tiff", dir+"Drawing of C"+ thresholdchannel +"-" + duplicated);
              	roiManager("reset")
              	if (! isOpen("Results")) {exit ("No Results table")}
              	if (isOpen("Results")) {
				selectWindow("Results");
				saveAs("Measurements. ", dir +"Results.csv");  
				}
				rois+= count;
				print("Total Rois = " + rois);
				print("-------"); 
				selectWindow("Log");
				saveAs("Text", dir +"Log.txt");
				selectWindow("Drawing of C"+ thresholdchannel +"-" + duplicated);
				close();
				selectWindow(names[q]);
				close();
				for(i=1; i<=(channels);i++) { 
        		selectWindow("C"+ i +"-" + duplicated);
				close();
              	}
}

    if (isOpen("Results")) {
         selectWindow("Results"); 
         run("Close" );
    }
    if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );
    }
    while (nImages()>0) {
          selectImage(nImages());  
          run("Close");
    }
