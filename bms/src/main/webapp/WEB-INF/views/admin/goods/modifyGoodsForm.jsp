<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goods" value="${goodsMap.goods}" />
<c:set var="imageFileList" value="${goodsMap.imageFileList}" />
<c:choose>
	<c:when test='${not empty goods.goodsStatus}'>
		<script>
			window.onload=function() {
				var frm_mod_goods      = document.frm_mod_goods;
				var hGoodsStatus       = frm_mod_goods.hGoodsStatus;
				var goodsStatus        = hGoodsStatus.value;
				var selectGoodsStatus  = frm_mod_goods.goodsStatus;
			}		
		</script>
	</c:when>
</c:choose>
<script src="${contextPath}/resources/js/jquery-3.5.1.min.js"></script>
<script src="${contextPath}/resources/ckeditor/ckeditor.js"></script>
<link href="${contextPath }/resources/css/myStyle.css" rel="stylesheet" />
<script>

	function fn_modify_goods(goodsId, attribute){
		var frm_mod_goods=document.frm_mod_goods;
		var value="";
		
		if 	    (attribute == 'goodsSort')				 value = frm_mod_goods.goodsSort.value;
		else if (attribute == 'goodsTitle')				 value = frm_mod_goods.goodsTitle.value;
		else if (attribute == 'goodsWriter')			 value = frm_mod_goods.goodsWriter.value;   
		else if (attribute == 'goodsPublisher')		 	 value = frm_mod_goods.goodsPublisher.value;
		else if (attribute == 'goodsPrice')			 	 value = frm_mod_goods.goodsPrice.value;
		else if (attribute == 'goodsSalesPrice')		 value = frm_mod_goods.goodsSalesPrice.value;
		else if (attribute == 'goodsPoint')			 	 value = frm_mod_goods.goodsPoint.value;
		else if (attribute == 'goodsPublishedDate')	{
				var temp1 = frm_mod_goods.goodsPublishedDate.value;
				var temp2 = temp1.split("-");
				value = temp2[0] + temp2[1] + temp2[2];
		}
		else if (attribute == 'goodsTotalPage')		 	 value = frm_mod_goods.goodsTotalPage.value;
		else if (attribute == 'goodsIsbn')				 value = frm_mod_goods.goodsIsbn.value;
		else if (attribute == 'goodsDeliveryPrice')	 	 value = frm_mod_goods.goodsDeliveryPrice.value;
		else if (attribute == 'goodsDeliveryDate')	{
			var temp1 = frm_mod_goods.goodsDeliveryDate.value;
			var temp2 = temp1.split("-");
			value = temp2[0] + temp2[1] + temp2[2];
		}
		else if (attribute == 'goodsStatus')			 value = frm_mod_goods.goodsStatus.value;
		else if (attribute == 'goodsContentsOrder')	 	 value = CKEDITOR.instances.goodsContentsOrder.getData();
		else if (attribute == 'goodsWriterIntro')		 value = CKEDITOR.instances.goodsWriterIntro.getData();
		else if (attribute == 'goodsIntro')			 	 value = CKEDITOR.instances.goodsIntro.getData();
		else if (attribute == 'goodsPublisherComment') 	 value = CKEDITOR.instances.goodsPublisherComment.getData();
		else if (attribute == 'goodsRecommendation')	 value = CKEDITOR.instances.goodsRecommendation.getData();
		
		$.ajax({
			type : "post",
			url : "${contextPath}/admin/goods/modifyGoodsInfo.do",
			data : {
				goodsId   : goodsId,
				attribute : attribute,
				value     : value
			},
			success : function() {
				alert("정보를 수정했습니다.");
			}
		});
	}

	 function readURL(input,preview) {
	   if (input.files && input.files[0]) {
	       var reader = new FileReader();
	       reader.onload = function (e) {
	           $('#'+preview).attr('src', e.target.result);
	       }
	       reader.readAsDataURL(input.files[0]);
	   }
	 }  
	
	 
	 var cnt =1;
	 function fn_addFile(){
		  $("#target_add_file").append("<br>"+"<input type='file' name='detailImage"+cnt+"' id='detailImage"+cnt+"'  onchange=readURL(this,'previewImage"+cnt+"') />");
		  $("#target_add_file").append("<img id='previewImage"+cnt+" width=200 height=200/>");
		  $("#target_add_file").append("<input class='btn btn-info btn-xs' type='button' value='추가'  onClick=addNewImageFile('detailImage"+cnt+"','${imageFileList[0].goodsId}','detailImage')  />");
		  cnt++;
	 }
	 
	 
	 function modifyImageFile(fileId,goodsId, imageId,fileType){
	  	
		 var form = $('#FILE_FORM')[0];
	     var formData = new FormData(form);
	     formData.append("fileName", $('#'+fileId)[0].files[0]);
	     formData.append("goodsId", goodsId);
	     formData.append("imageId", imageId);
	     formData.append("fileType", fileType);
	     
	     $.ajax({
	       url: '${contextPath}/admin/goods/modifyGoodsImageInfo.do',
	       processData: false,
	       contentType: false,
	       data: formData,
	       type: 'POST',
	      success: function(result){
	         alert("이미지를 수정했습니다.");
	       }
	     });
	 }
	 
	 
	 function addNewImageFile(fileId,goodsId, fileType){
		 
		  var form = $('#FILE_FORM')[0];
	      var formData = new FormData(form);
	      formData.append("uploadFile", $('#'+fileId)[0].files[0]);
	      formData.append("goodsId", goodsId);
	      formData.append("fileType", fileType);
	      
	      $.ajax({
	          url: '${contextPath}/admin/goods/addNewGoodsImage.do',
	              processData: false,
	              contentType: false,
	              data: formData,
	              type: 'post',
	              success: function(result){
	                  alert("이미지를 추가했습니다.");
	              }
	        });
	  }
	 
	 
	 function deleteImageFile(goodsId,imageId,imageFileName,trId){
				
		 var tr = document.getElementById(trId);
		
		     	$.ajax({
		   		type : "post",
		   		url : "${contextPath}/admin/goods/removeGoodsImage.do",
		   		data: {
		   				goodsId		  : goodsId,
		   				imageId		  : imageId,
		    	        imageFileName : imageFileName
		    	},
		   		success : function(data, textStatus) {
		   			alert("이미지를 삭제했습니다.");
		   		},
		   		error : function(data, textStatus) {
		   			alert("에러가 발생했습니다."+textStatus);
		   		}
		   	}); 
	 	}
