<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sns.vo.*" %>
<%@ page import="java.util.*" %>
<%	
	UserVO vo = (UserVO)request.getAttribute("vo");
	String uno = "";
	
	if(request.getAttribute("vo") != null){
		uno = vo.getUno();
	}
	
%>

<script>
	var flag = false;
	function call(){
		var msgbox = document.querySelector("#msgbox");
		console.log(msgbox);
		
		$.ajax({
			url:"<%= request.getContextPath() %>/WEB-INF/user/checkMSG.do",
			type:"get",
			data: {"uno" : "<%= vo.getUno() %>"},
			dataType: "text",
			success: function(response){
				console.log(response.trim());
				var count = parseInt(response.trim());
				if(count>0){
					msgbox.innerHTML = "<span style='color:red;'>"+count+"</span>"
				}else{
					msgbox.innerHTML = ""
				}
			}
		});
	}
	
	window.onload = function (){
		var loginUser = "<%= uno %>";
		if( loginUser != ""){
			const timer = setInterval(call, 1000);
		}
	}
</script>