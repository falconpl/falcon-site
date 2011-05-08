/**
 * Removes highlight of all elements of some form on the page.
 *
 * @param string name - The name of the form element to unhightlight.
 */
function unhighliteForm(name) {
	var elems = document.forms[name].elements;
	len = elems.length
	for (i = 0; i < len; ++i) {
		$(elems).removeClass('highliteFormElement');
	}
}

/**
 * Highlight a form element on the page.
 *
 * @param  string name - The name of the form element to hightlight.
 * @return nil
 */
function highliteFormElement(name) {
	// Iterate throught the page's forms.
	var flength = document.forms.length;
	for (i = 0; i < flength; ++i) {
		var elems = document.forms[i].elements;
		// Iterate throught the current form's elements.
		var elength = elems.length;
		for (j = 0; j < elength; ++j) {
			if (elems[j].name == name) {
				elems[j].className = 'highliteFormElement'
				return;
			}
		}
	}
}


