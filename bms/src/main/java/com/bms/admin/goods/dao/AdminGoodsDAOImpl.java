package com.bms.admin.goods.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bms.goods.dto.GoodsDTO;
import com.bms.goods.dto.ImageFileDTO;
import com.bms.order.dto.OrderDTO;

@Repository("adminGoodsDAO")
public class AdminGoodsDAOImpl  implements AdminGoodsDAO{
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public int insertNewGoods(Map<String,Object> newGoodsMap) throws DataAccessException {
		sqlSession.insert("mapper.admin.goods.insertNewGoods",newGoodsMap);
		return (Integer) newGoodsMap.get("goodsId");
	}
	
	@Override
	public void insertGoodsImageFile(List<ImageFileDTO> fileList)  throws DataAccessException {
		for (int i=0; i<fileList.size(); i++){
			sqlSession.insert("mapper.admin.goods.insertGoodsImageFile" , (ImageFileDTO)fileList.get(i));
		}
	}
		
	@Override
	public List<GoodsDTO>selectNewGoodsList(Map<String,Object> condMap) throws DataAccessException {
		return sqlSession.selectList("mapper.admin.goods.selectNewGoodsList",condMap);
	}
	
	@Override
	public GoodsDTO selectGoodsDetail(int goodsId) throws DataAccessException{
		return sqlSession.selectOne("mapper.admin.goods.selectGoodsDetail" , goodsId);
	}
	
	@Override
	public List<ImageFileDTO> selectGoodsImageFileList(int goodsId) throws DataAccessException {
		return sqlSession.selectList("mapper.admin.goods.selectGoodsImageFileList" , goodsId);
	}
	
	@Override
	public void updateGoodsInfo(Map<String,String> goodsMap) throws DataAccessException{
		sqlSession.update("mapper.admin.goods.updateGoodsInfo" , goodsMap);
	}
	
	@Override
	public void deleteGoodsImage(int image_id) throws DataAccessException{
		sqlSession.delete("mapper.admin.goods.deleteGoodsImage" , image_id);
	}
	
	@Override
	public List<OrderDTO> selectOrderGoodsList(Map condMap) throws DataAccessException{
		return sqlSession.selectList("mapper.admin.selectOrderGoodsList",condMap);
	}	
	
	@Override
	public void updateOrderGoods(Map orderMap) throws DataAccessException{
		sqlSession.update("mapper.admin.goods.updateOrderGoods" , orderMap);
		
	}

	@Override
	public void updateGoodsImage(List<ImageFileDTO> imageFileList) throws DataAccessException {
		
		for (int i=0; i<imageFileList.size();i++){
			ImageFileDTO imageFileDTO = imageFileList.get(i);
			sqlSession.update("mapper.admin.goods.updateGoodsImage" , imageFileDTO);	
		}
		
	}

	

}
