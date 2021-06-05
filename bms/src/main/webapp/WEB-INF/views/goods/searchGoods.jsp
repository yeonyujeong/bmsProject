<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<head>
 <title>검색 도서 목록 페이지</title>
</head>
<body>
	<hgroup>
		<h1>컴퓨터와 인터넷</h1>
		<h2>오늘의 책</h2>
	</hgroup>
	<section id="new_book">
		<h3>새로나온 책</h3>
		<div id="left_scroll">
			<a href='javascript:slide("left");'><img src="${contextPath}/resources/image/left.gif"></a>
		</div>
		<div id="carousel_inner">
			<ul id="carousel_ul">
			<c:choose>
			   <c:when test="${empty goodsList}" >
			        <li>
					<div id="book">
						<h1>제품이없습니다.</h1>
					  </div>
				</li> 
			   </c:when>
			   <c:otherwise>
			    <c:forEach var="item" items="${goodsList}" >
			     <li>
					<div id="book">
						<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId}">
						<img width="75" alt="상품명" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}">
						</a>
						<div class="sort">[컴퓨터 인터넷]</div>
						<div class="title">
							<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId}">
							  ${item.goodsTitle}
							</a>
						</div>
						<div class="writer">${item.goodsWriter} | ${item.goodsPublisher}</div>
						<div class="price">
							<span><fmt:formatNumber  value="${item.goodsPrice}" type="number" /></span> <br>
							<fmt:formatNumber value="${item.goodsSalesPrice}" type="number"  />
				            (<fmt:formatNumber value="${(item.goodsPrice - item.goodsSalesPrice)}"/>원 할인)
						</div>
					</div>
				</li>
				</c:forEach> 
			   </c:otherwise>
			 </c:choose>
			 
			</ul>
		</div>
		<div id="right_scroll">
			<a href='javascript:slide("right");'><img  src="${contextPath}/resources/image/right.gif"></a>
		</div>
		<input id="hidden_auto_slide_seconds" type="hidden" value="0">
		<div class="clear"></div>
	</section>
	<table id="list_view">
		<tbody>
		  <c:forEach var="item" items="${goodsList}"> 
			<tr align="center">
				<td class="goods_image">
					<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId}">
						   <img width="75" alt="" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}">
					</a>
				</td>
				<td class="goods_description" >
					<h2>
						<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId}">${item.goodsTitle}</a>
					</h2>
					<div class="writer_press"  >${item.goodsWriter }저 &emsp; |
						&emsp; ${item.goodsPublisher } | &emsp; 
						<fmt:formatDate value="${item.goodsPublishedDate }" pattern="yyyy-MM-dd"/>  
					</div>
				</td>
				<td class="price">
					<span><fmt:formatNumber  value="${item.goodsPrice}" type="number" /></span> <br>
					<fmt:formatNumber value="${item.goodsSalesPrice}" type="number"  /><br>
		            (<fmt:formatNumber value="${(item.goodsPrice - item.goodsSalesPrice)}"/>원 할인)
				</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>