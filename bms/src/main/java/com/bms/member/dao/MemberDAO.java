package com.bms.member.dao;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bms.member.dto.MemberDTO;

public interface MemberDAO {
	
	public MemberDTO login(Map<String,String> loginMap) throws DataAccessException;
	public void insertNewMember(MemberDTO memberDTO) throws DataAccessException;
	public String selectOverlappedID(String id) throws DataAccessException;

}
