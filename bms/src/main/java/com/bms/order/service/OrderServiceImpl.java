package com.bms.order.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bms.order.dao.OrderDAO;
import com.bms.order.dto.OrderDTO;


@Service("orderService")
@Transactional(propagation=Propagation.REQUIRED)
public class OrderServiceImpl implements OrderService {
	
	@Autowired
	private OrderDAO orderDAO;
	
	public List<OrderDTO> listMyOrderGoods(OrderDTO orderDTO) throws Exception{
		return orderDAO.listMyOrderGoods(orderDTO);
	}
	
	public void addNewOrder(List<OrderDTO> myOrderList) throws Exception{
		orderDAO.insertNewOrder(myOrderList);
		orderDAO.removeGoodsFromCart(myOrderList);
	}	
	
	public OrderDTO findMyOrder(String orderId) throws Exception{
		return orderDAO.findMyOrder(orderId);
	}

}
