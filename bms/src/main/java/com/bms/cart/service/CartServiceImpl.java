package com.bms.cart.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bms.cart.dao.CartDAO;
import com.bms.cart.dto.CartDTO;
import com.bms.goods.dto.GoodsDTO;

@Service("cartService")
@Transactional(propagation=Propagation.REQUIRED)
public class CartServiceImpl  implements CartService{
	
	@Autowired
	private CartDAO cartDAO;
	
	public Map<String ,List> myCartList(CartDTO cartDTO) throws Exception{
		
		Map<String,List> cartMap = new HashMap<String,List>();
		
		List<CartDTO> myCartList = cartDAO.selectCartList(cartDTO);
		if(myCartList.size()==0){ 
			return null;
		}
		
		List<GoodsDTO> myGoodsList = cartDAO.selectGoodsList(myCartList);
		cartMap.put("myCartList", myCartList);
		cartMap.put("myGoodsList",myGoodsList);
		return cartMap;
		
	}
	
	
	public boolean findCartGoods(CartDTO cartDTO) throws Exception{
		 return cartDAO.selectCountInCart(cartDTO);
	}	
	
	
	public void addGoodsInCart(CartDTO cartDTO) throws Exception{
		cartDAO.insertGoodsInCart(cartDTO);
	}
	
	
	public void modifyCartQty(CartDTO cartDTO) throws Exception{
		cartDAO.updateCartGoodsQty(cartDTO);
	}
	
	
	public void removeCartGoods(int cart_id) throws Exception{
		cartDAO.deleteCartGoods(cart_id);
	}
	
}
