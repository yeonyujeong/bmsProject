<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta   charset="utf-8">
<script>

	function search_order_history(fixedSearchPeriod){
		
		var formObj = document.createElement("form");
		var i_fixedSearch_period = document.createElement("input");
		i_fixedSearch_period.name = "fixedSearchPeriod";
		i_fixedSearch_period.value = fixedSearchPeriod;
	    formObj.appendChild(i_fixedSearch_period);
	    document.body.appendChild(formObj); 
	    formObj.method = "get";
	    formObj.action = "${contextPath}/mypage/listMyOrderHistory.do";
	    formObj.submit();
	    
	}
	
	function fn_cancel_order(orderId){
		
		var answer = confirm("주문을 취소하시겠습니까?");
		
		
		if (answer) {
		    location.href = "${contextPath}/mypage/cancelMyOrder.do?orderId=" + orderId;
		}
		
	}
	
	function fn_enable_detail_search(obj){
		
		var delivery_list= document.delivery_list;
		
		curYear = delivery_list.curYear;
		curMonth = delivery_list.curMonth;
		curDay = delivery_list.curDay;
		
		searchCondition = delivery_list.search_condition;
		search = delivery_list.search;
		
		beginYear = delivery_list.beginYear;
		beginMonth = delivery_list.beginMonth;
		beginDay = delivery_list.beginDay;
		endYear = delivery_list.endYear;
		endMonth = delivery_list.endMonth;
		endDay = delivery_list.endDay;
		button = delivery_list.button;
		
		
		if(obj.value == 'simple'){

			searchCondition.disabled = true;
			search.disabled = true;
			
			beginYear.disabled = true;
			beginDay.disabled = true;
			beginMonth.disabled = true;
			endYear.disabled = true;
			endDay.disabled = true;
			endMonth.disabled = true;
			button.disabled = true;

		}
		
		if(obj.value == 'daily'){
			
			searchCondition.disabled = false;
			search.disabled = false;
			
			beginYear.disabled = false;
			beginDay.disabled = false;
			beginMonth.disabled = false;
			endYear.disabled = false;
			endDay.disabled = false;
			endMonth.disabled = false;
			button.disabled = false;

		}
		
		
	}
	
	function fn_detail_search(){
		
		var frm_delivery_list = document.delivery_list;
		
		beginYear   = delivery_list.beginYear.value;
		beginMonth  = delivery_list.beginMonth.value;
		beginDay    = delivery_list.beginDay.value;
		endYear     = delivery_list.endYear.value;
		endMonth    = delivery_list.endMonth.value;
		endDay      = delivery_list.endDay.value;
		
		search = delivery_list.select.value;
		search_type = delivery_list.search_condition.value;
		search_word = delivery_list.search.value;
	
		if (beginMonth < 10 && beginMonth.length == 1) 	beginMonth = "0" + beginMonth; 
		if (beginDay < 10 && beginDay.length == 1) 		beginDay = "0" + beginDay; 
		if (endMonth < 10 &&endMonth.length == 1) 	   	endMonth = "0" + endMonth; 
		if (endDay < 10 && endDay.length == 1) 			endDay = "0" + endDay; 
		
		var url = "${contextPath}/mypage/listMyOrderHistory.do?";
			url += "beginDate="+ beginYear+"-"+beginMonth+"-"+beginDay;
			url += "&endDate=" + endYear+"-"+endMonth+"-"+endDay;
			url += "&search_type=" + search_type;
			url += "&search_word=" +search_word;
			url += "&search=" +search;
		
		location.href=url;
		
	}

