package com.bms.admin.order.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bms.member.dto.MemberDTO;
import com.bms.order.dto.OrderDTO;

public interface AdminOrderDAO {
	
	public List<OrderDTO> selectNewOrderList(Map<String,Object> condMap) throws DataAccessException;
	public void updateDeliveryState(Map<String, String> deliveryMap) throws DataAccessException;
	public List<OrderDTO> selectOrderDetail(int orderId) throws DataAccessException;
	public MemberDTO selectOrderer(String memberId) throws DataAccessException;
	
}
