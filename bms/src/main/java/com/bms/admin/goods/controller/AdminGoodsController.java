package com.bms.admin.goods.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor.HSSFColorPredefined;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.bms.admin.goods.service.AdminGoodsService;
import com.bms.common.file.FileController;
import com.bms.common.util.CommonUtil;
import com.bms.goods.dto.GoodsDTO;
import com.bms.goods.dto.ImageFileDTO;
import com.bms.member.dto.MemberDTO;

@Controller("adminGoodsController")
@RequestMapping(value="/admin/goods")
public class AdminGoodsController {
	
	private static final String CURR_IMAGE_REPO_PATH = "C:\\file_repo";
	String seperatorPath = "\\";	// window

	//private static final String CURR_IMAGE_REPO_PATH = "/var/lib/tomcat8/file_repo";
	//String seperatorPath = "/";		// linux
	
	@Autowired
	private AdminGoodsService adminGoodsService;
	
	@Autowired
	private FileController fileController;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@RequestMapping(value="/adminGoodsMain.do")
	public ModelAndView adminGoodsMain(@RequestParam Map<String, String> dateMap , HttpServletRequest request)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/goods/adminGoodsMain");
		
		HttpSession session = request.getSession();
		session.setAttribute("side_menu", "admin_mode"); 
		
		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String search_type       = dateMap.get("search_type");
		String search_word       = dateMap.get("search_word");
		String [] tempDate       = null; 
		String beginDate         = "";
		String endDate           = "";
		
		
		if (dateMap.get("beginDate") == null && dateMap.get("endDate") == null ) {
			tempDate = commonUtil.calcSearchPeriod(fixedSearchPeriod).split(",");
			beginDate = tempDate[0];
			endDate = tempDate[1];
		} 
		else {
			beginDate = dateMap.get("beginDate");
			endDate = dateMap.get("endDate");
		}
		
		Map<String,Object> condMap=new HashMap<String,Object>();
		
	
		condMap.put("beginDate" , beginDate);
		condMap.put("endDate"   , endDate);
		condMap.put("search_type", search_type);
		condMap.put("search_word", search_word);
		
		mv.addObject("newGoodsList", adminGoodsService.listNewGoods(condMap));
		
