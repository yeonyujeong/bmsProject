package com.bms.cart.service;

import java.util.List;
import java.util.Map;

import com.bms.cart.dto.CartDTO;

public interface CartService {
	
	public Map<String ,List> myCartList(CartDTO cartDTO) throws Exception;
	public boolean findCartGoods(CartDTO cartDTO) throws Exception;
	public void addGoodsInCart(CartDTO cartDTO) throws Exception;
	public void modifyCartQty(CartDTO cartDTO) throws Exception;
	public void removeCartGoods(int cart_id) throws Exception;

}
