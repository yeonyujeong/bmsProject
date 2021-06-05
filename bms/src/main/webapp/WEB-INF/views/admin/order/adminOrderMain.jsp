<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />
<html>
<head>
<meta  charset="utf-8">
	<c:choose>
		<c:when test='${not empty orderGoodsList}'>
			<script>
				window.onload=function() {
					var frm_delivery_list=document.frm_delivery_list;
					var h_deliveryState=frm_delivery_list.h_deliveryState;
					var s_deliveryState=frm_delivery_list.s_deliveryState;
					
					
					if (h_deliveryState.length == undefined){
						s_deliveryState.value=h_deliveryState.value; 
					}
					else {
						for (var i=0; s_deliveryState.length;i++){
							s_deliveryState[i].value=h_deliveryState[i].value;
						}
					}
				}
			</script>
		</c:when>
	</c:choose>
<script>

	function search_order_list(fixedSearchPeriod) {
		
		location.href= "${contextPath}/admin/order/adminOrderMain.do?fixedSearchPeriod="+fixedSearchPeriod;
		
	}
	
	
	function fn_modify_order_state(orderId,select_id){
		
		var s_deliveryState = document.getElementById(select_id);
	    
		var index = s_deliveryState.selectedIndex;
	    var value = s_deliveryState[index].value;
		 
		$.ajax({
			type : "post",
			url : "${contextPath}/admin/order/modifyDeliveryState.do",
			data : {
				orderId : orderId,
				deliveryState : value
			},
			success : function(data, textStatus) {
				if(data.trim()=='modSuccess'){
					alert("주문 정보를 수정했습니다.");
					location.href="${contextPath}//admin/order/adminOrderMain.do";
				}else if(data.trim()=='failed'){
					alert("다시 시도해 주세요.");	
				}
				
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			}
			
		}); 		
	}
	
	function fn_enable_detail_search(r_search){
		
		var frm_delivery_list = document.frm_delivery_list;
		t_beginYear   = frm_delivery_list.beginYear;
		t_beginMonth  = frm_delivery_list.beginMonth;
		t_beginDay    = frm_delivery_list.beginDay;
		t_endYear     = frm_delivery_list.endYear;
		t_endMonth    = frm_delivery_list.endMonth;
		t_endDay      = frm_delivery_list.endDay;
		s_search_type = frm_delivery_list.s_search_type;
		t_search_word = frm_delivery_list.t_search_word;
		btn_search    = frm_delivery_list.btn_search;
		
		if (r_search.value == 'detail_search'){
			t_beginYear.disabled   = false;
			t_beginMonth.disabled  = false;
			t_beginDay.disabled    = false;
			t_endYear.disabled     = false;
			t_endMonth.disabled    = false;
			t_endDay.disabled      = false;
			s_search_type.disabled = false;
			t_search_word.disabled = false;
			btn_search.disabled    = false;
		}
		else {
			t_beginYear.disabled    = true;
			t_beginMonth.disabled	= true;
			t_beginDay.disabled     = true;
			t_endYear.disabled		= true;
			t_endMonth.disabled     = true;
			t_endDay.disabled	    = true;
			
			s_search_type.disabled  = true;
			t_search_word.disabled  = true;
			btn_search.disabled     = true;
		}
			
	}
	
	
	function fn_detail_order(orderId){

	    location.href="${contextPath}/admin/order/orderDetail.do?orderId="+orderId; 
		
	}
	
	
	function fn_detail_search(){
		
var frm_delivery_list = document.frm_delivery_list;
		
		beginYear   = frm_delivery_list.beginYear.value;
		beginMonth  = frm_delivery_list.beginMonth.value;
		beginDay    = frm_delivery_list.beginDay.value;
		endYear     = frm_delivery_list.endYear.value;
		endMonth    = frm_delivery_list.endMonth.value;
		endDay      = frm_delivery_list.endDay.value;
		search_type = frm_delivery_list.s_search_type.value;
		search_word = frm_delivery_list.t_search_word.value;
	
		if (beginMonth < 10 && beginMonth.length == 1) 	beginMonth = "0" + beginMonth; 
		if (beginDay < 10 && beginDay.length == 1) 		beginDay = "0" + beginDay; 
		if (endMonth < 10 &&endMonth.length == 1) 	   	endMonth = "0" + endMonth; 
		if (endDay < 10 && endDay.length == 1) 			endDay = "0" + endDay; 
		
		var url = "${contextPath}/admin/order/adminOrderMain.do?";
			url += "beginDate="+ beginYear+"-"+beginMonth+"-"+beginDay;
			url += "&endDate=" + endYear+"-"+endMonth+"-"+endDay;
			url += "&search_type=" + search_type;
			url += "&search_word=" +search_word;
		
		location.href=url;
		
	}
