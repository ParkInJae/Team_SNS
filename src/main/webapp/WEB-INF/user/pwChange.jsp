<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String uid = request.getParameter("uid");
String uemail = request.getParameter("uemail");
System.out.println("pwChange uid:" + uid +", uemail:" + uemail);
%>
<!-- 웹페이지 본문 -->
<div>
    <div class="user_title" id="findIdPw">
        <a id="findId" onclick="findPage('findId');" style="color:gray;">
            아이디찾기
        </a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a id="findPw"  onclick="findPage('findPw');">
            비밀번호찾기
        </a>
    </div>
    <div class="user_inner">
        <form action="<%= request.getContextPath() %>/user/pwChange.do" method="post">
            <input type="hidden" name="uid" id="pUid" value="<%= uid %>">
            <input type="hidden" name="uemail" id="pUemail" value="<%= uemail %>">
            <table>
                <tr>
                    <td>
                        <div class="input-container">
                            <i class="fas fa-lock" id="pw_tag"></i>
                            <input type="password" name="upw" id="pUpw" size="50" placeholder="비밀번호">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="input-container">
                            <i class="fas fa-lock" id="pwc_tag"></i>
                            <input type="password" name="pUpwCheck" size="50" id="pUpwcheck" placeholder="비밀번호 확인">
                        </div>
                    </td>
                </tr>
                <tr>
	               	<td style="text-align: center;">
	                   	<span class="msg" style="color:green;"></span>
	               	</td>
	            </tr>
                <tr>
                    <td>
                        <button type="button" class="userBtn" onclick="DoChange();">비밀번호 재설정</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>