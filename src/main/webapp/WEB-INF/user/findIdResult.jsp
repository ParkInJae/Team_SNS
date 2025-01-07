<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%
List<String> idList = (List<String>) request.getAttribute("idList");
boolean isIdListEmpty = (idList == null || idList.isEmpty());
%>
<!--웹페이지 본문-->
<div>
    <div class="user_title" id="findIdPw">
        <a id="findId" onclick="findPage('findId');">
            아이디찾기
        </a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <a id="findPw" onclick="findPage('findPw');" style="color:gray;">
            비밀번호찾기
        </a> 
    </div>
    <div class="user_inner">
        <h3>조회결과</h3>
        <table>
            <%
            if (!isIdListEmpty) {
                for (String uid : idList) {
            %>
            <tr>
                <td>
                    <div class="user-container">
                        <i class="fas fa-user" id="user_itag7"></i>&nbsp;
                        <span id="login_uid"><%= uid %></span>
                    </div>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td>
                    <div class="user-container">
                        <i class="fas fa-user" id="user_itag7"></i>&nbsp;
                        <span id="login_uid">아이디가 존재하지 않습니다</span>
                    </div>
                </td>
            </tr>
            <%
            }
            %>
            <tr>
                <td>
                    <input class="userBtn" type="button" value="비밀번호찾기" onclick="findPage('findPw');">
                </td>
            </tr>
        </table>
    </div>
</div>