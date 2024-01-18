names = newArray(nImages); 
ids = newArray(nImages); 

run("Set Measurements...", "area mean standard min perimeter feret's integrated stack display add redirect=None decimal=2");
//waitForUser("First all, select desired measurements...");
//run("Set Measurements...");
//waitForUser("Now, select folder where to save results...");
dir = getDirectory("choose where to save"); 
names = newArray(nImages); 
ids = newArray(nImages); 
/*
for (q=0; q < ids.length; q++){ 
        selectImage(q+1); 
        ids[q] = getImageID(); 
        names[q] = getTitle(); 
        selectWindow(names[q]);
	    getDimensions(w, h, channels, slices, frames);
        print(ids[q] + " = " + names[q] + "   Z= " + slices); 
        print("-------");
        	run("8-bit");
     			Stack.setChannel(1);//DAPI
				run("Blue");
				Stack.setChannel(2);//Lipo Tau
				run("Red");
				Stack.setChannel(3);//GFP endo
				run("Green");
				Stack.setChannel(4);//Lipof
				run("Cyan");
				//Stack.setChannel(5);//GFP ab
				//run("Cyan");
}

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
*/


for (q=0; q < ids.length; q++){ 
        selectImage(q+1); 
        ids[q] = getImageID(); 
        names[q] = getTitle(); 
        selectWindow(names[q]);
	    getDimensions(w, h, channels, slices, frames);
        print(ids[q] + " = " + names[q] + "   Z= " + slices); 
        print("-------");
 		
	Stack.getDimensions(w, h, channels, slices, frames);
   	Stack.getPosition(ch, sl, fr);

 		for (j=0; j<=channels; j++) {
       		Stack.setChannel(j+1);
			for (v=0; v<=slices; v++) {
                	Stack.setSlice(v+1);
                 	run("Measure");
                	}
				}
//Plot maximal intensity of stack slices
 n=nResults;
    xValues=newArray(slices); 
    	for(i=0;i<slices;i++) { 
          xValues[i]=getResult('Slice',i);
          } 
    //y1=newArray(slices); 
      //   for(i=0;i<slices;i++) { 
        //  y1[i]=getResult('IntDen',i); 
          //} 
 	 y2=newArray(n); 
         for(i=1;i<n;i++) { 
          y2[i]=getResult('IntDen',i); 
          } 

     //Channel 1
	 y1= Array.slice(y2,1, slices);      
	 //Channel 2
	 y2a= Array.slice(y2,slices,y2.length-slices*4);       
	 //Channel 3
	 y3= Array.slice(y2,slices*2,y2.length-slices*3);  
	 //Channel 4
	 y4= Array.slice(y2,slices*3,y2.length-slices*2); 
	 //Channel 5
	 y5= Array.slice(y2,slices*4,y2.length-slices);  
	 //Channel 6
	 y6= Array.slice(y2,slices*5,y2.length); 
/*
     //Channel 1
	 y1= Array.slice(y2,1, slices);      
	 //Channel 2
	 y2a= Array.slice(y2,slices,y2.length-slices*2);       
	 //Channel 3
	 y3= Array.slice(y2,slices*2,y2.length-slices);  
	 //Channel 4
	 y4= Array.slice(y2,slices*3,y2.length); 

     //Channel 1
	 y1= Array.slice(y2,1, slices);      
	 //Channel 2
	 y2a= Array.slice(y2,slices,y2.length-slices);       
	 //Channel 3
	 y3= Array.slice(y2,slices*2,y2.length); 
*/
	     
Array.print(xValues);
Array.print(y1);
Array.print(y2a);
Array.print(y3);
Array.print(y4);
Array.print(y5);
Array.print(y6);
selectWindow("Results");
//IJ.renameResults("Results. " + names[q]);
saveAs("Measurements. ", dir + names[q] +". Results.csv");
selectWindow("Results");
run("Close");
Plot.create("Graph " + names[q], "Slice", "Integrated Density");
//Channel 1
Plot.setColor("black", "Cyan");
Plot.add("circle", xValues, y1);
//Channel 2
Plot.setColor("black", "Magenta");
Plot.add("box", xValues, y2a); 
//Channel 3
Plot.setColor("black", "Green");
Plot.add("triangle", xValues, y3);
//Channel 4
Plot.setColor("black", "Red");
Plot.add("diamond", xValues, y4); 
//Channel 5
Plot.setColor("black", "Yellow");
Plot.add("x", xValues, y5);
//Channel 6
Plot.setColor("black", "Black");
Plot.add("x", xValues, y6);
//Plot.setLegend("ATP5G \t GFP \t BF \t CSP", "top-right");
//Plot.setLegend("GFP \t Lamp1 \t BF \t ATP5G", "top-right");
//Plot.setLegend("DAPI \t LipoTau \t GFPendo \t Lipof \t GFPAb ", "top-right");
//Plot.setLegend("DAPI \t 561 \t 488 \t 657", "top-right");
//Plot.setLegend("DAPI \t ATP5G \t GFP \t Syporin", "top-right");
//Plot.setLegend("DAPI \t 488 \t 561 \t SNAP25", "top-right");
//Plot.setLegend("488 \t 561 \t 647", "top-right");
Plot.setLegend("C1 \t C2 \t C3 \t C4 \t C5 \t C6", "top-right");

Plot.show();
Plot.setLimitsToFit();
saveAs("tiff", dir+ "Graph " + names[q]);
				selectWindow("Log");
				saveAs("Text", dir +"Log.txt");
selectWindow("Graph " + names[q]);
close();
   if (isOpen("Results")) { 
       selectWindow("Results"); 
       run("Close"); 
    } 
}
while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      } 
    if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );
    }