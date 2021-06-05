package com.bms.admin.member.service;

import java.util.List;
import java.util.Map;

import com.bms.member.dto.MemberDTO;

public interface AdminMemberService {
	
	public List<MemberDTO> listMember(Map<String,Object> condMap) throws Exception;
	public MemberDTO memberDetail(String memberId) throws Exception;
	public void modifyMemberInfo(Map<String,String> memberMap) throws Exception;
	
}
