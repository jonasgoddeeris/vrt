function onEdit() {
  // the current sheet and cell 
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var current = sheet.getActiveCell()
  
  // var to refer to the worksheets
  //var vrtnu = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("vrtNU"); (GENERIEK GEMAAKT)
  var list = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Sources");
  
  // which medium has the user selected (based on active cell if column number is 4)?
  if (current.getColumn()==4)
    {
    //copy the selected medium from any (utm) file  
      var medium = current.getValue()
    //into the sources file as a dynamic indirect generator
      list.getRange(2,12).setValue(medium)
        
    //clear any validation
    sheet.getRange(8,5,468).clearDataValidations()
      
    // set the indirect validation to the cell right to it.
    var point = current.offset(0,1)

    //get the values in the indrect column of the "Sources" sheet, get values H2 to H50. (H = the 11 colomn)
    var sources = list.getRange(2,11,50)

    //build a dataValdiation rule based on sources mathcing the selected medium
    var rule = SpreadsheetApp.newDataValidation().requireValueInRange(sources,true).build();
    
    // clear content
    point.clearContent();
    point.setDataValidation(rule)

    }
}