</script>
</head>
<body>
	<H3>주문 배송 조회</H3>
	<form  name="delivery_list" method="post">	
		<table>
			<tbody>
				<tr>
					<td>
						<input type="radio" name="select" value="simple" onClick="fn_enable_detail_search(this)" checked /> 간단조회 
						<input type="radio" name="select"  value="daily" onClick="fn_enable_detail_search(this)"/> 상세조회   

					</td>
				</tr>
				<tr>
					<td id="simple_search" name="simple_search">
					<a href="javascript:search_order_history('today')">
					   <img src="${contextPath}/resources/image/btn_search_one_day.jpg">
					</a>
					<a href="javascript:search_order_history('one_week')">
					   <img src="${contextPath}/resources/image/btn_search_1_week.jpg">
					</a>
					<a href="javascript:search_order_history('two_week')">
					   <img src="${contextPath}/resources/image/btn_search_2_week.jpg">
					</a>
					<a href="javascript:search_order_history('one_month')">
					   <img src="${contextPath}/resources/image/btn_search_1_month.jpg">
					</a>
					<a href="javascript:search_order_history('two_month')">
					   <img src="${contextPath}/resources/image/btn_search_2_month.jpg">
					</a>
					<a href="javascript:search_order_history('three_month')">
					   <img src="${contextPath}/resources/image/btn_search_3_month.jpg">
					</a>
					<a href="javascript:search_order_history('four_month')">
					   <img src="${contextPath}/resources/image/btn_search_4_month.jpg">
					</a>
					&nbsp;까지 조회
					</td>
				</tr>
				<tr>
				  <td>
				    <select name="search_condition" disabled>
						<option value="all" selected>전체</option>
						<option value="receiverName">수령자</option>
						<option value="ordererName">주문자</option>
						<option value="orderId">주문번호</option>
					</select>
					<input type="text" name="search" id="search" size="30" disabled/>  
				  </td>
				</tr>
				<tr>
				  <td>
					조회한 기간:
					<select name="beginYear" disabled>
					 <c:forEach   var="i" begin="0" end="5">
					      <c:choose>
					        <c:when test="${beginYear==beginYear-i }">
					          <option value="${beginYear-i }" selected>${beginYear-i  }</option>
					        </c:when>
					        <c:otherwise>
					          <option value="${beginYear-i }">${beginYear-i }</option>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>
					</select>년 
					<select name="beginMonth" disabled >
						 <c:forEach   var="i" begin="1" end="12">
					      <c:choose>
					        <c:when test="${beginMonth==i }">
					          <option value="${i }"  selected>${i }</option>
					        </c:when>
					        <c:otherwise>
					          <c:choose>
					            <c:when test="${i <10 }">
					              <option value="0${i }">0${i }</option>
					            </c:when>
					            <c:otherwise>
					            <option value="${i }">${i }</option>
					            </c:otherwise>
					          </c:choose>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>					
					</select>월
					 <select name="beginDay" disabled >
					  <c:forEach   var="i" begin="1" end="31">
					      <c:choose>
					        <c:when test="${beginDay==i }">
					          <option value="${i }"  selected>${i }</option>
					        </c:when>
					        <c:otherwise>
					          <c:choose>
					            <c:when test="${i <10 }">
					              <option value="0${i }">0${i }</option>
					            </c:when>
					            <c:otherwise>
					            <option value="${i }">${i }</option>
					            </c:otherwise>
					          </c:choose>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>	
					</select>일  &nbsp; ~
					
					<select name="endYear" disabled >
					 <c:forEach   var="i" begin="0" end="5">
					      <c:choose>
					        <c:when test="${endYear==endYear-i }">
					          <option value="${2021-i }" selected>${2021-i  }</option>
					        </c:when>
					        <c:otherwise>
					          <option value="${2021-i }">${2021-i }</option>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>
					</select>년 
					<select name="endMonth" disabled >
						 <c:forEach var="i" begin="1" end="12">
					      <c:choose>
					        <c:when test="${endMonth==i }">
					          <option value="${i }"  selected>${i }</option>
					        </c:when>
					        <c:otherwise>
					          <c:choose>
					            <c:when test="${i<10 }">
					              <option value="0${i }">0${i }</option>
					            </c:when>
					            <c:otherwise>
					            <option value="${i }">${i }</option>
					            </c:otherwise>
					          </c:choose>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>					
					</select>월
					 <select name="endDay" disabled >
					  <c:forEach   var="i" begin="1" end="31">
					      <c:choose>
					        <c:when test="${endDay==i }">
					          <option value="${i }"  selected>${i }</option>
					        </c:when>
					        <c:otherwise>
					          <c:choose>
					            <c:when test="${i<10}">
					              <option value="0${i}">0${i }</option>
					            </c:when>
					            <c:otherwise>
					            <option value="${i}">${i }</option>
					            </c:otherwise>
					          </c:choose>
					        </c:otherwise>
					      </c:choose>
					    </c:forEach>	
					</select>	
					<input type="button" name=button value="조회" onclick="fn_detail_search()"disabled/>						 
				  </td>
				</tr>
			</tbody>
		</table>
		<div class="clear">
	</div>
