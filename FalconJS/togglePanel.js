function returnObjById( id )
{
    if (document.getElementById)
        var returnVar = document.getElementById(id);
    else if (document.all)
        var returnVar = document.all[id];
    else if (document.layers)
        var returnVar = document.layers[id];
    return returnVar;
}

var oldText;
function togglePanel( panelID, buttonID )
{
   panel = returnObjById( panelID );
   if ( buttonID.length )
      button = returnObjById( buttonID );

   if( panel.style.display == "none" )
   {
      panel.style.display = "block";
      if ( buttonID.length )
      {
         oldText = button.value;
         button.value = "Hide";
      }
   }
   else {
      if ( buttonID.length )
      {
         button.value = oldText;
      }
      panel.style.display = "none";
   }
}
