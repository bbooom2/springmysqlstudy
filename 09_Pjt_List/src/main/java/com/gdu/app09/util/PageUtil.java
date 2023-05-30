package com.gdu.app09.util;

import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter // 媛꾪샊 �젙蹂대�� 鍮쇱꽌 �뜥�빞�븷 寃쎌슦媛� �엳�뒗�뜲 洹몃윺�븣 寃뚰꽣媛� �븘�슂�븿. 媛믩뱾�쓣 蹂쇱닔留� �엳�뒗 寃뚰꽣留� �궗�슜�븯寃좎쓬.
		// �꽭�꽣�뒗 �쓽�룄�쟻�쑝濡� 類먯쓬. �꽭�꽣 �엳寃뚮릺硫� �옒紐삵븯硫� �닔�젙�븷 �닔 �엳寃� �릺�땲源�. 
public class PageUtil {

	private int page;  			// �쁽�옱 �럹�씠吏�(�뙆�씪誘명꽣濡� 諛쏆븘�삩�떎)
	private int totalRecord; 	// �쟾泥� �젅肄붾뱶 �닔(DB�뿉�꽌 援ы빐�삩�떎.)
	private int recordPerPage;  // �븳�럹�씠吏��뿉 �몴�떆�븷 �젅肄붾뱶 媛쒖닔(�뙆�씪誘명꽣濡� 諛쏆븘�삩�떎) 
	private int begin; 			// �븳�럹�씠吏��뿉 �몴�떆�븷 �젅肄붾뱶�쓽 �떆�옉 踰덊샇(怨꾩궛�븳�떎)
	
	
	// 1�럹�씠吏�遺��꽣 4�럹�씠吏�源뚯� block�씠�씪怨� �븯寃좊떎. 釉붾윮�떦 �럹�씠吏� 4媛� �엳�쓬. 
	// 5�럹�씠吏�遺��꽣 6�럹�씠吏�源뚯� 2踰덉㎏ 釉붾씫�씠�씪 �븯寃좊떎. 
	private int pagePerBlock = 5; // �븳 釉붾줉�뿉 �몴�떆�븷 �럹�씠吏��쓽 媛쒖닔(�엫�쓽濡� �젙�븳�떎) 	
	private int totalPage; 		  // �쟾泥� �럹�씠吏� 媛쒖닔(怨꾩궛�븳�떎) 
	private int beginPage; 		  // �븳 釉붾줉�뿉 �몴�떆�븷 �럹�씠吏��쓽 �떆�옉 踰덊샇(怨꾩궛�븳�떎)		
	private int endPage; 		  // �븳 釉붾줉�뿉 �몴�떆�븷 �럹�씠吏��쓽 醫낅즺 踰덊샇(怨꾩궛�븳�떎)
	
	//begin怨� end瑜� 怨꾩궛�븯湲� �쐞�빐�꽌�뒗 page, totalRecord, recordPerPage �븘�슂
	
	public void setPageUtil(int page, int totalRecord, int recordPerPage) { 
		
		// page, totalRecord, recorPerPage ���옣 
		this.page = page;
		this.totalRecord = totalRecord;
		this.recordPerPage = recordPerPage;
		
		// begin, end 怨꾩궛 
		
		/*
		 	totalRecord=26, recordPerPage=5�씤 �긽�솴 
		 	//�럹�씠吏��뿉 �뵲瑜� 鍮꾧릿怨� �뿏�뱶 怨꾩궛 
		 	
		  	page	begin 	end 
		  	 1		  1	     5
		  	 2		  6 	 10
		  	 3		  11  	 16
		  	 4        16     20
		  	 5 		  21 	 26
		  	 6 		  26	 26  // 26媛쒓� �엳�쑝誘�濡� 6�럹�씠吏��뿉�뒗 26�럹�씠吏�媛� �떆�옉�씠�옄 �걹 
		 
		 */
		
		// begin 계산
		begin = (page - 1) * recordPerPage;
		
		
		// totalPage 怨꾩궛 
		totalPage = totalRecord / recordPerPage; 
		if(totalRecord % recordPerPage != 0) {
			totalPage++;
		}
		
		// beginPage, endPage 怨꾩궛 
		/*
		 	totalPage=6, pagePerBlock=4�씤 �긽�솴 
		 	block 		beginPage 	endPage 
		 	1(1~4)			1			4
		 	2(5~6) 			5			6
		 */
		
		beginPage = ((page - 1) / pagePerBlock) * pagePerBlock + 1;
		endPage = beginPage + pagePerBlock -1; 
		if(endPage > totalPage ) { 
			endPage = totalPage;
		}
		
	}
	
	
	
	public String getPagination(String path) { // 湲곕낯 �뙣�뒪 諛쏆� �떎�쓬�뿉 
		
		// path�뿉 ?媛� �룷�븿�릺�뼱 �엳�쑝硫� �씠誘� �뙆�씪誘명꽣媛� �룷�븿�맂 寃쎈줈�씠誘�濡� &瑜� 遺숈뿬�꽌 page �뙆�씪誘명꽣瑜� 異붽��븳�떎. 
		// path = "/app09/employees/pagination.do?order=ASC" -> �썝�옒 諛쏆� �뙣�뒪 
		if(path.contains("?")) {
			path += "&";  // path = "/app09/employees/pagination.do&order=ASC" 
		} else {
			path += "?";  // path = "/app09/employees/pagination.do?"
		}
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("<div class=\"pagination\">"); 
		
		/*
		 1 2 3 4 5 > 
		 
	   < 6 7 8 9 10>
	   
	   <11
	   */
		
	   // �씠�쟾釉붾줉 : 1釉붾줉�� �씠�쟾釉붾줉�씠 �뾾怨�, �굹癒몄� 釉붾줉�� �씠�쟾釉붾줉�씠 �엳�떎. 
	   if(beginPage == 1) {
		   sb.append("<span class=\"hidden\">��</span>");
	   }else {
		     sb.append("<a class=\"link\" href=\""+ path +"page=" + (beginPage - 1) + "\">��</a>"); // �썝�븯�뒗 �럹�씠吏�濡� �룎�젮二쇰뒗 遺�遺꾩� �엳�쑝�굹 order媛� �뾾�쓬. 
	   }

	   
	   // �럹�씠吏� 踰덊샇: �쁽�옱 �럹�씠吏��뒗 留곹겕媛� �뾾�떎. 
	   for(int p = beginPage; p <= endPage; p++) {
		   if(p == page) {
			   sb.append("<span class=\"strong\">"+ p +"</span>");
		   }else {
			   sb.append("<a class=\"link\" href=\""+ path +"page="+ p +"\">" + p +"</a>");
		   }
		   
	   }
		   
		   // �떎�쓬 釉붾줉 : 留덉�留� 釉붾줉�� �떎�쓬 釉붾줉�씠 �뾾怨�, �굹癒몄� 釉붾줉�� �떎�쓬 釉붾줉�씠 �엳�떎. 
		   if(endPage == totalPage) {
			   
			   sb.append("<span class=\"hidden\">�뼳</span>");

		   }else {
			   sb.append("<a class=\"link\" href=\""+ path +"page="+ (endPage + 1) +"\">�뼳</a>");
			  
	   }

		sb.append("</div>");
	   return sb.toString();
	}
	
	
}
	
