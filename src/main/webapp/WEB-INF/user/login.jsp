<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div>
    <div class="user_title">
		<a>로그인</a>
    </div>
    <div class="user_inner">
        <form action="login.do" method="post" id="loginFn" name="loginFn">
            <table>
                <tr>
                    <td>
                        <div class="user-container">
                            <i class="fas fa-user" id="user_itag7"></i>
                            <input type="text" name="uid" id="login_uid" placeholder="아이디">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="user-container">
                            <i class="fas fa-lock" id="user_itag8"></i>
                            <input type="password" name="upw" id="login_upw" placeholder="비밀번호">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="msg" style="color:green;">&nbsp;</span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <button type="button" onclick="DoLogin();" class="userBtn" id="loginBtn">로그인하기</button>
                        <br>
                        <button type="button" class="userBtn" onclick="findPage('findId');">아이디/비밀번호 찾기</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>