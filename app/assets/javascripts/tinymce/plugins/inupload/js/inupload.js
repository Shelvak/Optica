tinyMCEPopup.requireLangPack();

var ExampleDialog = {
	init : function() {
		var f = document.forms[0];

		// Get the selected contents as text and place it in the input
		f.someval.value = tinyMCEPopup.editor.selection.getContent({format : 'text'});
		f.somearg.value = tinyMCEPopup.getWindowArg('some_custom_arg');
	},

	insert : function() {
		// Insert the contents from the input into the document
		tinyMCEPopup.editor.execCommand('mceInsertContent', false, document.forms[0].someval.value);
		tinyMCEPopup.close();
	}
};

tinyMCEPopup.onInit.add(ExampleDialog.init, ExampleDialog);

function ClosePluginPopup (strReturnURL) {
    var win = tinyMCEPopup.getWindowArg("window");                                          // insert information now
    if (!win)
        tinyMCE.activeEditor.execCommand('mceInsertContent', false, strReturnURL);
    else
    {
        win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = strReturnURL;	
	    if (typeof(win.ImageDialog) != "undefined")                                             // are we an image browser
	    {		
		    if (win.ImageDialog.getImageData) win.ImageDialog.getImageData();                   // we are, so update image dimensions and preview if necessary
		    if (win.ImageDialog.showPreviewImage) win.ImageDialog.showPreviewImage(strReturnURL);
	    }	
	}
	tinyMCEPopup.close();	                                                                    // close popup window
}
