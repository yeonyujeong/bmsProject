<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="myCartList"  value="${cartMap.myCartList}"  />
<c:set var="myGoodsList"  value="${cartMap.myGoodsList}"  />

<c:set var="totalGoodsNum" value="0" />  			
<c:set var="totalDeliveryPrice" value="0" /> 		
<c:set var="totalDiscountedPrice" value="0" /> 		
<head>
<script src="${contextPath}/resources/jquery/jquery-3.5.1.min.js"></script>
<script>
	
	function calcGoodsPrice(obj , goodsPrice , goodsSalesPrice , goodsQty , goodsDeliveryPrice){
	
		var totalNum , totalPrice , totalDeliveryPrice , totalSalesPrice , finalTotalPrice;
		
		var goods_qty           = $("#cartGoodsQty"); 
		var p_totalNum          = $("#p_totalGoodsNum");
		var p_totalPrice        = $("#p_totalGoodsPrice");    
		var p_finalTotalPrice   = $("#p_finalTotalPrice");   
		var p_totalDeliveryPrice= $("#p_totalDeliveryPrice"); 
		var p_totalSalesPrice	= $("#p_totalSalesPrice");    
		
		var h_totalNum          = $("#h_totalGoodsNum");
		var h_totalPrice        = $("#h_totalGoodsPrice");
		var h_totalDeliveryPrice= $("#h_totalDeliveryPrice");
		var h_finalTotalPrice   = $("#h_finalTotalPrice");
		var h_totalSalesPrice	= $("#h_totalSalesPrice")
		
		
		if (obj.checked){
		 	totalNum           = Number(h_totalNum.val()) + goodsQty; 
			totalPrice         = Number(h_totalPrice.val())+ goodsPrice * goodsQty; 	
			totalDeliveryPrice = Number(h_totalDeliveryPrice.val()) + goodsDeliveryPrice;	
			totalSalesPrice	   = Number(h_totalSalesPrice.val()) + (goodsPrice - goodsSalesPrice)*goodsQty;	
			finalTotalPrice    = totalPrice - totalSalesPrice + totalDeliveryPrice; 
			
			
		}
		else {
			totalNum           = Number(h_totalNum.val()) - goodsQty; 
			totalPrice         = Number(h_totalPrice.val())- goodsPrice * goodsQty; 	
			totalDeliveryPrice = Number(h_totalDeliveryPrice.val()) - goodsDeliveryPrice;	
			totalSalesPrice	   = Number(h_totalSalesPrice.val()) - (goodsPrice - goodsSalesPrice)*goodsQty;	
			finalTotalPrice    = totalPrice + totalSalesPrice - totalDeliveryPrice; 
			
		}
		
		h_totalNum.val(totalNum);
		h_totalPrice.val(totalPrice) ;
		h_totalDeliveryPrice.val(totalDeliveryPrice);
		h_finalTotalPrice.val(finalTotalPrice);
		h_totalSalesPrice.val(totalSalesPrice);
		
		p_totalNum.text(totalNum);
		p_totalPrice.text(totalPrice);
		p_totalDeliveryPrice.text(totalDeliveryPrice);
		p_finalTotalPrice.text(finalTotalPrice);
		p_totalSalesPrice.text(totalSalesPrice);
		
	}
	
	

	
	function modify_cart_qty(goodsId ,cartGoodsQty ,cnt){
	   
		var length = document.frm_order_all_cart.cartGoodsQty.length;
	  	var cartGoodsQty = 0;
		
	  	if (length>1) { 
	  		cartGoodsQty = document.frm_order_all_cart.cartGoodsQty[cnt-1].value;		
		}
		else {
			cartGoodsQty = document.frm_order_all_cart.cartGoodsQty.value;
		}

		$.ajax({
			type : "post",
			url : "${contextPath}/cart/modifyCartQty.do",
			data : {
				goodsId       : goodsId,
				cartGoodsQty  : Number(cartGoodsQty)
			},
			
			success : function(data, textStatus) {
				alert("수량을 변경했습니다.");	
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			
		}); 	
	}
	
	
	function delete_cart_goods(cartId){
	   location.href = "${contextPath}/cart/removeCartGoods.do?cartId=" + Number(cartId);
	}
	
	
	function fn_order_each_goods(goodsId , goodsTitle , goodsSalesPrice , fileName) {
		
		var total_price,final_total_price,_goods_qty;
		var cart_goods_qty = document.getElementById("cartGoodsQty");
		
		_order_goods_qty	    = cart_goods_qty.value; 
		var formObj             = document.createElement("form");
		var i_goods_id          = document.createElement("input"); 
	    var i_goods_title       = document.createElement("input");
	    var i_goods_sales_price = document.createElement("input");
	    var i_fileName          = document.createElement("input");
	    var i_order_goods_qty   = document.createElement("input");
	    
	    i_goods_id.name          = "goodsId";
	    i_goods_title.name       = "goodsTitle";
	    i_goods_sales_price.name = "goodsSalesPrice";
	    i_fileName.name          = "goodsFileName";
	    i_order_goods_qty.name   = "orderGoodsQty";
	    
	    i_goods_id.value          = goodsId;
	    i_order_goods_qty.value   = order_goods_qty;
	    i_goods_title.value       = goodsTitle;
	    i_goods_sales_price.value = goodsSalesPrice;
	    i_fileName.value          = fileName;
	    
	    formObj.appendChild(i_goods_id);
	    formObj.appendChild(i_goods_title);
	    formObj.appendChild(i_goods_sales_price);
	    formObj.appendChild(i_fileName);
	    formObj.appendChild(i_order_goods_qty);
	
	    document.body.appendChild(formObj); 
	    formObj.method="post";
	    formObj.action="${contextPath}/order/orderEachGoods.do";
	    formObj.submit();
	}
	
	
	function fn_order_all_cart_goods(){
		var order_goods_qty;
		var order_goods_id;
		var objForm                = document.frm_order_all_cart;
		var cart_goods_qty         = objForm.cartGoodsQty;
		var checked_goods          = objForm.checked_goods;
		var length          	   = $("input:checkbox[name='checked_goods']:checked").length;
		var totLength			   = $("input:checkbox[name='checked_goods']").length;
		 objForm.checkedLength.value 	   = length;
		var checkedLength 	= objForm.checkedLength.value;
		
		if(length == 1){
			order_goods_id=checked_goods.value;
			order_goods_qty=cart_goods_qty.value;
			cart_goods_qty.value="";
			cart_goods_qty.value=order_goods_id+":"+order_goods_qty;
			objForm.method="post";
			objForm.action="${contextPath}/order/orderAllCartGoods.do";
			objForm.submit();
		}else{
			
			var cnt = 0;
			for (var i=0; i<totLength;i++){
				if (checked_goods[i].checked==true){
					order_goods_id=checked_goods[i].value;
					order_goods_qty=cart_goods_qty[i].value;
					cart_goods_qty[cnt].value="";
					cart_goods_qty[cnt].value=order_goods_id+":"+order_goods_qty;
					cnt++;
					if(cnt == checkedLength) break;
				}
			}	
					
			 objForm.method="post";
			 objForm.action="${contextPath}/order/orderAllCartGoods.do";
			objForm.submit();
			
			
		}
		
	}

</script>
</head>
<body>

	<table class="list_view">
		<tbody align=center >
			<tr style="background:#94b2e5" >
				<td class="fixed" >구분</td>
				<td colspan=2 class="fixed">상품명</td>
				<td>정가</td>
				<td>판매가</td>
				<td>수량</td>
				<td>합계</td>
				<td>주문</td>
			</tr>
			 <c:choose>
			    <c:when test="${ empty myCartList }">
			    <tr>
			       <td colspan=8 class="fixed">
			         <strong>장바구니에 상품이 없습니다.</strong>
			       </td>
			     </tr>
			    </c:when>
		        <c:otherwise>
               		<form name="frm_order_all_cart">
				      <c:forEach var="item" items="${myGoodsList }" varStatus="cnt">
				       <c:set var="cartGoodsQty" value="${myCartList[cnt.count-1].cartGoodsQty}" /> 
			 			<tr>       
				       <c:set var="cartId" value="${myCartList[cnt.count-1].cartId}" />
						<td><input type="checkbox" name="checked_goods" id="checked_goods"  checked  value="${item.goodsId }" 
						 onClick="calcGoodsPrice(this, ${item.goodsPrice} , ${item.goodsSalesPrice } , ${cartGoodsQty } , ${item.goodsDeliveryPrice })"></td>
						
						<td class="goods_image">
						<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId }">
							<img width="75" alt="" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}"  />
						</a>
						</td>
						<td>
							<h2>
								<a href="${contextPath}/goods/goodsDetail.do?goodsId=${item.goodsId }">${item.goodsTitle }</a>
							</h2>
						</td>
						<td class="price"><span>${item.goodsPrice}원</span></td>
						<td>
						   <strong>
						      <fmt:formatNumber value="${item.goodsSalesPrice}" type="number" var="discountedPrice" />
					            ${discountedPrice}원
					         </strong>
						</td>
						<td> 
						   <input type="text" id="cartGoodsQty" name="cartGoodsQty" size="3" value="${cartGoodsQty}"><br>
							<a href="javascript:modify_cart_qty('${item.goodsId }','${cartGoodsQty}','${cnt.count}');" >
							    <img width=25 alt="변경"  src="${contextPath}/resources/image/btn_modify_qty.jpg">
							</a>
						</td>
						<td>
						   <strong>
						    <fmt:formatNumber value="${item.goodsSalesPrice * cartGoodsQty}" type="number" var="totalSalesPrice" />
					         ${totalSalesPrice}원
							</strong> 
						</td>
						<td>
						      <a href="javascript:fn_order_each_goods('${item.goodsId }','${item.goodsTitle }','${item.goodsSalesPrice}','${item.goodsFileName}');">
						       	<img width="75" alt="" src="${contextPath}/resources/image/btn_order.jpg">
								</a><br>
							  <a href="javascript:delete_cart_goods('${cartId}');"> 
							   <img width="75" alt="" src="${contextPath}/resources/image/btn_delete.jpg">
						   </a>
						</td>
					</tr>
					
					
					<c:set var="totalGoodsPrice" value="${totalGoodsPrice + item.goodsPrice * cartGoodsQty }" />
					<c:set var="totalGoodsNum" value="${totalGoodsNum+cartGoodsQty }" />
					<c:set var="totalDeliveryPrice" value="${totalDeliveryPrice + item.goodsDeliveryPrice }"/>
					<c:set var="totalDiscountedPrice" value="${totalDiscountedPrice + ((item.goodsPrice -item.goodsSalesPrice)*cartGoodsQty)}"/>
					
				   </c:forEach>
				   <input type="hidden" name="checkedLength"/>
					<div class="clear"></div>
					</form>
		 </c:otherwise>
		</c:choose> 
	</tbody>
	</table>
     	
	<br>
	<br>
	
	<table class="list_view" style="background:#c2d2ee; width:100%">
	<tbody>
	     <tr align=center  class="fixed" >
	       <td class="fixed">총 상품수 </td>
	       <td>총 상품금액</td>
	       <td></td>
	       <td>총 배송비</td>
	       <td></td>
	       <td>총 할인 금액 </td>
	       <td></td>
	       <td>최종 결제금액</td>
	     </tr>
		<tr align="center" >
			<td id="">
			  <p id="p_totalGoodsNum">${totalGoodsNum}개 </p>
			  <input id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}"  />
			</td>
	       <td>
	          <p id="p_totalGoodsPrice">
	           <fmt:formatNumber value="${totalGoodsPrice}" type="number" />원
	          </p>
	          <input id="h_totalGoodsPrice" type="hidden" value="${totalGoodsPrice}" />
	       </td>
	       <td> 
	          <img width="25" alt="" src="${contextPath}/resources/image/plus.jpg">  
	       </td>
	       <td>
	       	<p id="p_totalDeliveryPrice">
	        <fmt:formatNumber  value="${totalDeliveryPrice}" type="number" />원
	        </p>
	        <input id="h_totalDeliveryPrice" type="hidden" value="${totalDeliveryPrice}" />
	       </td>
	       <td> 
	         <img width="25" alt="" src="${contextPath}/resources/image/minus.jpg"> 
	       </td>
	       <td>  
	         <p id="p_totalSalesPrice">
	         <fmt:formatNumber value="${totalDiscountedPrice}" type="number" />원
	         </p>
	         <input id="h_totalSalesPrice" type="hidden" value="${totalDiscountedPrice}" />
	       </td>
	       <td>  
	         <img width="25" alt="" src="${contextPath}/resources/image/equal.jpg">
	       </td>
	       <td>
	          <p id="p_finalTotalPrice">
	           <fmt:formatNumber value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" type="number" />원
	           </p>
	          <input id="h_finalTotalPrice" type="hidden" value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" />
	       </td>
		</tr>
		</tbody>
	</table>
	<div align="right">
    <br><br>	
	 <a href="javascript:fn_order_all_cart_goods()">
	 	<img width="75" alt="" src="${contextPath}/resources/image/btn_order_final.jpg">
	 </a>
	 <a href="#">
	 	<img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
	 </a>
	</div>
</body>
</html>