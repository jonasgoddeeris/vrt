function onEdit() {
  // this line just refers to the current file 
  var start = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var current = start.getActiveCell()
  
  // var to refer to the worksheets
  var main = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("VRT NU");
  var list = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Sources");
  
  // which medeium has the user selected (based on active cell if column number is 4)?
  if (current.getColumn()==4)
  {
  //copy the selected medium from any (utm) file  
    var medium = current.getValue()
  //into the sources file as a dynamic indirect generator
    list.getRange(2,14).setValue(medium)
      
  //clear any validation
  main.getRange(2,2,22).clearDataValidations()
    
    
    // set the indirect validation to the cell right to it.
    var point = current.offset(0,1)
    //get the values in the indrect column of the "Sources" sheet, get values H2 to H50. (H = the 11 colomn)
    var sources = list.getRange(2,11,50)
    var rule = SpreadsheetApp.newDataValidation().requireValueInRange(sources,true).build();
    
    // clear content
    point.clearContent();
    point.setDataValidation(rule)
    
    
  }
    
}