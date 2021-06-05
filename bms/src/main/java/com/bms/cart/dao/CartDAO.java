package com.bms.cart.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.bms.cart.dto.CartDTO;
import com.bms.goods.dto.GoodsDTO;

public interface CartDAO {
	
	public List<CartDTO> selectCartList(CartDTO cartDTO) throws DataAccessException;
	public List<GoodsDTO> selectGoodsList(List<CartDTO> cartList) throws DataAccessException;
	public boolean selectCountInCart(CartDTO cartDTO) throws DataAccessException;
	public void insertGoodsInCart(CartDTO cartDTO) throws DataAccessException;
	public void updateCartGoodsQty(CartDTO cartDTO) throws DataAccessException;
	public void deleteCartGoods(int cartId) throws DataAccessException;

}
