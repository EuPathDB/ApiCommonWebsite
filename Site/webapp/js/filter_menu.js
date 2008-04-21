
$(document).ready(function(){
	$("#filter_div").hide();
	$("#query_form").hide();
	
	$(".top_nav ul li a").click(function(){
		
		var url = $(this).attr("href");
		//$.get(url, function(data){
		//		$("#query_form").html(data);
		//	}
		//);
		$.ajax({
			url: url,
			dataType:"html",
			//beforeSend: function(req){
			//	alert("AJAX CALL BEING MADE!!!");
			//},
			success: function(data){
				var historyId = $("#history_id").val();
				var close_link = "<a id='close_filter_query' href='javascript:close()'>close[x]</a>";
				var quesTitle = $("b font[size=+3]",data).parent().text().replace(/Identify Genes based on/,"");
				var quesForm = $("form",data);

				$("input[value=Get Answer]",quesForm).val("Run Filter");

				$("table:first",quesForm).prepend("<tr><td valign='top' align='right'><b>Operator</b></td><td><input type='radio' name='myProp(booleanExpression)' value='" + historyId + " AND' checked='checked'/>&nbsp;AND&nbsp;<input type='radio' name='myProp(booleanExpression)' value='" + historyId + " OR'>&nbsp;OR&nbsp;<input type='radio' name='myProp(booleanExpression)' value='" + historyId + " NOT'>&nbsp;NOT&nbsp</td></tr>");

				var action = quesForm.attr("action").replace(/processQuestion/,"processFilter");

				quesForm.prepend("<span id='question_title'>" + quesTitle + " Filter</span><br>");
				
				quesForm.attr("action",action);
				$("#query_form").html(close_link);
				$("#query_form").append(quesForm);
				$("#query_form").show();
			},
			error: function(data, msg, e){
				alert("ERROR \n "+ msg + "\n" + e);
			}
		});
		$("#instructions").text("Choose an operation and fill in the parameters of your query then click run filter to see a new reuslts page with your filtered results.");
		return false;
	});
	
	$("#filter_link").click(function(){;
		if($(this).text() == "Create Filter"){
			$("#filter_div").fadeIn("normal");
			$(this).text("Cancel [X]");
	}else{
			$("#filter_div").fadeOut("normal");
			$(this).text("Create Filter");
	}
	});
	
});

function close(){
	$("#query_form").hide();
}
