package com.bms.order.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.bms.order.dto.OrderDTO;

public interface OrderDAO {
	
	public List<OrderDTO> listMyOrderGoods(OrderDTO orderBean) throws DataAccessException;
	public void insertNewOrder(List<OrderDTO> myOrderList) throws DataAccessException;
	public OrderDTO findMyOrder(String orderId) throws DataAccessException;
	public void removeGoodsFromCart(List<OrderDTO> myOrderList)throws DataAccessException;

}
