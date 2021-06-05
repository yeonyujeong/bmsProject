package com.bms.cart.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bms.cart.dto.CartDTO;
import com.bms.goods.dto.GoodsDTO;

@Repository("cartDAO")
public class CartDAOImpl implements CartDAO {
	
	@Autowired
	private SqlSession sqlSession;
	
	public List<CartDTO> selectCartList(CartDTO cartDTO) throws DataAccessException {
		return sqlSession.selectList("mapper.cart.selectCartList" , cartDTO);
	}

	public List<GoodsDTO> selectGoodsList(List<CartDTO> cartList) throws DataAccessException {
		return sqlSession.selectList("mapper.cart.selectGoodsList" , cartList);
	}
	
	public boolean selectCountInCart(CartDTO cartDTO) throws DataAccessException {
		String  result =sqlSession.selectOne("mapper.cart.selectCountInCart" , cartDTO);
		return Boolean.parseBoolean(result);
	}

	public void insertGoodsInCart(CartDTO cartDTO) throws DataAccessException{
		int cartId = selectMaxCartId();
		cartDTO.setCartId(cartId);
		sqlSession.insert("mapper.cart.insertGoodsInCart" , cartDTO);
	}
	
	public void updateCartGoodsQty(CartDTO cartDTO) throws DataAccessException{
		sqlSession.insert("mapper.cart.updateCartGoodsQty" , cartDTO);
	}
	
	public void deleteCartGoods(int cartId) throws DataAccessException{
		sqlSession.delete("mapper.cart.deleteCartGoods" , cartId);
	}

	private int selectMaxCartId() throws DataAccessException{
		return sqlSession.selectOne("mapper.cart.selectMaxCartId");
	}

}
