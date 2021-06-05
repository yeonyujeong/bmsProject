<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="${contextPath}/resources/jquery/jquery-3.5.1.min.js"></script>
<link href="${contextPath }/resources/css/myStyle.css" rel="stylesheet" />
<c:if test='${not empty message}'>
	<script>
		$().ready(function(){
			alert("아이디와 비밀번호를 확인하세요.");
		});
	</script>
</c:if>
</head>
<body>
	<h1>Login in to BMS</h1>
	<br>
	<form action="${contextPath}/member/login.do" method="post">
		<table class="table table-hover">
			<colgroup>
				<col width="20%">
				<col width="60%">
			</colgroup>
			<tr>
				<td align="center"><label for="memberId">아이디</label></td>
				<td><input class="form-control" id="memberId" name="memberId" type="text" placeholder="아이디를 입력하세요." /></td>
			</tr>
			<tr align="center">
				<td><label for="memberPw">비밀번호</label></td>
				<td><input class="form-control" id="memberPw" name="memberPw" type="password" placeholder="비밀번호를 입력하세요." /></td>
			</tr>
			<tr >
				<td colspan="2" align="right"><input type="submit" class="btn btn-primary btn-sm" value="로그인"></td>
			</tr>
		</table>
		<p align="center">
   			<img src="${contextPath }/resources/image/bms_logo1.png" width=300>
   		</p>
	</form>
</body>
</html>