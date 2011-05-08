SyntaxHighlighter.brushes.Clojure = function()
{
	// Contributed by Kibleur Christophe.
	
	var keywords =	'break continue dropping return launch from global const self sender catch raise ' +
	        'give case default pass lambda def directive load export enum ' +
	        'try switch select object print printl ';
	        
	var entities = 'class defn def init static '
	        
	var kw = 'while loop for forfirst formiddle forlast end if elif else if break';

	var builtins =	'and or not in notin to as has hasnt provides nil Error TraceStep ' +
	                'SyntaxError CodeError RangeError MathError IoError TypeError ' +
	                'ParamError ParseError CloneError InterruptedError List all any ' +
	                'allp anyp eval choice xmap iff lit cascade dolist eq ';
	                
	var fct = /(?:\()(\w)*(?:.*\))/gm ;
	                
	this.regexList = [
		{ regex: /\+\+|\+|\-|\*|\.|\^|:|\[|\]|\%|==|&gt;|\=&lt;|&lt;|=|\{|\}|,/gm, css: 'operator' }, // operators
		{ regex: /;.*/g,                                        css: 'comments' },	                        // one line comments
		{ regex: /"(?:\.|(\\\")|[^\"])*"/gm,                    css: 'string' },                            // "string"
		{ regex: /\b[A-Z0-9_]+\b/g,								css: 'constants' },                         // constants
		{ regex: /:[a-z][A-Za-z0-9_]*/g,						css: 'color2' },                            // symbols
		{ regex: new RegExp(this.getKeywords(keywords), 'gm'),	css: 'keyword' },                           // keywords
		{ regex: new RegExp(this.getKeywords(kw), 'gm'),		css: 'value' },	                            // keyword
		{ regex: new RegExp(this.getKeywords(entities), 'gm'),	css: 'preprocessor' },                      // entities
		{ regex: new RegExp(this.getKeywords(builtins), 'gm'),	css: 'color1' },                            // builtins
		{ regex: fct,	                                        css: 'color2' },                            // builtins
		];

	this.forHtmlScript(SyntaxHighlighter.regexLib.aspScriptTags);
};

SyntaxHighlighter.brushes.Clojure.prototype	= new SyntaxHighlighter.Highlighter();
SyntaxHighlighter.brushes.Clojure.aliases		= [ 'clj'];
