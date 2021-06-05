<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<script src="${contextPath}/resources/jquery/jquery-3.5.1.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>

	$().ready(function() {
	
		$("#select_email").change(function(){
			$("#email2").val($("#select_email option:selected").val());
		});
		
		$("#btnOverlapped").click(function(){
			
		    var memberId = $("#memberId").val();
		   
		    if (memberId==''){
		   	 alert("ID를 입력하세요");
		   	 return;
		    }
		   
		    $.ajax({
		       type:"post",
		       async:false,  
		       url:"${contextPath}/member/overlapped.do",
		       dataType:"text",
		       data: {id:memberId},
		       success:function (data,textStatus){
		          if (data == 'false'){
		          	alert("사용할 수 있는 ID입니다.");
		          }
		          else {
		          	alert("사용할 수 없는 ID입니다.");
		          }
		       },
		       error:function(data,textStatus){
		          alert("적절하지 않은 값을 입력하였습니다. 다시 시도해주십시요.");
		          history.go(-1);
		       },
		    });
		    
		 });	
		
	});
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
<link href="${contextPath }/resources/css/myStyle.css" rel="stylesheet" />
<style>
	td:first-child {
		text-align: center;
		font-weight: bold;
	}
</style>
</head>
<body>
	<form action="${contextPath}/member/addMember.do" method="post">
	<h3>회원가입</h3>
	<table class="table table-bordered table-hover">
		<colgroup>
			<col width="20%" >
			<col width="80%">
		</colgroup>
		<tr>
			<td>
				<label for="memberId">아이디</label>
			</td>
			<td>
	            <input type="text" class="form-control" style="display:inline; width:300px;" 
	            	name="memberId"  id="memberId" maxlength="15" placeholder="아이디를 입력하세요." />
	        	&emsp;<input type="button" id="btnOverlapped" class="btn btn-primary btn-sm" value="중복확인" />
	        </td>
	    </tr>
        <tr>
	        <td>
	        	 <label class="small mb-1" for="memberPw">비밀번호</label>
	        </td>
	        <td>
	        	<input class="form-control" id="memberPw" name="memberPw" type="password" placeholder="비밀번호를 입력하세요." />
	        </td>
        </tr>
        <tr>
	        <td>
	        	 <label class="small mb-1">비밀번호 확인</label>
	        </td>
	        <td>
	        	<input class="form-control" type="password" placeholder="비밀번호를 입력하세요." />
	        </td>
        </tr>         
        <tr>
	        <td>
	        	<label class="small mb-1" for="memberName">이름</label>
	        </td>
	        <td>
	        	<input type="text" class="form-control" name="memberName"  id="memberName" maxlength="15" placeholder="이름을 입력하세요." />
	        </td>
        </tr>                
	    <tr>
	        <td>
	        	<label for="g1">성별</label>
	        </td>
	        <td>
	        	<input class="custom-control-input" type="radio" id="g1" name="memberGender" value="101" checked />
				<label class="custom-control-label" for="g1">남성</label>&emsp;&emsp;&emsp;
				<input class="custom-control-input" type="radio" id="g2" name="memberGender" value="102" />
				<label class="custom-control-label" for="g2">여성</label>
	        </td>
        </tr>                              
        <tr>
	        <td>
	        	<label class="small mb-1" for="memberBirthY">생년월일</label>
	        </td>
	        <td>
                <select class="form-control" id="memberBirthY" name="memberBirthY" style="display:inline; width:70px; padding:0" >
				<c:forEach var="year" begin="1" end="100">
					<c:choose>
						<c:when test="${year==80}">
							<option value="${1921+year}" selected>${ 1921+year}
							</option>
						</c:when>
						<c:otherwise>
							<option value="${1921+year}">${ 1921+year}</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				</select> 년 
				<select class="form-control" name="memberBirthM" style="display:inline; width:50px; padding:0">
				  <c:forEach var="month" begin="1" end="12">
				      <c:choose>
				        <c:when test="${month==5}">
					   <option value="${month}" selected>${month }</option>
					</c:when>
					<c:otherwise>
					  <option value="${month}">${month}</option>
					</c:otherwise>
					</c:choose>
				  	</c:forEach>
				</select> 월  
				<select class="form-control" name="memberBirthD" style="display:inline; width:50px; padding:0">
				<c:forEach var="day" begin="1" end="31">
				      <c:choose>
				        <c:when test="${day==10}">
					   <option value="${day}" selected>${day}</option>
					</c:when>
					<c:otherwise>
					  <option value="${day}">${day}</option>
					</c:otherwise>
					</c:choose>
				  	</c:forEach>
				</select> 일 &nbsp;
				<div class="custom-control custom-radio" style="display:inline;">
					<input class="custom-control-input" type="radio" id="memberBirthGn2" name="memberBirthGn" value="2" checked />
					<label class="custom-control-label" for="memberBirthGn2">양력</label>
				</div>  
				<div class="custom-control custom-radio" style="display:inline;">
					<input class="custom-control-input" type="radio" id="memberBirthGn1" name="memberBirthGn" value="1" />
					<label class="custom-control-label" for="memberBirthGn1">음력</label>
	            </div>  
	        </td>
        </tr>                        
        <tr>
	        <td>
	        	<label class="small mb-1" for="tel1">집 전화번호</label>
	        </td>
	        <td>
	        	<select class="form-control" id="tel1" name="tel1" style="display:inline; width:70px; padding:0">
					<option>없음</option>
					<option value="02" selected>02</option>
					<option value="031">031</option>
					<option value="032">032</option>
					<option value="033">033</option>
					<option value="041">041</option>
					<option value="042">042</option>
					<option value="043">043</option>
					<option value="044">044</option>
					<option value="051">051</option>
					<option value="052">052</option>
					<option value="053">053</option>
					<option value="054">054</option>
					<option value="055">055</option>
					<option value="061">061</option>
					<option value="062">062</option>
					<option value="063">063</option>
					<option value="064">064</option>													
				 </select> - 
		 		<input class="form-control" size="10px" type="text" name="tel2" style="display:inline; width:100px; padding:0" > - 
		 		<input class="form-control" size="10px" type="text" name="tel3" style="display:inline; width:100px; padding:0">
	        </td>
        </tr>                         
        <tr>
	        <td>
	        	<label class="small mb-1" for="hp1">핸드폰 번호</label>
	        </td>
	        <td>
	        	<select  class="form-control" id="hp1" name="hp1" style="display:inline; width:70px; padding:0">
					<option>없음</option>
					<option selected value="010">010</option>
					<option value="011">011</option>
					<option value="016">016</option>
					<option value="017">017</option>
					<option value="018">018</option>
					<option value="019">019</option>
				</select> - 
				<input class="form-control"  size="10px"  type="text" name="hp2" style="display:inline; width:100px; padding:0"> - 
				<input class="form-control"  size="10px"  type="text"name="hp3" style="display:inline; width:100px; padding:0"><br><br>
				<input class="custom-control-input" id="smsstsYn" type="checkbox" name="smsstsYn"  value="Y" checked/>
                <label for="smsstsYn" >BMS에서 발송하는 SMS 소식을 수신합니다.</label>
	        </td>
        </tr>                         
        <tr>
	        <td>
	        	<label class="small mb-1" for="email1">이메일</label>
	        </td>
	        <td>
	        	<input class="form-control"  size="10px"  type="text" id="email1" name="email1" style="display:inline; width:100px; padding:0"> @ 
					<input class="form-control"  size="10px"  type="text" id="email2" name="email2" style="display:inline; width:100px; padding:0">
					<select class="form-control" id="select_email" name="email3" style="display:inline; width:100px; padding:0">
						 <option value="none" selected>직접입력</option>
						 <option value="gmail.com">gmail.com</option>
						 <option value="naver.com">naver.com</option>
						 <option value="daum.net">daum.net</option>
						 <option value="nate.com">nate.com</option>
					</select><br><br>
                    <input class="custom-control-input" id="emailstsYn" type="checkbox" name="emailstsYn"  value="Y" checked/>
                    <label for="emailstsYn">BMS에서 발송하는 E-mail을 수신합니다.</label>
	        </td>
        </tr>                              
        <tr>
	        <td>
	        	<label class="small mb-1" for="zipcode">주소</label>
	        </td>
	        <td>
	        	<input class="form-control"  size="70px"  type="text" placeholder="우편번호 입력" id="zipcode" name="zipcode" style="display:inline; width:150px; padding:0">
                <input type="button" class="btn btn-outline-primary btn-sm" onclick="javascript:execDaumPostcode()" value="검색">
                <div></div><br>
                도로명 주소 : <input type="text" class="form-control" id="roadAddress"  name="roadAddress" > <br>
				지번 주소 : <input type="text" class="form-control" id="jibunAddress" name="jibunAddress" > <br>
				나머지 주소: <input type="text" class="form-control" name="namujiAddress"/>
	        </td>
        </tr>                              
        <tr>
	        <td colspan="2">
	        	<input type="submit" value="회원가입하기" class="btn btn-primary btn-block" >
	        </td>
	    </tr>
	    <tr>
	        <td colspan="2" align="center">
	        	이미 회원가입이 되어있다면 ? <a href="${contextPath}/member/loginForm.do"><strong>로그인하기</strong></a>
	        </td>
        </tr>                            
     </table>
     </form>
</body>
</html>