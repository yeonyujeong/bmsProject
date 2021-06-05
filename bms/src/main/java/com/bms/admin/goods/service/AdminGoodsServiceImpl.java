package com.bms.admin.goods.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bms.admin.goods.dao.AdminGoodsDAO;
import com.bms.goods.dto.GoodsDTO;
import com.bms.goods.dto.ImageFileDTO;
import com.bms.order.dto.OrderDTO;


@Service("adminGoodsService")
@Transactional(propagation=Propagation.REQUIRED)
public class AdminGoodsServiceImpl implements AdminGoodsService {
	
	@Autowired
	private AdminGoodsDAO adminGoodsDAO;
	
	
	@Override
	public int addNewGoods(Map<String,Object> newGoodsMap) throws Exception{
		
		int goodsId = adminGoodsDAO.insertNewGoods(newGoodsMap);
		ArrayList<ImageFileDTO> imageFileList = (ArrayList)newGoodsMap.get("imageFileList");
		
		for (ImageFileDTO imageFileDTO : imageFileList) {
			imageFileDTO.setGoodsId(goodsId);
		}
		
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
		
		return goodsId;
		
	}
	
	
	@Override
	public List<GoodsDTO> listNewGoods(Map<String,Object> condMap) throws Exception{
		return adminGoodsDAO.selectNewGoodsList(condMap);
	}
	
	
	@Override
	public Map<String,Object> goodsDetail(int goodsId) throws Exception {
		
		Map<String,Object> goodsMap = new HashMap<String,Object>();
		
		goodsMap.put("goods", adminGoodsDAO.selectGoodsDetail(goodsId));
		goodsMap.put("imageFileList", adminGoodsDAO.selectGoodsImageFileList(goodsId));
		
		return goodsMap;
		
	}
	
	
	@Override
	public List<ImageFileDTO> goodsImageFile(int goodsId) throws Exception{
		return adminGoodsDAO.selectGoodsImageFileList(goodsId);
	}
	
	
	@Override
	public void modifyGoodsInfo(Map<String,String> goodsMap) throws Exception{
		adminGoodsDAO.updateGoodsInfo(goodsMap);
		
	}	
	
	
	@Override
	public void modifyGoodsImage(List<ImageFileDTO> imageFileList) throws Exception{
		adminGoodsDAO.updateGoodsImage(imageFileList); 
	}
	
	
	@Override
	public List<OrderDTO> listOrderGoods(Map<String,Object> condMap) throws Exception{
		return adminGoodsDAO.selectOrderGoodsList(condMap);
	}
	
	
	@Override
	public void modifyOrderGoods(Map<String,Object> orderMap) throws Exception{
		adminGoodsDAO.updateOrderGoods(orderMap);
	}
	
	
	@Override
	public void removeGoodsImage(int image_id) throws Exception{
		adminGoodsDAO.deleteGoodsImage(image_id);
	}
	
	
	@Override
	public void addNewGoodsImage(List<ImageFileDTO> imageFileList) throws Exception{
		adminGoodsDAO.insertGoodsImageFile(imageFileList);
	}
	
}
