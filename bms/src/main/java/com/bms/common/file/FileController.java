package com.bms.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.bms.goods.dto.ImageFileDTO;

import net.coobird.thumbnailator.Thumbnails;


@Controller
public class FileController {
	
	private static final String CURR_IMAGE_REPO_PATH = "C:\\file_repo";
	String seperatorPath = "\\";	// window

	//private static final String CURR_IMAGE_REPO_PATH = "/var/lib/tomcat8/file_repo";
	//String seperatorPath = "/";		// linux
	
	
	@RequestMapping("/download")
	public void download(@RequestParam("fileName") String fileName,
		                 	@RequestParam("goodsId") String goodsId,
			                 HttpServletResponse response) throws Exception {
		OutputStream out = response.getOutputStream();
		String filePath = CURR_IMAGE_REPO_PATH + seperatorPath + goodsId + seperatorPath + fileName;
		File image = new File(filePath);
		response.setHeader("Cache-Control","no-cache");	// 캐시에 저장하지 않음
		response.addHeader("Content-disposition", "attachment; fileName="+fileName);
		FileInputStream in = new FileInputStream(image); 
		byte[] buffer = new byte[1024*8];
		while (true){
			int count = in.read(buffer); 
			if (count==-1)  
				break;
			out.write(buffer,0,count);
		}
		in.close();
		out.close();
		
	}
	
	
	@RequestMapping("/thumbnails.do")
	public void thumbnails(@RequestParam("fileName") String fileName,
                              @RequestParam("goodsId") String goodsId,
			                 HttpServletResponse response) throws Exception {
		
		OutputStream out = response.getOutputStream();
		
		String filePath = CURR_IMAGE_REPO_PATH + seperatorPath + goodsId + seperatorPath + fileName;
		
		File image = new File(filePath);
		
		if (image.exists()) { 
			Thumbnails.of(image).size(121,154).outputFormat("png").toOutputStream(out);
		}
		
		byte[] buffer = new byte[1024 * 8];
		out.write(buffer);
		out.close();
		
	}
	
	
	public List<ImageFileDTO> upload(MultipartHttpServletRequest multipartRequest) throws Exception{
		
		List<ImageFileDTO> fileList= new ArrayList<ImageFileDTO>();
		Iterator<String> fileNames = multipartRequest.getFileNames();
		
		while (fileNames.hasNext()) {
			
			ImageFileDTO imageFileDTO = new ImageFileDTO();
			String fileName = fileNames.next();
			imageFileDTO.setFileType(fileName);
			
			MultipartFile mFile = multipartRequest.getFile(fileName);
			String originalFileName = mFile.getOriginalFilename();
			imageFileDTO.setFileName(originalFileName);
			fileList.add(imageFileDTO);
			
			File file = new File(CURR_IMAGE_REPO_PATH + "/" + fileName);
			if (mFile.getSize() != 0) { 
				if (!file.exists()) {
					if (file.getParentFile().mkdirs()){ 
						file.createNewFile(); 
					}
				}
				mFile.transferTo(new File(CURR_IMAGE_REPO_PATH  + seperatorPath + "temp" + seperatorPath + originalFileName)); 
			}
		}
		return fileList;
		
	}
	
	
	public void deleteFile(String fileName) {
		File file = new File(CURR_IMAGE_REPO_PATH + seperatorPath + fileName);
		try{
			file.delete();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
