<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"  />

<script>

	var array_index = 0;
	var SERVER_URL = "${contextPath}/thumbnails.do";
	
	function fn_show_next_goods(){
		
		var img_sticky          = document.getElementById("img_sticky");
		var cur_goods_num       = document.getElementById("cur_goods_num");
		var _h_goodsId         = document.frm_sticky.h_goodsId;
		var _h_goodsFileName   = document.frm_sticky.h_goodsFileName;
		if(array_index <_h_goodsId.length-1)
			array_index++;
		 	
		var goodsId            = _h_goodsId[array_index].value;
		var fileName            = _h_goodsFileName[array_index].value;
		img_sticky.src          = SERVER_URL+"?goodsId="+goodsId+"&fileName="+fileName;
		cur_goods_num.innerHTML = array_index+1;
		
	}


	 function fn_show_previous_goods(){
		var img_sticky          = document.getElementById("img_sticky");
		var cur_goods_num       = document.getElementById("cur_goods_num");
		var _h_goodsId         = document.frm_sticky.h_goodsId;
		var _h_goodsFileName   = document.frm_sticky.h_goodsFileName;
		
		if(array_index >0)
			array_index--;
		
		var goodsId            = _h_goodsId[array_index].value;
		var fileName            = _h_goodsFileName[array_index].value;
		img_sticky.src          = SERVER_URL+"?goodsId="+goodsId+"&fileName="+fileName;
		cur_goods_num.innerHTML = array_index+1;
	}
	
	 
	function goodsDetail() {
		
		var cur_goods_num = document.getElementById("cur_goods_num");
		arrIdx=cur_goods_num.innerHTML-1;
		
		var img_sticky = document.getElementById("img_sticky");
		var h_goodsId = document.frm_sticky.h_goodsId;
		var len = h_goodsId.length;
		
		if (len>1)	goodsId=h_goodsId[arrIdx].value;
		else		goodsId=h_goodsId.value;
		
		
		var formObj = document.createElement("form");
		var i_goodsId = document.createElement("input"); 
	    
		i_goodsId.name = "goodsId";
		i_goodsId.value = goodsId;
		
	    formObj.appendChild(i_goodsId);
	    document.body.appendChild(formObj); 
	    formObj.method = "get";
	    formObj.action = "${contextPath}/goods/goodsDetail.do?goodsId="+goodsId;
	    formObj.submit();
		
	}
</script>  
 
<body>    
    <div id="sticky" >
	<ul>
		<li>
			<a href="https://www.facebook.com/">
		   		<img width="20" height="24" src="${contextPath}/resources/image/facebook_icon.png">
				<strong>Facebook</strong>
			</a>
		</li>
		<li>
		 <a href="https://twitter.com/?lang=ko">
		   <img width="20" height="24" src="${contextPath}/resources/image/twitter_icon.png">
			<strong>Twitter</strong>
		 </a>
		</li>
		<li>
		  <a href="https://www.instagram.com/">
		   	<img	width="20" height="24" src="${contextPath}/resources/image/instagram_icon.png">
			<strong>Instagram</strong>
		  </a>
		</li>
	</ul>
	<div class="recent">
		<h3>최근 본 상품</h3>
		  <ul>
		 <c:choose>
			<c:when test="${ empty quickGoodsList }">
			  <strong>상품이 없습니다.</strong>
			</c:when>
			<c:otherwise>
	       <form name="frm_sticky"  >	        
		      <c:forEach var="item" items="${quickGoodsList }" varStatus="itemNum">
		         <c:choose>
		           <c:when test="${itemNum.count==1 }">
			      <a href="javascript:goodsDetail();">
			  	         <img width="75" height="95" id="img_sticky" src="${contextPath}/thumbnails.do?goodsId=${item.goodsId}&fileName=${item.goodsFileName}">
			      </a>
			        <input type="hidden"  name="h_goodsId" value="${item.goodsId}" />
			        <input type="hidden" name="h_goodsFileName" value="${item.goodsFileName}" />
			      <br>
			      </c:when>
			      <c:otherwise>
			        <input type="hidden"  name="h_goodsId" value="${item.goodsId}" />
			        <input type="hidden" name="h_goodsFileName" value="${item.goodsFileName}" />
			      </c:otherwise>
			      </c:choose>
		     </c:forEach>
    		</form>		 
		   </c:otherwise>
	      </c:choose>
		 </ul>
	 </div>
	 <div>
	 <c:choose>
	    <c:when test="${ empty quickGoodsList }">
		    <h5> &emsp;&emsp;&emsp; 0/0  &nbsp; </h5>
	    </c:when>
	    <c:otherwise>
           <h5>&emsp;<a href='javascript:fn_show_previous_goods();'>이전 </a><span id="cur_goods_num">1</span>/${quickGoodsListNum} <a href='javascript:fn_show_next_goods();'> 다음 </a> </h5>
       </c:otherwise>
       </c:choose>
    </div>
</div>
</body>
</html>
 
