package com.bms.member.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bms.member.dto.MemberDTO;

@Repository("memberDAO")
public class MemberDAOImpl  implements MemberDAO{
	@Autowired
	private SqlSession sqlSession;	
	
	@Override
	public MemberDTO login(Map<String,String> loginMap) throws DataAccessException{
	   return sqlSession.selectOne("mapper.member.login",loginMap);
	}
	
	@Override
	public void insertNewMember(MemberDTO memberDTO) throws DataAccessException{
		sqlSession.insert("mapper.member.insertNewMember",memberDTO);
	}

	@Override
	public String selectOverlappedID(String id) throws DataAccessException {
		return sqlSession.selectOne("mapper.member.selectOverlappedID",id);
	}
	
	
}
