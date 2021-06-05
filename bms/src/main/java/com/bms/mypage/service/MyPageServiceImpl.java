package com.bms.mypage.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bms.member.dto.MemberDTO;
import com.bms.mypage.dao.MyPageDAO;
import com.bms.order.dto.OrderDTO;

@Service("myPageService")
@Transactional(propagation=Propagation.REQUIRED)
public class MyPageServiceImpl  implements MyPageService {
	
	@Autowired
	private MyPageDAO myPageDAO;

	public List<OrderDTO> listMyOrderGoods(String memberId) throws Exception{
		return myPageDAO.selectMyOrderGoodsList(memberId);
	}
	
	
	public List<OrderDTO> findMyOrderInfo(String orderId) throws Exception{
		return myPageDAO.selectMyOrderInfo(orderId);
	}
	
	
	public List<OrderDTO> listMyOrderHistory(Map<String,String> dateMap) throws Exception{
		return myPageDAO.selectMyOrderHistoryList(dateMap);
	}
	
	
	public MemberDTO modifyMyInfo(Map<String,String> memberMap) throws Exception{
		 String memberId = (String)memberMap.get("memberId");
		 myPageDAO.updateMyInfo(memberMap);
		 return myPageDAO.selectMyDetailInfo(memberId);
	}
	
	
	public void cancelOrder(String orderId) throws Exception{
		myPageDAO.updateMyOrderCancel(orderId);
	}
	
	
	public MemberDTO myDetailInfo(String memberId) throws Exception{
		return myPageDAO.selectMyDetailInfo(memberId);
	}
	
}
