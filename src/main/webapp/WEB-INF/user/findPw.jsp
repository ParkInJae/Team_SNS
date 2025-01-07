<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!--웹페이지 본문-->
<div>
	<div class="user_title">
		<a id="findId" onclick="findPage('findId');" style="color:gray;">
			아이디찾기
		</a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a id="findPw"  onclick="findPage('findPw');">
			비밀번호찾기
		</a>
    </div>
	<div class="user_inner">
		<form action="findPw.do" method="post">
		<table>
			<tr>
				<td>
					<div class="user-container">
                           <i class="fas fa-user" id="user_itag7"></i>
                           <input type="text" name="uid" id="find_uid" placeholder="아이디">
	           		</div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="user-container">
		               <i class="fas fa-envelope" id="user_itag6"></i>
		          	   <input type="email" name="uemail" id="uemail" placeholder="이메일">
		          	   <button type="button" class="usersBtn" id="emailBtn" onclick="SendMail();">인증하기</button>
		            </div>
				</td>
			</tr>
			<tr>
				<td>
					<div class="user-container">
		              	<i class="fas fa-check" id="user_itag9"></i>
						<input type="text" id="code" name="code" placeholder="인증코드 확인">
						<button type="button" class="usersBtn" onclick="DoEmail();">인증확인</button>
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
					<input  class="userBtn"  type="button" value="비밀번호찾기" onclick="findPage('findPwOk');">
				</td>
			</tr>
		</table>
		</form>
	</div>
</div>