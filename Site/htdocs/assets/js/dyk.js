var currentTip = 0;
var tipMax;
var tips = null;
$(document).ready(function(){
	initDYK(false);
});

function initDYK(o){	//TODO Create and read in an XML file to provide the text for the Did You Know elements...
	setTipMax();
	var co = $.cookie("DYK");
	if(co && !o){
		tips = $("#dyk-box,#dyk-shadow").remove();
		return;
	} 
	var randomnumber=Math.floor(Math.random()*tipMax);
	setCurrent(randomnumber);
	$("#dyk-box input#close").click(function(){
		dykClose();
	});
	
	$("#dyk-box input#previous").click(function(){ prevTip()});
	$("#dyk-box input#next").click(function(){ nextTip()});

	$("div#dyk-box").resizable({
		minWidth: 405,
		minHeight: 106,
		alsoResize: '#dyk-shadow,#dyk-text'
	});
	$("div#dyk-shadow").resizable();

	$("div#dyk-box").draggable({
		handle: ".dragHandle",
/*		drag: function(e, u){
			var lef = $(this).css('left');
			var to = $(this).css('top');
			lef = parseInt(lef.split("px")[0]) - 3;
			to = parseInt(to.split("px")[0]) + 3;
			$("div#dyk-shadow").css({
				top: to + "px",
				left: lef + "px"
			});
		}*/
		start:function(e,ui){
			$("#dyk-shadow").hide();
		},
		stop:function(e,ui){
			var lef = $(this).css('left');
			var to = $(this).css('top');
			lef = parseInt(lef.split("px")[0]) - 3;
			to = parseInt(to.split("px")[0]) + 3;
			$("div#dyk-shadow").css({
				top: to + "px",
				left: lef + "px"
			});
			$("#dyk-shadow").show();
		}
	});
}

function setTipMax(){
	tipMax = $("#dyk-box span[id^='tip_']").length + 1;
}

function setCount(){
	$("#dyk-count").text(currentTip + " of " + (tipMax - 1));
}

function displayCurrent(){
	if(currentTip > 0 && currentTip < tipMax )
		$("#dyk-box div#dyk-text").html($("#dyk-box span#tip_" + currentTip).html());
	else {
		if(currentTip < 1)
			currentTip = tipMax - 1;
		else
			currentTip = 1;
		$("#dyk-box div#dyk-text").html($("#dyk-box span#tip_" + currentTip).html());
	}
	setCount();
}

function setCurrent(tipnum){
	currentTip = tipnum;
	displayCurrent();
}

function nextTip(){
	currentTip = parseInt(currentTip) + 1;
	displayCurrent();
}

function prevTip(){
	currentTip = parseInt(currentTip) - 1;
	displayCurrent();
}

function dykOpen(){
//	$(tips[0]).find("input#stay-closed-check").attr("disabled",true);
	$("div.innertube").append(tips[0]);
	$("div.innertube").append(tips[1]);
	initDYK(true);
}

function dykClose(){
	var ex = $("div#dyk-box input#stay-closed-check").attr("checked");
	setDYKCookie(ex);
	tips = $("#dyk-box,#dyk-shadow").remove();
}

function setDYKCookie(expire){
	if(expire)
		$.cookie("DYK","true",{path: '/',expires: 300});
	else
		$.cookie("DYK","true",{path: '/'});
}