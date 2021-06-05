<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="${contextPath}/resources/jquery/jquery-3.5.1.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>

	var frm_mod_member = document.frm_mod_member;
	var h_tel1         = frm_mod_member.tel1;
	var h_hp1          = frm_mod_member.hp1;
	var tel1           = h_tel1.value;
	var hp1            = h_hp1.value;
	var select_tel1    = frm_mod_member.tel1;
	var select_hp1     = frm_mod_member.hp1;
	select_tel1.value  = tel1;
	select_hp1.value   = hp1;
	
	function fn_modify_member_info(memberId,modType){
		var value;
		var frm_mod_member = document.frm_mod_member;
		
		if (modType == 'memberPw') {
			value = frm_mod_member.memberPw.value;
		} 
		else if (modType == 'memberName') {
			value = frm_mod_member.memberName.value;
		} 
		else if (modType == 'memberGender'){
			var memberGender = frm_mod_member.memberGender;
			for (var i=0; memberGender.length;i++){
			 	if (memberGender[i].checked){
					value = memberGender[i].value;
					break;
				} 
			}
		}
		else if (modType == 'memberBirth'){
			var memberBirthY = frm_mod_member.memberBirthY;
			var memberBirthM = frm_mod_member.memberBirthM;
			var memberBirthD = frm_mod_member.memberBirthD;
			var memberBirthGn = frm_mod_member.memberBirthGn;
			
			for (var i=0; memberBirthY.length;i++){
			 	if (memberBirthY[i].selected){
					value_y = memberBirthY[i].value;
					break;
				} 
			}
			
			for (var i=0; memberBirthM.length;i++){
			 	if (memberBirthM[i].selected){
					value_m = memberBirthM[i].value;
					break;
				} 
			}
			
			for (var i=0; memberBirthD.length;i++){
			 	if (memberBirthD[i].selected){
					value_d = memberBirthD[i].value;
					break;
				} 
			}
			
			for (var i=0; memberBirthGn.length;i++){
			 	if (memberBirthGn[i].checked){
					value_gn = memberBirthGn[i].value;
					break;
				} 
			}
			value = value_y + "," + value_m + "," + value_d + "," + value_gn;
		}
		else if (modType=='tel'){
			var tel1 = frm_mod_member.tel1;
			var tel2 = frm_mod_member.tel2;
			var tel3 = frm_mod_member.tel3;
			
			for (var i=0; tel1.length;i++){
			 	if (tel1[i].selected){
					value_tel1=tel1[i].value;
					break;
				} 
			}
			value_tel2=tel2.value;
			value_tel3=tel3.value;
			
			value = value_tel1 + "," + value_tel2 + ", " + value_tel3;
		}
		else if (modType == 'hp'){
			var hp1 = frm_mod_member.hp1;
			var hp2 = frm_mod_member.hp2;
			var hp3 = frm_mod_member.hp3;
			var smsstsYn = frm_mod_member.smsstsYn;
			
			for (var i=0; hp1.length;i++){
			 	if (hp1[i].selected){
					value_hp1 = hp1[i].value;
					break;
				} 
			}
			value_hp2 = hp2.value;
			value_hp3 = hp3.value;
			if (smsstsYn.checked)	value_smsstsYn = "Y";
			else					value_smsstsYn = "N";
			
			
			value = value_hp1 + "," + value_hp2 + ", " + value_hp3 + "," + value_smsstsYn;
			
		}
		else if (modType == 'email') {
			var email1 = frm_mod_member.email1;
			var email2 = frm_mod_member.email2;
			var emailstsYn = frm_mod_member.emailstsYn;
			
			value_email1 = email1.value;
			value_email2 = email2.value;
			if (emailstsYn.checked)	value_emailstsYn = "Y";
			else					value_emailstsYn = "N";
			
			value=value_email1+","+value_email2+","+value_emailstsYn;
		}
		else if(modType == 'address'){
			var zipcode       =	frm_mod_member.zipcode;
			var roadAddress   = frm_mod_member.roadAddress;
			var jibunAddress  = frm_mod_member.jibunAddress;
			var namujiAddress = frm_mod_member.namujiAddress;
			
			value_zipcode       = zipcode.value;
			value_roadAddress   = roadAddress.value;
			value_jibunAddress  = jibunAddress.value;
			value_namujiAddress = namujiAddress.value;
			
			value = value_zipcode + "," + value_roadAddress + "," + value_jibunAddress + "," + value_namujiAddress;
		}
	 
		$.ajax({
			type : "post",
			url : "${contextPath}/admin/member/modifyMemberInfo.do",
			data : {
				memberId : memberId,
				modType  : modType,
				value    : value
			},
			success : function() {
				alert("회원 정보를 수정했습니다.");
			}
		}); 
	}
	
	function fn_delete_member(memberId ,delYn) {
	    location.href="${contextPath}/admin/member/deleteMember.do?memberId=" + memberId + "&delYn=" + delYn;
	}
	