</script>
<style>
	td:first-child {
		text-align: center;
		font-weight: bold;
	}
</style>
</head>
<body>
	<div class="clear"></div>
	<div id="container">
		<form name="frm_mod_goods" method=post>
			<ul class="tabs">
				<li><a href="#tab1">상품 정보</a></li>
				<li><a href="#tab2">상품 목차</a></li>
				<li><a href="#tab3">저자 소개</a></li>
				<li><a href="#tab4">상품 소개</a></li>
				<li><a href="#tab5">출판사 상품 평가</a></li>
				<li><a href="#tab6">추천사</a></li>
				<li><a href="#tab7">상품 이미지</a></li>
			</ul>
			<div class="tab_container">
				<div class="tab_content" id="tab1">
					<table class="table table-bordered table-hover">
						<colgroup>
							<col width="25%">
							<col width="65%">
							<col width="10%">
						</colgroup>
						<tr>
							<td>상품 분류</td>
							<td>
								<select name="goodsSort" class="form-control" style="height:30; padding:0">
									<option value="컴퓨터와 인터넷" <c:if test="${goods.goodsSort=='컴퓨터와 인터넷' }">selected </c:if>> 컴퓨터와인터넷</option>
									<option value="디지털 기기"  <c:if test="${goods.goodsSort=='디지털 기기' }">selected </c:if>>디지털기기</option>
								</select>
							</td>
							<td><input type="button" class="btn btn-outline-primary btn-sm" value="수정" onClick="fn_modify_goods('${goods.goodsId }','goodsSort')" /></td>
						</tr>
						<tr>
							<td>상품 종류</td>
							<td>
								<select name="goodsStatus" class="form-control" style="height:30; padding:0">
									<option value="bestseller" <c:if test="${goods.goodsStatus } eq 'bestsleer'"> selected</c:if> >베스트셀러</option>
									<option value="steadyseller" <c:if test="${goods.goodsStatus } eq 'steadyseller'"> selected</c:if> >스테디셀러</option>
									<option value="newbook" <c:if test="${goods.goodsStatus } eq 'newbook'"> selected</c:if> >신간</option>
								</select> 
								<input type="hidden" name="hGoodsStatus" value="${goods.goodsStatus}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsStatus')" /></td>
						</tr>
						<tr>
							<td>상품 이름</td>
							<td><input name="goodsTitle" id="goodsTitle" type="text" class="form-control" value="${goods.goodsTitle}" /></td>
							<td><input type="button" class="btn btn-outline-primary btn-sm" value="수정" onClick="fn_modify_goods('${goods.goodsId}','goodsTitle')" /></td>
						</tr>
						<tr>
							<td>저자</td>
							<td><input name="goodsWriter" type="text" class="form-control" value="${goods.goodsWriter}" /></td>
							<td><input type="button" class="btn btn-outline-primary btn-sm" value="수정" onClick="fn_modify_goods('${goods.goodsId}','goodsWriter')" /></td>
						</tr>
						<tr>
							<td>출판사</td>
							<td><input name="goodsPublisher" type="text" class="form-control" value="${goods.goodsPublisher}" /></td>
							<td><input type="button" class="btn btn-outline-primary btn-sm" value="수정" onClick="fn_modify_goods('${goods.goodsId}','goodsPublisher')" /></td>
						</tr>
						<tr>
							<td>상품 정가</td>
							<td><input name="goodsPrice" type="text" class="form-control" value="${goods.goodsPrice}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsPrice')" /></td>
						</tr>
						<tr>
							<td>상품 판매가격</td>
							<td><input name="goodsSalesPrice" type="text" class="form-control" value="${goods.goodsSalesPrice}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsSalesPrice')" /></td>
						</tr>
						<tr>
							<td>상품 구매 포인트</td>
							<td><input name="goodsPoint" type="text" class="form-control" value="${goods.goodsPoint}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsPoint')" /></td>
						</tr>
						<tr>
							<td>상품 출판일</td>
							<td><input name="goodsPublishedDate" type="date" class="form-control" value="${goods.goodsPublishedDate}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsPublishedDate')" /></td>
						</tr>
						<tr>
							<td>상품 총 페이지수</td>
							<td><input name="goodsTotalPage" type="text" class="form-control" value="${goods.goodsTotalPage}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsTotalPage')" /></td>
						</tr>
						<tr>
							<td>ISBN</td>
							<td><input name="goodsIsbn" type="text" class="form-control" value="${goods.goodsIsbn}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsIsbn')" /></td>
						</tr>
						<tr>
							<td>상품 배송비</td>
							<td><input name="goodsDeliveryPrice" type="text" class="form-control" value="${goods.goodsDeliveryPrice}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsDeliveryPrice')" /></td>
						</tr>
						<tr>
							<td>상품 도착 예정일</td>
							<td><input name="goodsDeliveryDate" type="date"
								class="form-control" value="${goods.goodsDeliveryDate}" /></td>
							<td><input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsDeliveryDate')" /></td>
						</tr>
					</table>
				</div>
				<div class="tab_content" id="tab2">
					<div class="form-group">
						<textarea rows="50" cols="80" class="form-control" id="goodsContentsOrder" name="goodsContentsOrder">${goods.goodsContentsOrder}</textarea>
						<script>CKEDITOR.replace('goodsContentsOrder');</script>
						<p align="right">
							<input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsContentsOrder')" />
						</p>
					</div>
				</div>
				<div class="tab_content" id="tab3">
					<div class="form-group">
						<textarea rows="50" cols="80" class="form-control" id="goodsWriterIntro" name="goodsWriterIntro">${goods.goodsWriterIntro}</textarea>
						<script>CKEDITOR.replace('goodsWriterIntro');</script>
						<p align="right">
							<input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsWriterIntro')" />
						</p>
					</div>
				</div>
				<div class="tab_content" id="tab4">
					<div class="form-group">
						<textarea rows="50" cols="80" class="form-control" id="goodsIntro" name="goodsIntro">${goods.goodsIntro}</textarea>
						<script>CKEDITOR.replace('goodsIntro');</script>
						<p align="right">
							<input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId}','goodsIntro')" />
						</p>
					</div>
				</div>
				<div class="tab_content" id="tab5">
					<div class="form-group">
						<textarea rows="50" cols="80" class="form-control" id="goodsPublisherComment" name="goodsPublisherComment">${goods.goodsPublisherComment }</textarea>
						<script>CKEDITOR.replace('goodsPublisherComment');</script>
						<p align="right">
							<input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId }','goodsPublisherComment')" />
						</p>
					</div>
				</div>
				<div class="tab_content" id="tab6">
					<div class="form-group">
						<textarea rows="50" cols="80" class="form-control" id="goodsRecommendation" name="goodsRecommendation">${goods.goodsRecommendation }</textarea>
						<script>CKEDITOR.replace('goodsRecommendation');</script>
						<p align="right">
							<input type="button" value="수정" class="btn btn-outline-primary btn-sm" onClick="fn_modify_goods('${goods.goodsId }','goodsRecommendation')" />
						</p>
					</div>
				</div>
		</div>
		</form>
		<div class="tab_content" id="tab7">
			<form id="file_form" method="post" enctype="multipart/form-data">
				<h4>상품이미지</h4>
				<table class="list_view">
					<tr align="center" style="background-color : #0061f2; color:#fff; height: 50px" >
						<th>이미지 분류</th>
						<th>이미지 추가</th>
						<th colspan="2">이미지 미리보기</th>
						<th>이미지 수정</th>
					</tr>
					<c:forEach var="item" items="${imageFileList}" varStatus="itemNum">
						<c:choose>
							<c:when test="${item.fileType=='main_image'}">
								<tr>
									<td>메인 이미지</td>
									<td><input type="file" id="main_image" name="main_image"
										onchange="readURL(this,'preview${itemNum.count}');" /> 
										<input type="hidden" name="imageId" value="${item.imageId}" /><br>
									</td>
									<td><img id="preview${itemNum.count}" width=200 height=200 src="${contextPath}/download.do?goodsId=${item.goodsId}&fileName=${item.fileName}" />
									</td>
									<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td><input type="button" value="수정"
										class="btn btn-primary btn-xs"
										onClick="modifyImageFile('main_image','${item.goodsId}','${item.imageId}','${item.fileType}')" />
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr id="${itemNum.count-1}">
									<td>상세 이미지${itemNum.count-1 }</td>
									<td>
										<input type="file" name="detailImage" id="detailImage"
										onchange="readURL(this,'preview${itemNum.count}');" /> 
										<input type="hidden" name="imageId" value="${item.imageId }" />
										<br>
									</td>
									<td>
										<img id="preview${itemNum.count }" width=200 height=200 src="${contextPath}/download.do?goodsId=${item.goodsId}&fileName=${item.fileName}">
									</td>
									<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
									<td>
										<input type="button" value="수정" class="btn btn-primary btn-xs" onClick="modifyImageFile('detailImage','${item.goodsId}','${item.imageId}','${item.fileType}')" />
										<input type="button" value="삭제" class="btn btn-danger btn-xs" onClick="deleteImageFile('${item.goodsId}','${item.imageId}','${item.fileName}','${itemNum.count-1}')" />
									</td>
								</tr>
								
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<tr align="center">
			      		<td colspan="3">
					      <div id="target_add_file">
					      </div>
				       </td>
				    </tr>
					<tr>
						<td align="right" colspan="5"><input type="button" class="btn btn-outline-primary" value="추가하기" onClick="fn_addFile()" /></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>