<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
	
<nav>
 <ul>
  <c:choose>
	<c:when test="${side_menu=='admin_mode'}">
	   <li>
			<h3>주요기능</h3>
			<ul>
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원 관리</a></li>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품 관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문 관리</a></li>
			</ul>
		</li>
		<br><br><br>
	</c:when>
	<c:when test="${side_menu=='my_page'}">
		<li>
			<h3>정보내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역 조회</a></li>
				<li><a href="${contextPath}/mypage/myDetailInfo.do">내 정보 수정</a></li>
				<li><a href="${contextPath}/main/main.do">메인화면으로 이동</a></li>
			</ul>
		</li>
		<br><br><br>
	</c:when>
	<c:otherwise>
		<li>
			<h3>목록 보기</h3>
			<ul>
				<li><a href="${contextPath}/main/main.do#bestSeller">베스트셀러</a></li>
				<li><a href="${contextPath}/main/main.do#steadySeller">스테디셀러</a></li>
				<li><a href="${contextPath}/main/main.do#new">신간</a></li>
			</ul>
		</li>
		<br><br><br>
	 </c:otherwise>
	</c:choose>	
  </ul>
</nav>
<div class="clear"></div>
<div id="banner">
	<a href="#"><img width="190" height="163" src="${contextPath}/resources/image/n-pay.jpg"> </a>
</div>
<div id="notice">
	<h2>공지사항</h2>
	<ul>
		<li><a href="#">BMS 개인정보 처리방침 개정 안내</a></li>
		<li><a href="#">BMS mobile 서비스 종료 안내 </a></li>
		<li><a href="#">마케팅정보 수신동의 확인 안내</a></li>
		<li><a href="#">북클럽 혜택 '커피 무료쿠폰' 종료 안내</a></li>
		<li><a href="#">BMS 이용약관 개정 안내</a></li>
	</ul>
</div>
<div id="banner">
	<a href="#"><img width="190" height="362" src="${contextPath}/resources/image/side_banner1.jpg"></a>
</div>
<div id="banner">
	<a href="#"><img width="190" height="104" src="${contextPath}/resources/image/call_center_logo.jpg"></a>
</div>
<div id="banner">
	<a href="#"><img width="190" height="69" src="${contextPath}/resources/image/QnA_logo.jpg"></a>
</div>
</html>