</script>
<script>

 function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var fullRoadAddr = data.roadAddress; 
                var extraRoadAddr = ''; 

                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                if (data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if (extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                if (fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                document.getElementById('zipcode').value = data.zonecode; 
                document.getElementById('roadAddress').value = fullRoadAddr;
                document.getElementById('jibunAddress').value = data.jibunAddress;

                if (data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } 
                else if (data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } 
                else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }
</script>
<link href="${contextPath}/resources/css/myStyle.css" rel="stylesheet" />
</head>

<body>
	<h3>회원 상세 정보</h3>
	<form name="frm_mod_member">	
		<table class="table table-bordered table-hover">
				<tr>
					<td align="center">
						<label for="memberId">아이디</label>
					</td>
					<td>
						<input name="memberId" id="memberId" type="text" class="form-control"  value="${memberInfo.memberId}"  disabled/>
					</td>
					 <td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  disabled onClick="fn_modify_member_info('${memberInfo.memberId }','memberId')" />
					</td>
				</tr>
				<tr>
					<td align="center">비밀번호</td>
					<td>
					  <input name="memberPw" type="password" class="form-control" value="${memberInfo.memberPw }" />
					</td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','memberPw')" />
					</td>
				</tr>
				<tr>
					<td align="center">이름</td>
					<td>
					  <input name="memberName" type="text" class="form-control" value="${memberInfo.memberName }"  />
					 </td>
					 <td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_member_info('${memberInfo.memberId }','memberName')" />
					</td>
				</tr>
				<tr>
					<td align="center">성별</td>
					<td>
				   	  <input type="radio" name="memberGender" class="custom-control-input" value="101" <c:if test="${memberInfo.memberGender eq '101' }">checked </c:if> />
				   	  <label class="custom-control-label" for="g1">남성</label>&emsp;&emsp;&emsp;
				      <input type="radio" name="memberGender" class="custom-control-input" value="102" <c:if test="${memberInfo.memberGender eq '102' }">checked </c:if> />
					  <label class="custom-control-label" for="g2">여성</label>
					</td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','memberGender')" />
					</td>
				</tr>
				<tr>
					<td align="center">생년월일</td>
					<td>
					   <select class="form-control" name="memberBirthY" style="display:inline; width:70px; padding:0">
					     <c:forEach var="i" begin="1" end="100">
					       <c:choose>
					         <c:when test="${memberInfo.memberBirthY==1920+i }">
							   <option value="${ 1920+i}" selected>${ 1920+i} </option>
							</c:when>
							<c:otherwise>
							  <option value="${ 1920+i}" >${ 1920+i} </option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>년 
					<select class="form-control"  name="memberBirthM" style="display:inline; width:70px; padding:0">
						<c:forEach var="i" begin="1" end="12">
					       <c:choose>
					         <c:when test="${memberInfo.memberBirthM==i }">
							   <option value="${i }" selected>${i }</option>
							</c:when>
							<c:otherwise>
							  <option value="${i }">${i }</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>월 
					
					<select class="form-control" name="memberBirthD" style="display:inline; width:70px; padding:0">
							<c:forEach var="i" begin="1" end="31">
					       <c:choose>
					         <c:when test="${memberInfo.memberBirthD==i }">
							   <option value="${i }" selected>${i }</option>
							</c:when>
							<c:otherwise>
							  <option value="${i }">${i }</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>일 
					
					   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   <c:choose>
					    <c:when test="${memberInfo.memberBirthGn=='2' }"> 
					  <input type="radio" name="memberBirthGn" value="2" checked /> 양력
						&nbsp;&nbsp;&nbsp; 
						<input type="radio"  name="memberBirthGn" value="1" /> 음력
						</c:when>
						<c:otherwise>
						  <input type="radio" name="memberBirthGn" value="2" /> 양력
						   &nbsp;&nbsp;&nbsp; 
						<input type="radio"  name="memberBirthGn" value="1" checked  /> 음력
						</c:otherwise>
						</c:choose>
					</td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','memberBirth')" />
					</td>
				</tr>
				<tr>
					<td align="center">전화번호</td>
					<td>
					    <select class="form-control" name="tel1" style="display:inline; width:70px; padding:0">
							<option>없음</option>
							<option <c:if test="${memberInfo.tel1 eq '02'}"> selected </c:if> value="02">02</option>
							<option <c:if test="${memberInfo.tel1 eq '031'}"> selected </c:if> value="031">031</option>
							<option <c:if test="${memberInfo.tel1 eq '032'}"> selected </c:if> value="032">032</option>
							<option <c:if test="${memberInfo.tel1 eq '033'}"> selected </c:if> value="033">033</option>
							<option <c:if test="${memberInfo.tel1 eq '041'}"> selected </c:if> value="041">041</option>
							<option <c:if test="${memberInfo.tel1 eq '042'}"> selected </c:if> value="042">042</option>
							<option <c:if test="${memberInfo.tel1 eq '043'}"> selected </c:if> value="043">043</option>
							<option <c:if test="${memberInfo.tel1 eq '044'}"> selected </c:if> value="044">044</option>
							<option <c:if test="${memberInfo.tel1 eq '051'}"> selected </c:if> value="051">051</option>
							<option <c:if test="${memberInfo.tel1 eq '052'}"> selected </c:if> value="052">052</option>
							<option <c:if test="${memberInfo.tel1 eq '053'}"> selected </c:if> value="053">053</option>
							<option <c:if test="${memberInfo.tel1 eq '054'}"> selected </c:if> value="054">054</option>
							<option <c:if test="${memberInfo.tel1 eq '055'}"> selected </c:if> value="055">055</option>
							<option <c:if test="${memberInfo.tel1 eq '061'}"> selected </c:if> value="061">061</option>
							<option <c:if test="${memberInfo.tel1 eq '062'}"> selected </c:if> value="062">062</option>
							<option <c:if test="${memberInfo.tel1 eq '063'}"> selected </c:if> value="063">063</option>
							<option <c:if test="${memberInfo.tel1 eq '064'}"> selected </c:if> value="064">064</option>
							<option <c:if test="${memberInfo.tel1 eq '070'}"> selected </c:if> value="070">070</option>
					</select> 
					    - <input type="text" class="form-control"  name="tel2" value="${memberInfo.tel2 }" style="display:inline; width:70px; padding:0"> 
					    - <input type="text" class="form-control"  name="tel3" value="${memberInfo.tel3 }" style="display:inline; width:70px; padding:0">
					</td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','tel')" />
					</td>
				</tr>
				<tr>
					<td align="center">핸드폰 번호</td>
					<td>
					   <select class="form-control" name="hp1" style="display:inline; width:70px; padding:0">
							<option>없음</option>
							<option  <c:if test="${memberInfo.hp1 eq '010'}"> selected </c:if> value="010">010</option>
							<option <c:if test="${memberInfo.hp1 eq '011'}"> selected </c:if> value="011">011</option>
							<option <c:if test="${memberInfo.hp1 eq '016'}"> selected </c:if> value="016">016</option>
							<option <c:if test="${memberInfo.hp1 eq '017'}"> selected </c:if> value="017">017</option>
							<option <c:if test="${memberInfo.hp1 eq '018'}"> selected </c:if> value="018">018</option>
							<option <c:if test="${memberInfo.hp1 eq '019'}"> selected </c:if> value="019">019</option>
					</select> 
					 - <input type="text" name="hp2" class="form-control" value="${memberInfo.hp2 }" style="display:inline; width:70px; padding:0"> 
					 - <input type="text"name="hp3" class="form-control" value="${memberInfo.hp3 }" style="display:inline; width:70px; padding:0"><br>
					 <br>
					 <c:choose> 
					   <c:when test="${memberInfo.smsstsYn eq 'Y' }">
					     <input type="checkbox" class="custom-control-input" name="smsstsYn" id="smsstsYn" value="Y" checked /> 
					     <label for="smsstsYn" >BMS에서 발송하는 SMS 소식을 수신합니다.</label>
						</c:when>
						<c:otherwise>
						  <input type="checkbox" class="custom-control-input" name="smsstsYn" id="smsstsYn" value="N"  /> 
						  <label for="smsstsYn" >BMS에서 발송하는 SMS 소식을 수신합니다.</label>
						</c:otherwise>
					 </c:choose>	
				    </td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','hp')" />
					</td>	
				</tr>
				<tr>
					<td align="center">이메일(e-mail)</td>
					<td>
					   <input type="text" class="form-control" name="email1" value="${memberInfo.email1 }" style="display:inline; width:100px; padding:0"/> @ 
					   <input type="text" class="form-control"  name="email2" value="${memberInfo.email2 }" style="display:inline; width:100px; padding:0"/> 
					   <select name="select_email2" class="form-control"  onChange=""  title="직접입력" style="display:inline; width:100px; padding:0">
						 <option value="" <c:if test="${email3 eq 'none'}"> selected</c:if>>직접입력</option>
						 <option value="gmail.com" <c:if test="${email3 eq 'gmail.com'}"> selected</c:if>>gmail.com</option>
						 <option value="naver.com" <c:if test="${email3 eq 'naver.com'}"> selected</c:if>>naver.com</option>
						 <option value="daum.net" <c:if test="${email3 eq 'daum.net'}"> selected</c:if>>daum.net</option>
						 <option value="nate.com" <c:if test="${email3 eq 'nate.com'}"> selected</c:if>>nate.com</option>
					</select><br><br>  
					<c:choose> 
					   <c:when test="${memberInfo.emailstsYn eq 'Y' }">
					     <input type="checkbox" class="custom-control-input" name="emailstsYn" id="emailstsYn" value="Y" checked /> 
					     <label for="emailstsYn">BMS에서 발송하는 e-mail을 수신합니다.</label>
						</c:when>
						<c:otherwise>
						  <input type="checkbox" class="custom-control-input" name="emailstsYn" id="emailstsYn" value="N"  />
						  <label for="emailstsYn">BMS에서 발송하는 e-mail을 수신합니다.</label>
						</c:otherwise>
					 </c:choose>
					</td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','email')" />
					</td>
				</tr>
				<tr>
					<td align="center">주소</td>
					<td>
					   <input type="text" id="zipcode" name="zipcode" class="form-control"  value="${memberInfo.zipcode }" size="70px" style="display:inline; width:150px; padding:0"> 
					    <input type="button" class="btn btn-outline-primary btn-sm" onclick="javascript:execDaumPostcode()" value="검색">
					  <br><br>
					  <p> 
						  지번 주소:<br><input type="text" id="roadAddress"  name="roadAddress" class="form-control" value="${memberInfo.roadAddress }"><br>
						  도로명 주소: <input type="text" id="jibunAddress" name="jibunAddress" class="form-control" value="${memberInfo.jibunAddress }"><br>
						  나머지 주소: <input type="text"  name="namujiAddress" class="form-control" value="${memberInfo.namujiAddress }" />
						   <span id="guide" style="color:#999"></span>
					   </p>
					</td>
					<td>
					  <input type="button" value="수정" class="btn btn-outline-primary btn-sm"  onClick="fn_modify_member_info('${memberInfo.memberId }','address')" />
					</td>
				</tr>
		</table>
		<p align="right">
			<input type="hidden" name="command"  value="modify_my_info" /> 
			<c:choose>
			  <c:when test="${memberInfo.delYn == 'Y' }">
			    <input type="button" value="회원복원" class="btn btn-primary btn-sm"  onClick="fn_delete_member('${memberInfo.memberId }','N')">   
			  </c:when>
			  <c:when test="${memberInfo.delYn == 'N' }">
			    <input type="button" value="회원탈퇴" class="btn btn-danger btn-sm"  onClick="fn_delete_member('${memberInfo.memberId }','Y')">
			  </c:when>
			</c:choose>
		</p>
</form>	
</body>
</html>
