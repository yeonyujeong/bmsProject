package com.bms.admin.member.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.bms.member.dto.MemberDTO;

@Repository("adminMemberDao")
public class AdminMemberDAOImpl  implements AdminMemberDAO{
	
	@Autowired
	private SqlSession sqlSession;
	
	public List<MemberDTO> listMember(Map<String,Object> condMap) throws DataAccessException{
		return sqlSession.selectList("mapper.admin.member.listMember" , condMap);
	}
	
	public MemberDTO memberDetail(String memberId) throws DataAccessException{
		return sqlSession.selectOne("mapper.admin.member.memberDetail" , memberId);
	}
	
	public void modifyMemberInfo(Map<String,String> memberMap) throws DataAccessException{
		sqlSession.update("mapper.admin.member.modifyMemberInfo" , memberMap);
	}
	
}
