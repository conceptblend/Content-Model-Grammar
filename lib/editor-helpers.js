//
// Editor_helpers.js
//
//
//

// FUNCTION: tabsToSpaces
// convert any tab to 2 spaces
//
function tabsToSpaces(str){	return str.replace(/\t/g, "  "); }

// FUNCTION: matchPreviousIndent
// keep the indents aligned when a new line is added.
// 
function matchPreviousIndent(id){
	var $src = src = document.getElementById(id),//$('#'+id),
			//src = $src.get(0),
			start = src.selectionStart-1,
			pre, middle, post, replacement;
			
	if ((typeof start === 'number')) {
		pre = src.value.substring(0, start);
		middle = src.value.substring(start, start+1);
		post = src.value.substring(start+1);
		
		// reach backwards for the last line
		var lastIndexOfPre = pre.lastIndexOf('\n');
		if (lastIndexOfPre){
			count = pre.substring(lastIndexOfPre+1).match(/^\s*/i)[0].length;
		}
		replacement = pre + middle + makeStupidSpaceString(count);	
	
		src.value = replacement + post;
		//$src.val(replacement + post);	
		
		// attempt to reset the selection points
		src.selectionEnd = src.selectionStart = replacement.length;
	}
}

// FUNCTION: makeStupidSpaceString
// create a string of 'count' spaces
//
function makeStupidSpaceString(count){ return Array(count+1).join(" "); }

// FUNCTION: InOutdentSelection
// indent or outdent the selection by 2 spaces
//
function InOutdentSelection(id, isOutdent){
	var $src = src = document.getElementById(id),//$('#'+id),
			//src = $src.get(0),
			start = src.selectionStart,
			end = src.selectionEnd,
			pre, post, replacement;

	if ((typeof start === 'number') && (typeof end === 'number') && (start !== end)) {
		pre = src.value.substring(0, start);
		middle = src.value.substring(start, end);
		post = src.value.substring(end, src.value.length);
		
		// correct selection to beginning and end of lines
		var lastIndexOfPre = pre.lastIndexOf('\n');
		if (lastIndexOfPre){
			middle = pre.substring(lastIndexOfPre+1) + middle;
			pre = pre.substring(0, lastIndexOfPre+1);
		}
		
		var indexOfPost = post.indexOf('\n');
		if (indexOfPost){
			middle = middle + post.substring(0, indexOfPost);
			post = post.substring(indexOfPost);
		}

		replacement = isOutdent ? middle.replace(/^\s{2}/gm, "") : middle.replace(/^/gm, "  ");
		
		src.value = pre + replacement + post;
		
		//$src.val(pre + replacement + post);	
		
		// attempt to reset the selection points
		src.selectionStart = pre.length;
		src.selectionEnd = (pre + replacement).length;
	}
}
