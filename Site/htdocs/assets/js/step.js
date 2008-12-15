$("#diagram").ready(function(){
	$("div.diagram:first div.venn:last span.resultCount a").click();
});

var openDetail = null;

function showDetails(det){
	openDetail = $(det).parent().parent().find("h3 div.crumb_details");
//	det.addClass("jqDnR");
//	det.find(".crumb_menu").addClass("dragHandle");
//	det.jqDrag(".crumb_menu");
	var parent = openDetail.parent().parent();
	var diagram = parent.parent();
	var disp = openDetail.attr("disp");
	$("#Strategies").children("div.crumb_details").each(function(){
		$(this).remove();	
	});
	$("div.crumb_details", diagram).each(function(){
		$(this).attr("disp","0");
	})
	
	if(disp == "0"){
		openDetail.attr("disp","1");
		var det2 = openDetail.clone();
		l = parent.css("left");
		t = parent.css("top");
		l = l.substring(0,l.indexOf("px"));
		t = t.substring(0,t.indexOf("px"));
		l = parseInt(l) + 58;
		t = parseInt(t) + 235;
		det2.css({
			left: l + "px",
			top: t + "px",
			display: "block"
		});
		det2.appendTo("#Strategies");
	}
	else{
		openDetail.attr("disp","0");
	}
}

function hideDetails(det){
	openDetail.attr("disp","0");
	openDetail = null;
	
	$("#Strategies").children("div.crumb_details").each(function(){
		$(this).remove();	
	});
}

function Edit_Step(ele,url){
		$(ele).parent().parent().hide();
		var link = $(".filter_link");
		$(link).css({opacity:0.2});
		$(link).attr("href","javascript:void(0)");
		hideDetails();
		var revisestep = $(ele).attr("id");
		var parts = revisestep.split("|");
		var strat = parts[0];
		revisestep = parseInt(parts[1]);
		var operation = parts[2];
		var reviseStepNumber = strat + ":" + revisestep + ":0:0:" + operation;
		$.ajax({
			url: url,
			dataType: "html",
			success: function(data){
				formatFilterForm(data,1,reviseStepNumber);
			},
			error: function(data, msg, e){
				alert("ERROR \n "+ msg + "\n" + e);
			}
		});
		$(this).parent().parent().hide();
}

function Insert_Step(ele,url){
	$(ele).parent().parent().hide();
	var sNumber = $(ele).attr("id");
	sNumber = sNumber.split("|");
	openFilter(sNumber[0] + ":" + sNumber[1]);
}

function Rename_Step(ele){
	$(ele).parent().parent().hide();
	var link = $(ele).parent().parent().parent().find("a:first");
	link.html("<input id='new_name_box' type='text' value='"+link.text()+"' onblur='RenameStep(this)' onfocus='this.select()' onkeypress='blah(this,event)' size='10'/>");
	$("#new_name_box").focus();
}

function RenameStep(ele){
	var a = $(ele).parent();
	var new_name = $(ele).val();
	var x = $(ele).parent().attr("id");
	x = x.substring(7);
	var url = "renameStep.do?stepId=" + x + "&customName=" + new_name;	
	if(new_name.length > 14)
		new_name = new_name.substring(0,12) + "...";	
	$.ajax({
			url: url,
			dataType: "html",
			success: function(data){
				a.text(new_name);
			},
			error: function(data, msg, e){
				alert("ERROR \n "+ msg + "\n" + e);
			}
		});
}

function Expand_Step(ele, url){
	$(ele).parent().parent().hide();
	ExpandStep(url);
}

// Utility Functions

function blah(ele,evt){
	var charCode = (evt.which) ? evt.which : evt.keyCode;
	if(charCode == 13) $(ele).blur();
}

function parseUrl(name,url){
 	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
 	var regexS = "[\\?&]"+name+"=([^&#]*)";
 	var regex = new RegExp( regexS,"g" );
 	var res = new Array();
 	//while (regex.lastIndex < url.length){
 		var results = regex.exec( url );
 		if( results != null )
 			res.push(results[1]);
 	//	else
 	//		break;
 	//}
 	if(res.length == 0)
 		return "";
 	else
 		return res;
}


