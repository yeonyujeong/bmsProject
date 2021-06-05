package com.bms.admin.order.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bms.admin.order.dao.AdminOrderDAO;
import com.bms.member.dto.MemberDTO;
import com.bms.order.dto.OrderDTO;


@Service("adminOrderService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminOrderServiceImpl implements AdminOrderService {
	
	@Autowired
	private AdminOrderDAO adminOrderDAO;
	
	public List<OrderDTO>listNewOrder(Map<String,Object> condMap) throws Exception{
		return adminOrderDAO.selectNewOrderList(condMap);
	}
	
	
	@Override
	public void  modifyDeliveryState(Map<String, String> deliveryMap) throws Exception{
		adminOrderDAO.updateDeliveryState(deliveryMap);
	}
	
	
	@Override
	public Map<String,Object> orderDetail(int orderId) throws Exception{
		
		Map<String,Object> orderMap = new HashMap<String,Object>();
		
		List<OrderDTO> orderList = adminOrderDAO.selectOrderDetail(orderId);
		OrderDTO deliveryInfo = (OrderDTO)orderList.get(0);
		String memberId     = (String)deliveryInfo.getMemberId();
		MemberDTO orderer     = adminOrderDAO.selectOrderer(memberId);
		
		orderMap.put("orderList"    , orderList);
		orderMap.put("deliveryInfo" , deliveryInfo);
		orderMap.put("memberId"    , memberId);
		orderMap.put("orderer"      , orderer);
		
		return orderMap;
		
	}

	
	

}
