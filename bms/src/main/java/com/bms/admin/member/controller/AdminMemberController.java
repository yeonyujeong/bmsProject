package com.bms.admin.member.controller;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bms.admin.member.service.AdminMemberService;
import com.bms.common.util.CommonUtil;
import com.bms.member.dto.MemberDTO;
import com.bms.order.dto.OrderDTO;

@Controller("adminMemberController")
@RequestMapping(value="/admin/member")
public class AdminMemberController {
	
	@Autowired
	private AdminMemberService adminMemberService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	
	@RequestMapping(value="/adminMemberMain.do")
	public ModelAndView adminMemberMain(@RequestParam Map<String, String> dateMap , HttpServletRequest request)  throws Exception{
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/member/adminMemberMain");
		
		HttpSession session = request.getSession();
		session.setAttribute("side_menu", "admin_mode");
		
		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String search_word       = dateMap.get("search_word");
		String search_type       = dateMap.get("search_type");
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
		
		
		HashMap<String,Object> condMap=new HashMap<String,Object>();
		
		condMap.put("beginDate"     , beginDate);
		condMap.put("endDate"       , endDate);
		condMap.put("search_word"   , search_word);
		condMap.put("search_type"   , search_type);
		
		String beginDate1[] = beginDate.split("-");
		String endDate2[]   = endDate.split("-");
		mv.addObject("memberList"  , adminMemberService.listMember(condMap));
		mv.addObject("beginYear"  , beginDate1[0]);
		mv.addObject("beginMonth" , beginDate1[1]);
		mv.addObject("beginDay"   , beginDate1[2]);
		mv.addObject("endYear"    , endDate2[0]);
		mv.addObject("endMonth"   , endDate2[1]);
		mv.addObject("endDay"     , endDate2[2]);
		
		
		return mv;
		
	}
	
	
	@RequestMapping(value="/memberDetail.do")
	public ModelAndView memberDetail(@RequestParam("memberId") String memberId)  throws Exception{
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/admin/member/memberDetail");
		mv.addObject("memberInfo" , adminMemberService.memberDetail(memberId));
		
		return mv;
		
	}
	
	
	@RequestMapping(value="/modifyMemberInfo.do")
	public void modifyMemberInfo(@RequestParam("memberId") String memberId , 
								@RequestParam("modType") String modType , 
								@RequestParam("value") String value , HttpServletResponse response)  throws Exception{
		
		HashMap<String,String> memberMap = new HashMap<String,String>();
		String val[]     = null;
		PrintWriter pw   = response.getWriter();
		if (modType.equals("memberPw")) {
			memberMap.put("memberPw" , passwordEncoder.encode(value));
		}
		else if(modType.equals("memberName")) {
			memberMap.put("memberName" , value);
		}
		else if (modType.equals("memberGender")) {
			memberMap.put("memberGender" , value);
		}
		else if (modType.equals("memberBirth")){
			val=value.split(",");
			memberMap.put("memberBirthY",val[0]);
			memberMap.put("memberBirthM",val[1]);
			memberMap.put("memberBirthD",val[2]);
			memberMap.put("memberBirthGn",val[3]);
		}
		else if (modType.equals("tel")){
			val=value.split(",");
			memberMap.put("tel1",val[0]);
			memberMap.put("tel2",val[1]);
			memberMap.put("tel3",val[2]);
			
		}
		else if (modType.equals("hp")){
			val=value.split(",");
			memberMap.put("hp1",val[0]);
			memberMap.put("hp2",val[1]);
			memberMap.put("hp3",val[2]);
			memberMap.put("smsstsYn", val[3]);
		}
		else if (modType.equals("email")){
			val=value.split(",");
			memberMap.put("email1",val[0]);
			memberMap.put("email2",val[1]);
			memberMap.put("emailstsYn", val[2]);
		}
		else if (modType.equals("address")){
			val=value.split(",");
			memberMap.put("zipcode",val[0]);
			memberMap.put("roadAddress",val[1]);
			memberMap.put("jibunAddress", val[2]);
			memberMap.put("namujiAddress", val[3]);
		}
		
		memberMap.put("memberId", memberId);
		
		adminMemberService.modifyMemberInfo(memberMap);
		pw.print("modSuccess");
		pw.close();		
		
	}
	
	
	@RequestMapping(value="/deleteMember.do")
	public ModelAndView deleteMember(@RequestParam("delYn") String delYn , @RequestParam("memberId") String memberId)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("redirect:/admin/member/adminMemberMain.do");
		
		HashMap<String,String> memberMap = new HashMap<String,String>();
		memberMap.put("delYn"   , delYn);
		memberMap.put("memberId", memberId);
		
		adminMemberService.modifyMemberInfo(memberMap);
		
		return mv;
		
	}
		
	
	@RequestMapping(value="/memberExcelExport.do")
	public void memberExcelExport(HttpServletResponse response , @RequestParam Map<String, String> dateMap) throws Exception {
		  

		SimpleDateFormat joinSdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat fileSdf = new SimpleDateFormat("yyyy_MM_dd_hh_mm");
		String makeFileTime = fileSdf.format(new Date());
		String makeFileName = makeFileTime + "_memberList.xls";
		
	    Workbook wb = new HSSFWorkbook();
	    Sheet sheet = wb.createSheet("회원리스트");
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
	    cell.setCellValue("회원아이디");
	    cell = row.createCell(1);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("회원이름");
	    cell = row.createCell(2);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("휴대폰번호");
	    cell = row.createCell(3);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("주소");
	    cell = row.createCell(4);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("가입일");
	    cell = row.createCell(5);
	    cell.setCellStyle(headStyle);
	    cell.setCellValue("상태");
	    
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
		
		for (MemberDTO memberDTO :  adminMemberService.listMember(condMap)) {
			row = sheet.createRow(rowNo++);
	        cell = row.createCell(0);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(memberDTO.getMemberId());
	        cell = row.createCell(1);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(memberDTO.getMemberName());
	        cell = row.createCell(2);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(memberDTO.getHp1() + "-" + memberDTO.getHp2() + "-" + memberDTO.getHp3());
	        cell = row.createCell(3);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(memberDTO.getRoadAddress() + " " + memberDTO.getJibunAddress() + " " + memberDTO.getNamujiAddress());
	        cell = row.createCell(4);
	        cell.setCellStyle(bodyStyle);
	        cell.setCellValue(joinSdf.format(memberDTO.getJoinDate()));
	        cell = row.createCell(5);
	        cell.setCellStyle(bodyStyle);
	        if (memberDTO.getDelYn().equals("N"))  cell.setCellValue("활동중");
	        if (memberDTO.getDelYn().equals("Y"))  cell.setCellValue("탈퇴");

		} 

	    response.setContentType("ms-vnd/excel");
	    response.setHeader("Content-Disposition", "attachment;filename="+makeFileName);

	    wb.write(response.getOutputStream());
	    wb.close();

		
	}
	
}
