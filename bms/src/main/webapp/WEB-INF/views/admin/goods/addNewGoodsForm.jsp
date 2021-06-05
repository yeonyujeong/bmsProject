<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />	
<!DOCTYPE html>
<meta charset="utf-8">
<head>
<script>

	var cnt = 0;
	
	function fn_addFile(){
		
		if (cnt == 0) $("#target_add_file").append("<br>"+"<input  type='file' name='main_image' id='f_main_image' />");	  
		else 		  $("#target_add_file").append("<br>"+"<input  type='file' name='detail_image"+cnt+"' />");
		cnt++;
		
	}
  
  
	function fn_add_new_goods(obj){
		 
		fileName = $('#f_main_image').val();
		 
		if (fileName != null && fileName != undefined){
			 obj.submit();
		}
		else {
			 alert("메인 이미지는 반드시 첨부해야 합니다.");
			 return;
		 }
		 
	}
</script>
<script src="${contextPath}/resources/ckeditor/ckeditor.js"></script>    
<link href="${contextPath }/resources/css/myStyle.css" rel="stylesheet" />
<style>
	td:first-child {
		text-align: center;
		font-weight: bold;
	}
</style>
</head>
<body>
	<form action="${contextPath}/admin/goods/addNewGoods.do" method="post"  enctype="multipart/form-data">
	<h1>새상품 등록창</h1>
	<div class="tab_container">
	<div class="tab_container" id="container">
		<ul class="tabs">
			<li><a href="#tab1">상품 정보</a></li>
			<li><a href="#tab2">상품 목차</a></li>
			<li><a href="#tab3">상품 저자소개</a></li>
			<li><a href="#tab4">상품 소개</a></li>
			<li><a href="#tab5">출판사 상품 평가</a></li>
			<li><a href="#tab6">추천사</a></li>
			<li><a href="#tab7">상품 이미지</a></li>
		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<table class="table table-bordered table-hover">			
					<tr>
						<td width=200>제품분류</td>
						<td width=500>
							<select name="goodsSort" class="form-control" style="padding-bottom:0; padding-top:0; height:35px">
								<option value="컴퓨터와 인터넷" selected>컴퓨터와 인터넷
								<option value="디지털 기기">디지털 기기
							</select>
						</td>
					</tr>
					<tr>
						<td>제품종류</td>
						<td>
							<select name="goodsStatus" class="form-control" style="padding-bottom:0; padding-top:0; height:35px">
								<option value="bestseller">베스트셀러</option>
								<option value="steadyseller">스테디셀러</option>
								<option value="newbook" selected >신간</option>
							</select>
						</td>
					 </tr>
					<tr>
						<td>제품 이름</td>
						<td><input name="goodsTitle" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td >저자</td>
						<td><input name="goodsWriter" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>출판사</td>
						<td><input name="goodsPublisher" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품 정가</td>
						<td><input name="goodsPrice" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품 판매가격</td>
						<td><input name="goodsSalesPrice" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품 구매 포인트</td>
						<td><input name="goodsPoint" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품출판일</td>
						<td><input  name="goodsPublishedDate" type="date" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품 총 페이지수</td>
						<td><input name="goodsTotalPage" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>ISBN</td>
						<td><input name="goodsIsbn" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품 배송비</td>
						<td><input name="goodsDeliveryPrice" type="text" class="form-control"/></td>
					</tr>
					<tr>
						<td>제품 도착 예정일</td>
						<td><input name="goodsDeliveryDate" type="date" class="form-control"/></td>
					</tr>
				</table>	
			</div>
			<div class="tab_content" id="tab2">
				<div class="form-group">
					<textarea rows="50" cols="80" class="form-control" id="goodsContentsOrder" name="goodsContentsOrder"></textarea>
			    	<script>CKEDITOR.replace('goodsContentsOrder');</script>
			    </div>
			</div>
			<div class="tab_content" id="tab3">
				<div class="form-group">
					<textarea rows="50" cols="80" class="form-control" id="goodsWriterIntro" name="goodsWriterIntro"></textarea>
			    	<script>CKEDITOR.replace('goodsWriterIntro');</script>
			    </div>
			</div>
			<div class="tab_content" id="tab4">
				<div class="form-group">
					<textarea rows="50" cols="80" class="form-control" id="goodsIntro" name="goodsIntro"></textarea>
			    	<script>CKEDITOR.replace('goodsIntro');</script>
			    </div>
			</div>
			<div class="tab_content" id="tab5">
				<div class="form-group">
					<textarea rows="50" cols="80" class="form-control" id="goodsPublisherComment" name="goodsPublisherComment"></textarea>
			    	<script>CKEDITOR.replace('goodsPublisherComment');</script>
			    </div>
			</div>
			<div class="tab_content" id="tab6">
				<div class="form-group">
					<textarea rows="50" cols="80" class="form-control" id="goodsRecommendation" name="goodsRecommendation"></textarea>
			    	<script>CKEDITOR.replace('goodsRecommendation');</script>
			    </div>
			</div>
			<div class="tab_content" id="tab7">
				<h4>상품이미지</h4>
				<table class="list_view">
					<colgroup>
						<col width="30%">
						<col width="70%">
					</colgroup>
					<tr align="center" style="background-color : #0061f2; color:#fff; height: 50px" >
						<th>이미지 분류</th>
						<th colspan="2">이미지 추가</th>
					</tr>
					<tr>
						<td>이미지파일 첨부</td>
			            <td> <input type="button"  value="파일 추가" onClick="fn_addFile()"/></td>
			            <td><div id="target_add_file"></div></td>
					</tr>
				</table>
			</div>
		</div>
		 <p align="right">
			  <input type="button" value="등록하기"  class="btn btn-outline-danger btn-sm" onClick="fn_add_new_goods(this.form)">
		 </p>
	</div>
	</div>
</form>	 