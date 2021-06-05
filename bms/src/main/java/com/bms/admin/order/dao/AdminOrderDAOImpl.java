package com.bms.admin.order.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bms.member.dto.MemberDTO;
import com.bms.order.dto.OrderDTO;

@Repository("adminOrderDAO")
public class AdminOrderDAOImpl  implements AdminOrderDAO{
	
	@Autowired
	private SqlSession sqlSession;
	
	public List<OrderDTO>selectNewOrderList(Map<String,Object> condMap) throws DataAccessException{
		return sqlSession.selectList("mapper.admin.order.selectNewOrderList" , condMap);
	}
	
	
	public void  updateDeliveryState(Map<String, String> deliveryMap) throws DataAccessException{
		sqlSession.update("mapper.admin.order.updateDeliveryState" , deliveryMap);
	}
	
	
	public List<OrderDTO> selectOrderDetail(int orderId) throws DataAccessException{
		return sqlSession.selectList("mapper.admin.order.selectOrderDetail" , orderId);
	}


	public MemberDTO selectOrderer(String memberId) throws DataAccessException{
		return sqlSession.selectOne("mapper.admin.order.selectOrderer" , memberId);
		
	}

}
