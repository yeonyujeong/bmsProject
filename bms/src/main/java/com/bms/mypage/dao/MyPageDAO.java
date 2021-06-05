package com.bms.mypage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bms.member.dto.MemberDTO;
import com.bms.order.dto.OrderDTO;

public interface MyPageDAO {
	
	public List<OrderDTO> selectMyOrderGoodsList(String memberId) throws DataAccessException;
	public List<OrderDTO> selectMyOrderInfo(String orderId) throws DataAccessException;
	public List<OrderDTO> selectMyOrderHistoryList(Map<String,String> dateMap) throws DataAccessException;
	public void updateMyInfo(Map<String,String> memberMap) throws DataAccessException;
	public MemberDTO selectMyDetailInfo(String memberId) throws DataAccessException;
	public void updateMyOrderCancel(String orderId) throws DataAccessException;

}
