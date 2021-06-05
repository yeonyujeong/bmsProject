<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%request.setCharacterEncoding("UTF-8");%>  

<div id="ad_main_banner">
	<ul class="bjqs">
	    <li><img width="775" height="145" src="${contextPath}/resources/image/main_banner01.jpg"></li>
		<li><img width="775" height="145" src="${contextPath}/resources/image/main_banner02.jpg"></li>
		<li><img width="775" height="145" src="${contextPath}/resources/image/main_banner03.jpg"></li>
	</ul>
</div>
<div class="main_book" id="bestSeller">
   <c:set var="goodsCount" value="0" />
	<h3>베스트셀러</h3>
	<c:forEach var="item" items="${goodsMap.bestseller }">
	   <c:set var="goodsCount" value="${goodsCount+1 }" />
		<div class="book">
			<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId }"><img class="link"  src="${contextPath}/resources/image/1px.gif"> </a> 
			<img width="121" height="154" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}">
			<div class="title">${item.goodsTitle }</div>
			<div class="price"><fmt:formatNumber  value="${item.goodsPrice}" type="number" var="goodsPrice" />${goodsPrice}원</div>
		</div>
	   <c:if test="${goods_count==15}">
         <div class="book">
           <font size="20"> <a href="#">more</a></font>
         </div>
     </c:if>
  </c:forEach>
</div>
<div class="clear"></div>
<div id="ad_sub_banner">
	<img width="770" height="117" src="${contextPath}/resources/image/sub_banner01.jpg">
</div>
<div class="main_book" id="new">
<c:set  var="goodsCount" value="0" />
 <h3>신간</h3>
 <c:forEach var="item" items="${goodsMap.newbook }" >
   <c:set var="goodsCount" value="${goodsCount+1 }" />
   <div class="book">
   	<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId }">
   	 <img class="link"  src="${contextPath}/resources/image/1px.gif">
   	</a>
   <img width="121" height="154" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}">
   <div class="title">${item.goodsTitle }</div>
   <div class="price"><fmt:formatNumber  value="${item.goodsPrice}" type="number" var="goodsPrice" />${goodsPrice}원</div>
   </div>
   <c:if test="${goodsCount==15   }">
     <div class="book">
       <font size=20> <a href="#">more</a></font>
     </div>
   </c:if>
 </c:forEach>
</div>

<div class="clear"></div>
<div id="ad_sub_banner">
	<img width="770" height="117" src="${contextPath}/resources/image/sub_banner02.jpg">
</div>


<div class="main_book" id="steadySeller">
<c:set var="goodsCount" value="0" />
 <h3>스테디셀러</h3>
  <c:forEach var="item" items="${goodsMap.steadyseller }" >
  <c:set var="goodsCount" value="${goodsCount+1 }" />
  <div class="book">
   <a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId }">
    <img class="link"  src="${contextPath}/resources/image/1px.gif"> 
   </a>
   <img width="121" height="154" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}">
   <div class="title">${item.goodsTitle }</div>
   <div class="price">
    <fmt:formatNumber  value="${item.goodsPrice}" type="number" var="goodsPrice" />${goodsPrice}원</div>
   </div>
   <c:if test="${goodsCount==15   }">
     <div class="book">
       <font size=20> <a href="#">more</a></font>
     </div>
   </c:if>
 </c:forEach>
</div>

   
   