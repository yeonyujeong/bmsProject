
package com.bms.admin.goods.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bms.goods.dto.GoodsDTO;
import com.bms.goods.dto.ImageFileDTO;
import com.bms.order.dto.OrderDTO;

public interface AdminGoodsDAO {
	
	public int insertNewGoods(Map<String,Object> newGoodsMap) throws DataAccessException;
	public List<GoodsDTO>selectNewGoodsList(Map<String,Object> condMap) throws DataAccessException;
	public GoodsDTO selectGoodsDetail(int goodsId) throws DataAccessException;
	public List<ImageFileDTO> selectGoodsImageFileList(int goodsId) throws DataAccessException;
	public void insertGoodsImageFile(List<ImageFileDTO> fileList)  throws DataAccessException;
	public void updateGoodsInfo(Map<String,String> goodsMap) throws DataAccessException;
	public void updateGoodsImage(List<ImageFileDTO> imageFileList) throws DataAccessException;
	public void deleteGoodsImage(int image_id) throws DataAccessException;
	public List<OrderDTO> selectOrderGoodsList(Map<String,Object> condMap) throws DataAccessException;
	public void updateOrderGoods(Map<String,Object> orderMap) throws DataAccessException;
	
}
