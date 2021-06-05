package com.bms.cart.controller;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bms.cart.dto.CartDTO;
import com.bms.cart.service.CartService;
import com.bms.member.dto.MemberDTO;

@Controller("cartController")
@RequestMapping(value="/cart")
public class CartController {
	
	@Autowired
	private CartService cartService;
	
	@Autowired
	private CartDTO cartDTO;
	
	@Autowired
	private MemberDTO memberDTO;
	
	@RequestMapping(value="/myCartList.do" , method = RequestMethod.GET)
	public ModelAndView myCartMain(HttpServletRequest request)  throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/cart/myCartList");
		
		HttpSession session = request.getSession();
		MemberDTO memberDTO = (MemberDTO)session.getAttribute("memberInfo");
		String memberId = "";
		if (memberDTO != null)
			memberId = memberDTO.getMemberId();
		cartDTO.setMemberId(memberId);
		
		Map<String ,List> cartMap = cartService.myCartList(cartDTO);
		
		session.setAttribute("cartMap", cartMap);
		return mv;
	
	}
	
	
	@RequestMapping(value="/addGoodsInCart.do" ,method = RequestMethod.POST , produces = "application/text; charset=utf8")
	public @ResponseBody String addGoodsInCart(@RequestParam("goodsId") int goodsId,
												@RequestParam("cartGoodsQty") int cartGoodsQty , 
												HttpServletRequest request)  throws Exception{
		
		HttpSession session = request.getSession();
		Boolean isLogOn = (Boolean)session.getAttribute("isLogOn");
		
		
		memberDTO = (MemberDTO)session.getAttribute("memberInfo");
		String memberId="";
		if (memberDTO != null)
			memberId = memberDTO.getMemberId();
		
		cartDTO.setMemberId(memberId);
		cartDTO.setGoodsId(goodsId);
		cartDTO.setCartGoodsQty(cartGoodsQty);
		boolean isAreadyExisted = cartService.findCartGoods(cartDTO);
		
		if (isAreadyExisted) {
			return "already_existed";
		}
		else {
			cartService.addGoodsInCart(cartDTO);
			return "add_success";
		}
	
	}
	
	@RequestMapping(value="/modifyCartQty.do" ,method = RequestMethod.POST)
	public @ResponseBody String  modifyCartQty(@RequestParam("goodsId") int goodsId,
			                                   @RequestParam("cartGoodsQty") int cartGoodsQty,
			                                    HttpServletRequest request)  throws Exception{
		
		HttpSession session=request.getSession();
		memberDTO=(MemberDTO)session.getAttribute("memberInfo");
		
		String memberId="";
		if (memberDTO != null)
			memberId = memberDTO.getMemberId();
		
		cartDTO.setGoodsId(goodsId);
		cartDTO.setMemberId(memberId);
		cartDTO.setCartGoodsQty(cartGoodsQty);
		cartService.modifyCartQty(cartDTO);
		
		return "modify_success";
		
	}
	
	
	@RequestMapping(value="/removeCartGoods.do" , method = RequestMethod.GET)
	public ModelAndView removeCartGoods(@RequestParam("cartId") int cartId) throws Exception { 
		
		ModelAndView mv = new ModelAndView();
		cartService.removeCartGoods(cartId);
		mv.setViewName("redirect:/cart/myCartList.do");
		
		return mv;
	
	}
}
