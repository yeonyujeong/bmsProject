package com.bms.goods.controller;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.javassist.compiler.Parser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.bms.common.util.CommonUtil;
import com.bms.goods.dto.GoodsDTO;
import com.bms.goods.service.GoodsService;
import com.bms.member.dto.MemberDTO;
import com.bms.order.dto.OrderDTO;

import net.sf.json.JSONObject;

@Controller("goodsController")
@RequestMapping(value="/goods")
public class GoodsController {
	
	@Autowired
	private GoodsService goodsService;
	
	
	@RequestMapping(value="/goodsDetail.do" ,method = RequestMethod.GET)
	public ModelAndView goodsDetail(@RequestParam("goodsId") String goodsId, HttpServletRequest request) throws Exception {

		
		HttpSession session = request.getSession();
		Map<String,Object> goodsMap = goodsService.goodsDetail(goodsId);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/goods/goodsDetail");
		mv.addObject("goodsMap", goodsMap);
		MemberDTO memberDTO = (MemberDTO)session.getAttribute("memberInfo");
		GoodsDTO GoodsDTO=(GoodsDTO)goodsMap.get("GoodsDTO");
		mv.addObject("memberDTO" , memberDTO);
		addGoodsInQuick(goodsId,GoodsDTO,session);
		List<Map<String , String>> reviewList = goodsService.selectReview(goodsId);
		mv.addObject("reviewList" , reviewList);
		return mv;
		
	}

	@RequestMapping(value="/addNewReview.do", method=RequestMethod.POST)
	public String addNewReview (@RequestParam("goodsId") String goodsId,
		                              @RequestParam("reviewer") String reviewer,	
		                              @RequestParam("review") String review	,
		                              HttpServletRequest request, 
		                              HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		Map<String,Object> newReviewMap = new HashMap<String,Object>();
		int goodsNum = Integer.parseInt(goodsId);
		newReviewMap.put("goodsId", goodsNum);
		newReviewMap.put("reviewer", reviewer);
		newReviewMap.put("review", review);
		goodsService.addNewReview(newReviewMap);
		
		String referer = request.getHeader("Referer");
	    return "redirect:"+ referer;
		
		
	}	
	
	@RequestMapping(value="/searchGoods.do" ,method = RequestMethod.GET)
	public ModelAndView searchGoods(@RequestParam("searchWord") String searchWord) throws Exception{
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/goods/searchGoods");
		mv.addObject("goodsList", goodsService.searchGoods(searchWord));
		
		return mv;
		
	}
	
	
	private void addGoodsInQuick(String goodsId,GoodsDTO GoodsDTO,HttpSession session){
		
		boolean already_existed=false;
		List<GoodsDTO> quickGoodsList =(ArrayList<GoodsDTO>)session.getAttribute("quickGoodsList");
		
		if (quickGoodsList != null){
			if (quickGoodsList.size() < 4){ 
				for (int i=0; i<quickGoodsList.size();i++){
					GoodsDTO goodsBean = quickGoodsList.get(i);
					if (goodsId.equals(goodsBean.getGoodsId())){
						already_existed=true;
						break;
					}
				}
				if (already_existed==false){
					quickGoodsList.add(GoodsDTO);
				}
			}
			
		}
		else {
			quickGoodsList = new ArrayList<GoodsDTO>();
			quickGoodsList.add(GoodsDTO);
			
		}
		session.setAttribute("quickGoodsList"    , quickGoodsList);
		session.setAttribute("quickGoodsListNum" , quickGoodsList.size());
	}
	
}
