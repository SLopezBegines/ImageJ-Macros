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
}
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
     			//Stack.setChannel(4);					//substract background signal obtained in secondary Ab only staining
     			//run("Subtract...", "value=25 slice"); //Substract to any channel in which any signal is seen. 
     			//Stack.setChannel(3);
     			//run("Subtract...", "value=25 slice");
        		Stack.setChannel(1);//DAPI
				run("Blue");
				Stack.setChannel(2);//ATP5G
				run("Green");
				Stack.setChannel(3);//GFP
				run("Red");
				//setMinAndMax(40, 255);
				Stack.setChannel(4);//Synaptoporin
				run("Cyan");
				//Stack.setChannel(5);//ATP5G
				//run("Cyan");
				//Stack.setChannel(6);//GFP
				//run("Grays");
				//Stack.setChannel(7);//Synaptoporin
				//run("Red");
				run("Make Composite");
				Stack.setActiveChannels("1011");
				run("RGB Color");
			/*
				run("Z Project...");
				//run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]"); 
				//run("Z Project...", "start=1 stop=13 projection=[Max Intensity]"); 
				selectWindow("MAX_" + names[q]);
				run("Duplicate...", "duplicate");
				run("Make Composite");
				Stack.setActiveChannels("1111");
				run("RGB Color");
				selectWindow("MAX_" + names[q]);
				//selectWindow(names[q]);
				
				run("Split Channels");		
				
				for(i=1; i<=(channels);i++) { 
        		selectWindow("C"+ i +"-MAX_" + names[q]);
				title = getTitle(); 
        		//title=replace(title, "\\. ", "");
        		print(title); 
        		ids[i]=getImageID(); 
        		saveAs("tiff", dir+title);
				close();
              	}
              	*/
      			//run("Split Channels");		
}

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

while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      }
 