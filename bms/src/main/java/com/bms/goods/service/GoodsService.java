package com.bms.goods.service;

import java.util.List;
import java.util.Map;

import com.bms.goods.dto.GoodsDTO;

public interface GoodsService {
	
	public Map<String,List<GoodsDTO>> listGoods() throws Exception;
	public Map<String,Object> goodsDetail(String goodsId) throws Exception;
	public List<String> keywordSearch(String keyword) throws Exception;
	public List<GoodsDTO> searchGoods(String searchWord) throws Exception;
	public void addNewReview(Map newReviewMap) throws Exception;
	public List<Map<String , String>> selectReview(String goodsId) throws Exception;
}
