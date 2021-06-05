package com.bms.admin.order.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.servlet.ModelAndView;

import com.bms.admin.goods.service.AdminGoodsService;
import com.bms.admin.order.service.AdminOrderService;
import com.bms.common.util.CommonUtil;
import com.bms.order.dto.OrderDTO;

@Controller("adminOrderController")
@RequestMapping(value="/admin/order")
public class AdminOrderController {
	
	@Autowired
	private AdminOrderService adminOrderService;
	private AdminGoodsService adminGoodsService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@RequestMapping(value="/adminOrderMain.do")
	public ModelAndView adminOrderMain(@RequestParam Map<String, String> dateMap , HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/order/adminOrderMain");

		HttpSession session = request.getSession();
		session.setAttribute("side_menu", "admin_mode"); 
		
		String fixedSearchPeriod  = dateMap.get("fixedSearchPeriod");
		String section            = dateMap.get("section");
		String pageNum            = dateMap.get("pageNum");
		String search_type        = dateMap.get("search_type");
		String search_word        = dateMap.get("search_word");
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
		
		if (section== null) section = "1";
		if (pageNum== null) pageNum = "1";
			
		condMap.put("section"   , section);
		condMap.put("pageNum"   , pageNum);
		condMap.put("beginDate" , beginDate);
		condMap.put("endDate"   , endDate);
		condMap.put("pageNum",pageNum);
		condMap.put("search_type", search_type);
		condMap.put("search_word", search_word);
		List<OrderDTO> newOrderList = adminOrderService.listNewOrder(condMap);
		mv.addObject("newOrderList",newOrderList);
		
		
		String beginDate1[] = beginDate.split("-");
		String endDate2[] = endDate.split("-");
		mv.addObject("beginYear",beginDate1[0]);
		mv.addObject("beginMonth",beginDate1[1]);
		mv.addObject("beginDay",beginDate1[2]);
		
		mv.addObject("endYear",endDate2[0]);
		mv.addObject("endMonth",endDate2[1]);
		mv.addObject("endDay",endDate2[2]);
		mv.addObject("section", section);
		mv.addObject("pageNum", pageNum);
		
		return mv;
		
	}

	
	@RequestMapping(value="/modifyDeliveryState.do" ,method={RequestMethod.POST})
	public ResponseEntity<String> modifyDeliveryState(@RequestParam Map<String, String> deliveryMap)  throws Exception {
		adminOrderService.modifyDeliveryState(deliveryMap);
		return new ResponseEntity<String>("modSuccess", new HttpHeaders(), HttpStatus.OK);
	}
	
	
	@RequestMapping(value="/orderDetail.do")
	public ModelAndView orderDetail(@RequestParam("orderId") int orderId) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/order/orderDetail");
		mv.addObject("orderMap", adminOrderService.orderDetail(orderId));

		return mv;
		
	}
	
	@RequestMapping(value="/orderExcelExport.do")
	public void orderExcelExport(HttpServletResponse response , @RequestParam Map<String, String> dateMap) throws Exception {
		  

		SimpleDateFormat orderTime = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		SimpleDateFormat fileSdf = new SimpleDateFormat("yyyy_MM_dd_hh_mm");
		String makeFileTime = fileSdf.format(new Date());
		String makeFileName = makeFileTime + "_orderList.xls";
		
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("주문리스트");
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
	    cell.setCellValue("주문번호");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("주문시간");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("주문자");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("주문자 연락처");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("수령자");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("수령자 연락처");
	    cell = row.createCell(6);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("주문상품명");
	    cell = row.createCell(7);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("수량");
	    cell = row.createCell(8);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("배송상태");


		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String section           = dateMap.get("section");	
		String pageNum           = dateMap.get("pageNum");
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
		
		if (section== null) section = "1";
		if (pageNum== null) pageNum = "1";
		condMap.put("section"   , section);
		condMap.put("pageNum"   , pageNum);
		condMap.put("beginDate" , beginDate);
		condMap.put("endDate"   , endDate);
		condMap.put("search_type", search_type);
		condMap.put("search_word", search_word);
		
		for (OrderDTO orderDTO :  adminOrderService.listNewOrder(condMap)) {
			row = sheet.createRow(rowNo++);
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getOrderId());
	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderTime.format(orderDTO.getPayOrderTime()));
	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getOrdererName());
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getOrdererHp());
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getReceiverName());
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getReceiverHp1() + "-" + orderDTO.getReceiverHp2() + "-" + orderDTO.getReceiverHp3());
	        cell = row.createCell(6);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getGoodsTitle());
	        cell = row.createCell(7);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(orderDTO.getOrderGoodsQty());
	        cell = row.createCell(8);
	        cell.setCellStyle(bodyStyle);
	        if (orderDTO.getDeliveryState().equals("deliveryPrepared")) cell.setCellValue("배송준비중");
	        if (orderDTO.getDeliveryState().equals("delivering")) cell.setCellValue("배송중");
	        if (orderDTO.getDeliveryState().equals("finishedDelivering")) cell.setCellValue("배송완료");
	        if (orderDTO.getDeliveryState().equals("cancelOrder")) cell.setCellValue("주문취소");
	        if (orderDTO.getDeliveryState().equals("returningGoods")) cell.setCellValue("반품");
		} 


	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename="+makeFileName);

	    wb.write(response.getOutputStream());
	    wb.close();

		
	}
	
}