</script>
<link href="${contextPath }/resources/css/myStyle.css" rel="stylesheet" />
</head>
<body>
	<h3>주문 조회</h3>
	<form name="frm_delivery_list" action="${contextPath }/admin/admin.do" method="post">	
		<table>
			<tbody>
				<tr>
					<td>
						<input type="radio" name="r_search_option" value="simple_search" checked onClick="fn_enable_detail_search(this)"/> 간단조회 &nbsp;&nbsp;&nbsp;
						<input type="radio" name="r_search_option" value="detail_search"  onClick="fn_enable_detail_search(this)" /> 상세조회 &nbsp;&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td>
						오늘 일자 &nbsp;&nbsp;
						<select name="curYear" disabled>
						    <c:forEach   var="i" begin="0" end="5">
						      <c:choose>
						        <c:when test="${endYear==endYear-i}">
						          <option value="${endYear}" selected>${endYear}</option>
						        </c:when>
						        <c:otherwise>
						          <option value="${endYear-i }">${endYear-i }</option>
						        </c:otherwise>
						      </c:choose>
						    </c:forEach>
						</select>년 
						<select name="curMonth" disabled>
								 <c:forEach   var="i" begin="1" end="12">
							      <c:choose>
							        <c:when test="${endMonth==i}">
							          <option value="${i}"  selected>${i}</option>
							        </c:when>
							        <c:otherwise>
							          <option value="${i}">${i}</option>
							        </c:otherwise>
							      </c:choose>
							    </c:forEach>					
						</select>월
					 	<select name="curDay" disabled>
						  	<c:forEach   var="i" begin="1" end="31">
						      <c:choose>
						        <c:when test="${endDay==i}">
						          <option value="${i}"  selected>${i}</option>
						        </c:when>
						        <c:otherwise>
						          <option value="${i}">${i}</option>
						        </c:otherwise>
						      </c:choose>
						    </c:forEach>	
						</select>일 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
						<a href="javascript:search_order_list('today')">       <img src="${contextPath}/resources/image/btn_search_one_day.jpg"></a>
						<a href="javascript:search_order_list('one_week')">    <img src="${contextPath}/resources/image/btn_search_1_week.jpg"></a>
						<a href="javascript:search_order_list('two_week')">    <img src="${contextPath}/resources/image/btn_search_2_week.jpg"></a>
						<a href="javascript:search_order_list('one_month')">   <img src="${contextPath}/resources/image/btn_search_1_month.jpg"></a>
						<a href="javascript:search_order_list('two_month')">   <img src="${contextPath}/resources/image/btn_search_2_month.jpg"></a>
						<a href="javascript:search_order_list('three_month')"> <img src="${contextPath}/resources/image/btn_search_3_month.jpg"></a>
						<a href="javascript:search_order_list('four_month')">  <img src="${contextPath}/resources/image/btn_search_4_month.jpg"></a>
						&nbsp;조회
					</td>
				</tr>
				<tr>
				  <td>
					조회 기간 &nbsp;&nbsp;
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
						 <c:forEach   var="i" begin="1" end="12">
					      <c:choose>
					        <c:when test="${endMonth==i }">
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
												 
				  </td>
				</tr>
				<tr>
				  <td>
				  	<select name="s_search_type" disabled>
							<option value="all" selected>전체</option>
							<option value="ordererName">주문자</option>
							<option value="goodsTitle">주문상품명</option>
					</select>
					<input type="text"  size="30"  id="t_search_word" disabled/>  
					<input type="button"  value="조회" id="btn_search" onclick="fn_detail_search()"  disabled />
				  </td>
				</tr>
			</tbody>
		</table>
		<div class="clear">
	</div>
	<div align="right">
		<input type="button" class="btn btn-Light btn-sm" value="Excel Export" onclick="location.href='${contextPath}/admin/order/orderExcelExport.do'" />
	</div>
	<div class="clear"></div>
	 <table class="list_view">
	  <tbody align=center >
	   <tr style="background-color : #94b2e5; color:#fff; height: 50px">
		<td class="fixed" >주문번호</td>
		<td class="fixed">주문시간</td>
		<td>주문내역</td>
		<td>배송상태</td>
		<td>배송수정</td>
	   </tr>
  	   <c:choose>
	    <c:when test="${empty newOrderList}">			
		 <tr>
	       <td colspan=5 class="fixed">
			  <strong>주문한 상품이 없습니다.</strong>
		   </td>
	     </tr>
		</c:when>
	 	<c:otherwise>
	     <c:forEach var="item" items="${newOrderList}" varStatus="i">
	        <c:choose>
	          <c:when test="${item.orderId != pre_orderId}">  
	          	<tr>
					<td width=10%><strong>${item.orderId}</strong></td>
					<td width=20%><strong><fmt:formatDate value="${item.payOrderTime}" pattern="yyyy-MM-dd HH:mm"/> </strong> </td>
					<td width=50% align=left >
					 <a href="javascript:fn_detail_order('${item.orderId}')">
					     <strong>주문자 : ${item.ordererName}</strong><br>
					     <strong>주문자 연락처 : ${item.ordererHp}</strong><br>
					     <strong>수령자:${item.receiverName}</strong><br>
					     <strong>수령자 전화번호 : ${item.receiverHp1}-${item.receiverHp2}-${item.receiverHp3}</strong><br>
					     <strong>주문상품명(수량) : ${item.goodsTitle}(${item.orderGoodsQty})</strong><br>
					     <c:forEach var="item2" items="${newOrderList}" varStatus="j">
					       <c:if test="${j.index > i.index }" >
					          <c:if test="${item.orderId ==item2.orderId}" >
					            <strong>주문상품명(수량) : ${item2.goodsTitle}(${item2.orderGoodsQty})</strong><br>
					      	  </c:if>   
					      </c:if>
					     </c:forEach>
				     </a> 
					</td>
					<td width=10%>
						<c:if test="${item.deliveryState == 'deliveryPrepared'}"> 
							<div class="badge badge-info badge-pill">배송준비중</div>
						</c:if>
						<c:if test="${item.deliveryState == 'delivering'}"> 
							<div class="badge badge-secondary badge-pill">배송중</div>
						</c:if>
						<c:if test="${item.deliveryState == 'finishedDelivering'}"> 
							<div class="badge badge-primary badge-pill">배송완료</div>
						</c:if>
						<c:if test="${item.deliveryState == 'cancelOrder'}"> 
							<div class="badge badge-danger badge-pill">주문취소</div>
						</c:if>
						<c:if test="${item.deliveryState == 'returningGoods'}"> 
							<div class="badge badge-yellow badge-pill">반품</div>
						</c:if>
					</td>
					<td width=10%>
						<select name="s_deliveryState${i.index }" id="s_deliveryState${i.index }">
							<option value="deliveryPrepared" <c:if test="${item.deliveryState=='deliveryPrepared' }"> selected </c:if>>배송준비중</option>
							<option value="delivering" <c:if test="${item.deliveryState=='delivering' }"> selected </c:if>>배송중</option>
							<option value="finishedDelivering" <c:if test="${item.deliveryState=='finishedDelivering' }"> selected </c:if>>배송완료</option>
							<option value="cancelOrder" <c:if test="${item.deliveryState=='cancelOrder' }"> selected </c:if>>주문취소</option>
							<option value="returningGoods" <c:if test="${item.deliveryState=='returningGoods' }"> selected </c:if>>반품</option>
						</select>
						<input type="button" value="배송수정" class="btn btn-outline-blue btn-xs" onClick="fn_modify_order_state('${item.orderId}','s_deliveryState${i.index}')" />
					</td>				
					</tr>
				  </c:when>
			     </c:choose>	
				</c:forEach>
			  </c:otherwise>
	      </c:choose>
			<c:set  var="pre_orderId" value="${item.orderId }" />
	        
		  </tbody>
	     </table>
       </form>   	
	   <div class="clear"></div>
</body>
</html>

