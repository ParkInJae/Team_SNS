<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div>
    <div class="user_title">
		<a>회원가입</a>
    </div>
    <div class="user_inner">
        <form action="join.do" method="post" id="joinFn" enctype="multipart/form-data">
			<table>
          	    <tr>
                   <td>
                       <div class="user-container">
                           <i class="fas fa-user" id="user_itag1"></i>
                           <input type="text" name="uid" id="uid" placeholder="아이디">
                       </div>
                   </td>
               </tr>
               <tr>
                   <td>
                       <div class="user-container">
                           <i class="fas fa-lock" id="user_itag2"></i>
                           <input type="password" name="upw" id="upw" placeholder="비밀번호">
                       </div>
                   </td>
               </tr>
               <tr>
                   <td>
                       <div class="user-container">
                           <i class="fas fa-check" id="user_itag3"></i>
                      		<input type="password" name="upwcheck" id="upwcheck" placeholder="비밀번호확인">
                       </div>
                   </td>
               </tr>
               <tr>
                   <td>
                       <div class="user-container">
                           <i class="fas fa-user" id="user_itag4"></i>
                     	   <input type="text" name="unick" id="unick" placeholder="닉네임">
                       </div>
                   </td>
               </tr>
               <tr>
                   <td>
                       <div class="user-container">
                   			<i class="fas fa-camera" id="user_itag5"></i> 
                            <div class="profil">
                                <label for="file">
                               	 <input class="upload-name" value="프로필이미지" placeholder="프로필이미지" readonly>
                                 <input type="file" id="file" name="fname" onchange="readURL(this);">
                                </label>
                            </div>
                            <img id="preview" class="circular-img"
                            style="max-width:150px; max-height:150px; border-radius:50%;" />
                            <!-- 첨부파일 삭제 여부 체크박스 추가 -->
                               <div class="deleteFile" style="margin-left:10px;">
                          	 <input type="checkbox" name="deleteFile" value="Y" id="deleteFile">
                          	 <label for="deleteFile"><i class="fas fa-solid fa-circle-xmark"></i></label>
                            </div>
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
                    <td style="text-align: center;">
                        <button type="button" class="userBtn" id="joinBtn" onclick="DoJoin();">가입하기</button>
                        <button type="reset"  class="userBtn">취소</button>
                    </td>
                </tr>
            </table>	
		</form>
    </div>
</div>