		String beginDate1[] = beginDate.split("-");
		String endDate2[]   = endDate.split("-");
		mv.addObject("beginYear",beginDate1[0]);
		mv.addObject("beginMonth",beginDate1[1]);
		mv.addObject("beginDay",beginDate1[2]);
		mv.addObject("endYear",endDate2[0]);
		mv.addObject("endMonth",endDate2[1]);
		mv.addObject("endDay",endDate2[2]);
		
		
		return mv;
		
	}

	
	@RequestMapping(value="/addNewGoodsForm.do")
	public String addNewGoodsForm() {
		return "/admin/goods/addNewGoodsForm";
	}
	
	
	@RequestMapping(value="/addNewGoods.do" , method = RequestMethod.POST)
	public ResponseEntity<String> addNewGoods(MultipartHttpServletRequest multipartRequest , HttpServletResponse response) throws Exception {
		
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String imageFileName = "";
		
		Map<String,Object> newGoodsMap = new HashMap<String,Object>();
		Enumeration<?> enu = multipartRequest.getParameterNames();
		while (enu.hasMoreElements()){
			String name  = (String)enu.nextElement();
			String value = multipartRequest.getParameter(name);
			newGoodsMap.put(name,value);
		}
		
		HttpSession session = multipartRequest.getSession();
		MemberDTO memberDTO = (MemberDTO) session.getAttribute("memberInfo");
		String regId = "";
		if (memberDTO != null)
			regId = memberDTO.getMemberId();
		
		List<ImageFileDTO> imageFileList = fileController.upload(multipartRequest); //이미지를 저장소에 저장
		if (imageFileList != null && imageFileList.size() != 0) {
			for (ImageFileDTO imageFileDTO : imageFileList) {
				imageFileDTO.setRegId(regId);
			}
			newGoodsMap.put("imageFileList", imageFileList);
		}
		
		String message = "";
		ResponseEntity<String> resEntity = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			
			int goodsId = adminGoodsService.addNewGoods(newGoodsMap);
			if (imageFileList != null && imageFileList.size() != 0) {
				for (ImageFileDTO  imageFileDTO : imageFileList) {
					imageFileName = imageFileDTO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + "temp" + seperatorPath + imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH + seperatorPath + goodsId);
					FileUtils.moveFileToDirectory(srcFile, destDir,true); // 파일 이동
				}
			}
			message= "<script>";
			message += " alert('성공적으로 등록되었습니다.');";
			message +=" location.href='" + multipartRequest.getContextPath() + "/admin/goods/addNewGoodsForm.do';";
			message +=("</script>");
			
		} catch (Exception e) {
			if (imageFileList!=null && imageFileList.size() != 0) {
				for (ImageFileDTO imageFileDTO : imageFileList) {
					imageFileName = imageFileDTO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + "temp" + seperatorPath + imageFileName);
					srcFile.delete();
				}
			}
			
			message= "<script>";
			message += " alert('등록에 실패하였습니다.');";
			message +=" location.href='" + multipartRequest.getContextPath() + "/admin/goods/addNewGoodsForm.do';";
			message +=("</script>");
			e.printStackTrace();
		}
		
		resEntity = new ResponseEntity<String>(message, responseHeaders, HttpStatus.OK);
		
		return resEntity;
		
	}
	
	
	@RequestMapping(value="/modifyGoodsForm.do")
	public ModelAndView modifyGoodsForm(@RequestParam("goodsId") int goodsId)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/goods/modifyGoodsForm");
		mv.addObject("goodsMap",adminGoodsService.goodsDetail(goodsId));
		
		return mv;
		
	}
	
	
	@RequestMapping(value="/modifyGoodsInfo.do" , method=RequestMethod.POST)
	public ResponseEntity<String> modifyGoodsInfo(@RequestParam("goodsId") String goodsId,
			                     		     @RequestParam("attribute") String attribute,
			                     		     @RequestParam("value") String value)  throws Exception {
		
		Map<String,String> goodsMap = new HashMap<String,String>();
		goodsMap.put("goodsId" , goodsId);
		goodsMap.put(attribute , value);
		adminGoodsService.modifyGoodsInfo(goodsMap);
		
		return new ResponseEntity<String>("modSuccess", new HttpHeaders(), HttpStatus.OK);

	}
	

	@RequestMapping(value="/modifyGoodsImageInfo.do" ,method={RequestMethod.POST})
	public void modifyGoodsImageInfo(MultipartHttpServletRequest multipartRequest, HttpServletResponse response)  throws Exception {
		
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		String imageFileName = "";
		
		Map<String,Object> goodsMap = new HashMap<String,Object>();
		Enumeration<?> enu = multipartRequest.getParameterNames();
		
		while (enu.hasMoreElements()) {
			String name  = (String)enu.nextElement();
			String value = multipartRequest.getParameter(name);
			goodsMap.put(name,value);
		}
		
		HttpSession session = multipartRequest.getSession();
		MemberDTO memberDTO = (MemberDTO) session.getAttribute("memberInfo");
		String regId = "";
		if (memberDTO != null)
			regId = memberDTO.getMemberId();
		
		List<ImageFileDTO> imageFileList = null;
		int goodsId=0;
		int imageId=0;
		try {
			imageFileList = fileController.upload(multipartRequest);
			if (imageFileList!= null && imageFileList.size()!=0) {
				for (ImageFileDTO imageFileDTO : imageFileList) {
					goodsId = Integer.parseInt((String)goodsMap.get("goodsId"));
					imageId = Integer.parseInt((String)goodsMap.get("imageId"));
					imageFileDTO.setGoodsId(goodsId);
					imageFileDTO.setImageId(imageId);
					imageFileDTO.setRegId(regId);
				}
				
			    adminGoodsService.modifyGoodsImage(imageFileList);
				for (ImageFileDTO imageFileDTO : imageFileList) {
					imageFileName = imageFileDTO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + "temp" + seperatorPath + imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH + seperatorPath + goodsId);
					FileUtils.moveFileToDirectory(srcFile, destDir,true);
				}
			}
		} catch (Exception e) {
			if (imageFileList!=null && imageFileList.size()!=0) {
				for (ImageFileDTO  imageFileDTO:imageFileList) {
					imageFileName = imageFileDTO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + "temp" + seperatorPath + imageFileName);
					srcFile.delete();
				}
			}
			e.printStackTrace();
		}
		
	}
	

	@RequestMapping(value="/addNewGoodsImage.do" , method=RequestMethod.POST)
	public void addNewGoodsImage(MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception {
	
		multipartRequest.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		String imageFileName = "";
		
		Map<String,String> goodsMap = new HashMap<String, String>();
		Enumeration<?> enu = multipartRequest.getParameterNames();
		while (enu.hasMoreElements()){
			String name  = (String)enu.nextElement();
			String value = multipartRequest.getParameter(name);
			goodsMap.put(name,value);
		}
		
		HttpSession session = multipartRequest.getSession();
		MemberDTO memberDTO = (MemberDTO) session.getAttribute("memberInfo");
		String regId = "";
		if (memberDTO != null)
			regId = memberDTO.getMemberId();
		
		List<ImageFileDTO> imageFileList = null;
		int goodsId=0;
		try {
			imageFileList = fileController.upload(multipartRequest);
			if (imageFileList!= null && imageFileList.size()!=0) {
				for (ImageFileDTO imageFileDTO : imageFileList) {
					goodsId = Integer.parseInt((String)goodsMap.get("goodsId"));
					imageFileDTO.setGoodsId(goodsId);
					imageFileDTO.setRegId(regId);
				}
				
			    adminGoodsService.addNewGoodsImage(imageFileList);
				for (ImageFileDTO  imageFileDTO:imageFileList) {
					imageFileName = imageFileDTO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + "temp" + seperatorPath + imageFileName);
					File destDir = new File(CURR_IMAGE_REPO_PATH + seperatorPath + goodsId);
					FileUtils.moveFileToDirectory(srcFile, destDir,true);
				}
			}
		} catch (Exception e) {
			if (imageFileList!=null && imageFileList.size()!=0) {
				for (ImageFileDTO  imageFileDTO:imageFileList) {
					imageFileName = imageFileDTO.getFileName();
					File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + "temp"+ seperatorPath + imageFileName);
					srcFile.delete();
				}
			}
			e.printStackTrace();
		}
	}

	
	@RequestMapping(value="/removeGoodsImage.do" ,method=RequestMethod.POST)
	public void removeGoodsImage(@RequestParam("goodsId") int goodsId,
			                     @RequestParam("imageId") int imageId,
			                     @RequestParam("imageFileName") String imageFileName) throws Exception {
		
		adminGoodsService.removeGoodsImage(imageId);
		try {
			File srcFile = new File(CURR_IMAGE_REPO_PATH + seperatorPath + goodsId + seperatorPath + imageFileName);
			srcFile.delete();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value="/goodsExcelExport.do")
	public void goodsExcelExport(HttpServletResponse response , @RequestParam Map<String, String> dateMap) throws Exception {
		  

		SimpleDateFormat fileSdf = new SimpleDateFormat("yyyy_MM_dd_hh_mm");
		SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-MM-dd");
		String makeFileTime = fileSdf.format(new Date());
		String makeFileName = makeFileTime + "_goodsList.xls";
		
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("상품리스트");
	    Row row = null;
	    Cell cell = null;

	    int rowNo = 0;


	    CellStyle headStyle = wb.createCellStyle();
	    headStyle.setBorderTop(BorderStyle.THIN);
	    headStyle.setBorderBottom(BorderStyle.THIN);
	    headStyle.setBorderLeft(BorderStyle.THIN);
	    headStyle.setBorderRight(BorderStyle.THIN);


	    headStyle.setFillForegroundColor(HSSFColorPredefined.YELLOW.getIndex());
	    headStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

	    headStyle.setAlignment(HorizontalAlignment.CENTER);



	    CellStyle bodyStyle = wb.createCellStyle();
	    bodyStyle.setBorderTop(BorderStyle.THIN);
	    bodyStyle.setBorderBottom(BorderStyle.THIN);
	    bodyStyle.setBorderLeft(BorderStyle.THIN);
	    bodyStyle.setBorderRight(BorderStyle.THIN);


	    row = sheet.createRow(rowNo++);
	    cell = row.createCell(0);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("상품번호");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("상품이름");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("저자");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("출판사");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("상품가격");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("입고일자");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("출판일");


		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");		
		String search_type       = dateMap.get("search_type");
		String search_word       = dateMap.get("search_word");
		String [] tempDate       = null; 
		String beginDate         = "";
		String endDate           = "";
		
		if (dateMap.get("beginDate") == null && dateMap.get("endDate") == null ) {
			tempDate = commonUtil.calcSearchPeriod(fixedSearchPeriod).split(",");
			beginDate = tempDate[0];
			endDate = tempDate[1];
		} 
		else {
			beginDate = dateMap.get("beginDate");
			endDate = dateMap.get("endDate");
		}
		
		Map<String,Object> condMap=new HashMap<String,Object>();
		
		condMap.put("beginDate" , beginDate);
		condMap.put("endDate"   , endDate);
		condMap.put("search_type", search_type);
		condMap.put("search_word", search_word);
		
		for (GoodsDTO goodsDTO :  adminGoodsService.listNewGoods(condMap)) {
			row = sheet.createRow(rowNo++);
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(goodsDTO.getGoodsId());
	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(goodsDTO.getGoodsTitle());
	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(goodsDTO.getGoodsWriter());
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(goodsDTO.getGoodsPublisher());
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(goodsDTO.getGoodsPrice());
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(dateSdf.format(goodsDTO.getGoodsCredate()));
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(dateSdf.format(goodsDTO.getGoodsPublishedDate()));
		} 


	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename="+makeFileName);

	    wb.write(response.getOutputStream());
	    wb.close();

		
	}
	
	
}