</form>	
<div class="clear"></div>
<table class="list_view">
		<tbody align=center >
			<tr style="background:#94b2e5" >
				<td class="fixed" >주문번호</td>
				<td class="fixed">주문일자</td>
				<td>주문내역</td>
				<td>주문금액/수량</td>
				<td>주문상태</td>
				<td>주문자</td>
				<td>수령자</td>
				<td>주문취소</td>
			</tr>
   <c:choose>
     <c:when test="${empty myOrderHistList }">			
			<tr>
		       <td colspan=8 class="fixed">
				  <strong>주문한 상품이 없습니다.</strong>
			   </td>
		     </tr>
	 </c:when>
	 <c:otherwise> 
     <c:forEach var="item" items="${myOrderHistList }" varStatus="i">
        <c:choose>
          <c:when test="${item.orderId != pre_orderId }">   
            <tr>       
				<td>
				  <a href="${contextPath}/mypage/myOrderDetail.do?orderId=${item.orderId }"><strong>${item.orderId }</strong>  </a>
				</td>
				<td >
				 <strong><fmt:formatDate value="${item.payOrderTime }" pattern="yyyy-MM-dd"/> </strong> 
				</td>
				<td> 
				    <strong>
					   <c:forEach var="item2" items="${myOrderHistList}" varStatus="j">
				          <c:if  test="${item.orderId ==item2.orderId}" >
				            <a href="${contextPath}/goods/goodsDetail.do?goodsId=${item2.goodsId }">${item2.goodsTitle }</a><br>
				         </c:if>   
					 </c:forEach>
					 </strong>
				</td>
				<td>
				   <strong>
				      <c:forEach var="item2" items="${myOrderHistList}" varStatus="j">
				          <c:if  test="${item.orderId ==item2.orderId}" >
				             ${item.goodsSalesPrice * item.orderGoodsQty }원 &emsp;/ &emsp; ${item.orderGoodsQty }(개)<br>
				         </c:if>   
					 </c:forEach>
				   </strong>
				</td>
				<td>
				  <strong>
				    <c:choose>
					    <c:when test="${item.deliveryState=='deliveryPrepared'}">
					       배송준비중
					    </c:when>
					    <c:when test="${item.deliveryState=='delivering'}">
					       배송중
					    </c:when>
					    <c:when test="${item.deliveryState=='finishedDelivering'}">
					       배송완료
					    </c:when>
					    <c:when test="${item.deliveryState=='cancelOrder'}">
					       주문취소
					    </c:when>
					    <c:when test="${item.deliveryState=='returningGoods'}">
					       반품
					    </c:when>
				  </c:choose>
				  </strong>
				</td>
				<td>
				 <strong>${item.ordererName }</strong> 
				</td>
				<td>
					<strong>${item.receiverName }</strong>
				</td>
				<td>
			     <c:choose>
			   <c:when test="${item.deliveryState=='deliveryPrepared'}">
			       <input type="button" onClick="fn_cancel_order('${item.orderId}')" value="주문취소"  />
			   </c:when>
			   <c:otherwise>
			      <input type="button" onClick="fn_cancel_order('${item.orderId}')" value="주문취소" disabled />
			   </c:otherwise>
			  </c:choose>
			    </td>
			</tr>
			<c:set var="pre_orderId" value="${item.orderId }" />
		   </c:when>	
	  </c:choose>		
	</c:forEach>
	</c:otherwise>
  </c:choose>			   
		</tbody>
	</table>
	<div class="clear"></div>
</body>
</html>