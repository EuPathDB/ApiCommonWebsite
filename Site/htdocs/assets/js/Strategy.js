function Strategy(frontId, backId, isDisplay){
	this.frontId = frontId;
	this.backId = backId;
	this.isDisplay = false;
}
Strategy.prototype.Steps = new Array();

function Step(frontId, back_step_Id, back_boolean_Id, child_Strat_Id){
	this.frontId = frontId;
	this.back_step_Id = back_step_Id;
	this.back_boolean_Id = back_boolean_Id;
	this.child_Strat_Id = null;
}
Step.prototype.isboolean = false;
Strategy.prototype.initSteps = function(steps){
	var f_index = 0;
	var arr = new Array();
	$(steps).each(function(){
		if($(this).attr("isboolean") == "false"){
			var bbid = "";
			if(this.parentNode.nodeName == "step")
				bbid = $(this).parent().attr("id");
			var s = new Step(f_index, $(this).attr("id"), bbid, "");
			arr.push(s);
			f_index++;
		}
	});
	this.Steps = arr;
}
	
function getDataType(ele){
	var s = "";
	if(parseInt($(ele).attr("results")) > 1)
		s = "s"
	var cl = $(ele).attr("dataType");
	if(cl == "GeneRecordClasses.GeneRecordClass")
		return "Gene" + s;
}

