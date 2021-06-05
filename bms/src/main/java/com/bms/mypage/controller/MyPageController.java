package com.bms.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bms.common.util.CommonUtil;
import com.bms.member.dto.MemberDTO;
import com.bms.mypage.service.MyPageService;
import com.bms.order.dto.OrderDTO;

@Controller("myPageController")
@RequestMapping(value="/mypage")
public class MyPageController  {
	
	@Autowired
	private MyPageService myPageService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private MemberDTO memberDTO;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@RequestMapping(value="/myPageMain.do" , method = RequestMethod.GET)
	public ModelAndView myPageMain(@RequestParam(required = false , value="message") String message, HttpServletRequest request)  throws Exception {
		
		HttpSession session = request.getSession();
		
		session = request.getSession();
		session.setAttribute("side_menu", "my_page");
		
		ModelAndView mv = new ModelAndView("/mypage/myPageMain");
		memberDTO=(MemberDTO)session.getAttribute("memberInfo");
		
		String memberId = "";
		if (memberDTO != null) 	memberId = memberDTO.getMemberId();
		else 					mv.setViewName("redirect:/main/main.do");
		
		mv.addObject("message", message);
		mv.addObject("myOrderList", myPageService.listMyOrderGoods(memberId));

		return mv;
		
	}
	
	
	@RequestMapping(value="/myOrderDetail.do" , method = RequestMethod.GET)
	public ModelAndView myOrderDetail(@RequestParam("orderId") String orderId,HttpServletRequest request)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/mypage/myOrderDetail");
		HttpSession session=request.getSession();
		
		mv.addObject("orderer", (MemberDTO)session.getAttribute("memberInfo"));
		mv.addObject("myOrderList",myPageService.findMyOrderInfo(orderId));
		
		return mv;
	
	}
	
	
	@RequestMapping(value="/listMyOrderHistory.do" , method = RequestMethod.GET)
	public ModelAndView listMyOrderHistory(@RequestParam Map<String, String> dateMap, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/mypage/listMyOrderHistory");
		
		HttpSession session = request.getSession();
		memberDTO = (MemberDTO)session.getAttribute("memberInfo");
		String memberId = memberDTO.getMemberId();
		

		String fixedSearchPeriod = dateMap.get("fixedSearchPeriod");
		String search_word       = dateMap.get("search_word");
		String search_type       = dateMap.get("search_type");
		String beginDate         = "";
		String endDate           = "";
		
		String [] tempDate = commonUtil.calcSearchPeriod(fixedSearchPeriod).split(",");
		beginDate = tempDate[0];
		endDate   = tempDate[1];
		
		if(dateMap.get("search") != null ) {
			String search = dateMap.get("search");
			if(search.equals("daily")) {
				beginDate = dateMap.get("beginDate");
				endDate = dateMap.get("endDate");
			}
		}
		
		dateMap.put("beginDate", beginDate);
		dateMap.put("endDate", endDate);
		dateMap.put("memberId", memberId);
		dateMap.put("search_word"   , search_word);
		dateMap.put("search_type"   , search_type);
		
		List<OrderDTO> myOrderHistList = myPageService.listMyOrderHistory(dateMap);
		
		String beginDate1[] = beginDate.split("-");
		String endDate1[]   = endDate.split("-");
		mv.addObject("beginYear",beginDate1[0]);
		mv.addObject("beginMonth",beginDate1[1]);
		mv.addObject("beginDay",beginDate1[2]);
		mv.addObject("endYear",endDate1[0]);
		mv.addObject("endMonth",endDate1[1]);
		mv.addObject("endDay",endDate1[2]);
		mv.addObject("myOrderHistList", myOrderHistList);
		return mv;
		
	}	
	
	
	@RequestMapping(value="/cancelMyOrder.do" , method = RequestMethod.POST)
	public ModelAndView cancelMyOrder(@RequestParam("orderId") String orderId)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		myPageService.cancelOrder(orderId);
		mv.addObject("message", "cancel_order");
		mv.setViewName("redirect:/mypage/myPageMain.do");
		
		return mv;
		
	}
	
	
	@RequestMapping(value="/myDetailInfo.do" , method = RequestMethod.GET)
	public ModelAndView myDetailInfo() throws Exception {
		return new ModelAndView("/mypage/myDetailInfo");
	}	
	
	
	@RequestMapping(value="/modifyMyInfo.do" , method = RequestMethod.POST)
	public ResponseEntity<String>  modifyMyInfo(@RequestParam("attribute")  String attribute,
			                 					@RequestParam("value")  String value,
			                 					HttpServletRequest request)  throws Exception {
		
		Map<String,String> memberMap = new HashMap<String,String>();
		HttpSession session = request.getSession();
		memberDTO = (MemberDTO)session.getAttribute("memberInfo");

		String val[] = null;
		String memberId = memberDTO.getMemberId();
		
		if (attribute.equals("memberPw")) {
			memberMap.put("memberPw" , passwordEncoder.encode(value));
		}
		else if (attribute.equals("memberBirth")){
			val = value.split(",");
			memberMap.put("memberBirthY",val[0]);
			memberMap.put("memberBirthM",val[1]);
			memberMap.put("memberBirthD",val[2]);
			memberMap.put("memberBirthGn",val[3]);
		}
		else if (attribute.equals("tel")){
			val = value.split(",");
			memberMap.put("tel1",val[0]);
			memberMap.put("tel2",val[1]);
			memberMap.put("tel3",val[2]);
		}
		else if (attribute.equals("hp")){
			val = value.split(",");
			memberMap.put("hp1",val[0]);
			memberMap.put("hp2",val[1]);
			memberMap.put("hp3",val[2]);
			memberMap.put("smsstsYn", val[3]);
		}
		else if (attribute.equals("email")){
			val = value.split(",");
			memberMap.put("email1",val[0]);
			memberMap.put("email2",val[1]);
			memberMap.put("emailstsYn", val[2]);
		}
		else if (attribute.equals("address")){
			val = value.split(",");
			memberMap.put("zipcode",val[0]);
			memberMap.put("roadAddress",val[1]);
			memberMap.put("jibunAddress", val[2]);
			memberMap.put("namujiAddress", val[3]);
		}
		else {
			memberMap.put(attribute,value);	
		}
		
		memberMap.put("memberId", memberId);
		
		
		memberDTO = (MemberDTO)myPageService.modifyMyInfo(memberMap);
		session.removeAttribute("memberInfo");
		session.setAttribute("memberInfo", memberDTO);
		
		return new ResponseEntity<String>("modSuccess", new HttpHeaders(), HttpStatus.OK);
		
	}	
	
	@RequestMapping(value="/deleteMyInfo.do")
	public ModelAndView deleteMember(@RequestParam("delYn") String delYn , @RequestParam("memberId") String memberId , HttpServletRequest request)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("redirect:/main/main.do");
		
		HttpSession session = request.getSession();
		session.invalidate();
		
		HashMap<String,String> memberMap = new HashMap<String,String>();
		memberMap.put("delYn"   , delYn);
		memberMap.put("memberId", memberId);
		
		myPageService.modifyMyInfo(memberMap);
		
		return mv;
		
	}
		
	
}
