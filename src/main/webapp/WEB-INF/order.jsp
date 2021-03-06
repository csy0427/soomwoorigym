<!-- 웹폰트: Noto Sans Korean -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400&display=swap" rel="stylesheet">
     <!-- 헤더 CSS -->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/template_header.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/orderpage.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/template_footer.css"/>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import = "woorigym.user.model.vo.UserTable" %>
    <%
    UserTable user = (UserTable)session.getAttribute("loginSS");
  %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리짐 결제페이지</title>
<style>
        /* reset */
        * {
            margin:0; 
            padding:0;
        }
        body {
        font-family: 'Noto Sans KR', sans-serif;
		}
        /* content */
        section {
            width: 1200px;
            padding: 30px 0 30px 0;
        }
#ordersection{
	margin : auto;
	width : 1000px;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript">
    // cart 와 product 불러와서 상품 정보 불러오는 js
    var totalpro = "";
    $(document).ready(function () {
    	
        //해당하는 상품정보 불러오기
        $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
            type: "post",
            url: "orderproduct",
            async: false,
            data: { user_id: "<%=user.getUser_id() %>" },
            dataType: "json", // 전달받을 객체는 JSON 이다.
            success: function (data) {
                var product = data;
                console.log(product);
                var ptext = "";
                var p = 0;
                for (var i in product) {
                    let pricecomma = comma(product[i].price);
                    console.log(pricecomma);
                    ptext += "<tr id='productinfos"+p+"'><td><img  id='productimg"+p+"' src='http://via.placeholder.com/50'></td> <td id=productno" + p + ">" + product[i].productNo + "</td><td>" + product[i].productName + "</td><td id=product" + p + ">" + pricecomma + "원<td></tr>";
                    p++; 
                }
                $("#productinfo").append(ptext);
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"구매상품 정보 불러오기 실패");
                }
        });
        //카트에서 상품 수량 가져오기
        $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
            type: "post",
            url: "order",
            async: false,
            data: { user_id: "<%=user.getUser_id() %>" },
            dataType: "json", // 전달받을 객체는 JSON 이다.
            success: function (data) {
                var cart = data;
                console.log(cart);
                var ctext = "";

                var p = 0;
                var producttotal = 0;
                for (var i in cart) { // 상품번호도 상세주문내역 생성 메소드 호출 시 넘길 수 있도록 td 태그 추가 --10.14
                    let priceXquant = ((1 * cart[i].cartQuantity) * (1 * minusComma($('#product' + p).text())));
                    ctext += "<tr id='cartinfos"+p+"'><td style='display:none' id='cartprono"+p+"'>" + cart[i].productNo + "</td><td id='cartquan"+p+"'>" + cart[i].cartQuantity + "</td><td id='pXq"+p+"'>" + comma(priceXquant) + "원" + "</td><td>" + comma(parseInt(priceXquant * 0.05)) + "원</td><td><button onclick='delProduct("+p+")' class='delproduct'>삭제</button></td><td style='display:none' id='cartno"+p+"'>" + cart[i].cartNo + "</td></tr>";
                    producttotal += priceXquant;//cart[i].cartNo; <td style='display:none' id='cartno"+p+"'>" + cart[i].cartNo + "</td>
                    p++;
                }
                $("#cartinfo").append(ctext);
                $("#producttotal").append(comma(producttotal) + "원");
                $("#totalprice").text(comma(producttotal) + "원");
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"장바구니 정보 불러오기 실패");
                }
            
        });
        
       /* setInterval(function () {
           //TODO 총 결제 예상 금액 반복 계산
		   var loop = 0;
           var sumPxQ = 0;
           do{
        	   sumPxQ += 1 * minusComma($("#pXq"+loop+"").text());
        	   loop++;
           }while(loop<50);
           $("#totalprice").val(comma(sumPxQ) + "원");
           $("#producttotal").val(comma(sumPxQ));
        }, 100);
        */
        
        //setinterval 을 활용하지 않는 상품 금액 계산으로 수정
        
        var sumPxQ_1 = 0;
    	for(var i = 0 ; i < 100 ; i++) {
    		sumPxQ_1 += 1 * minusComma($("#pXq"+i+"").text());
    	};
        $("#totalprice").val(comma(sumPxQ_1) + "원");
        $("#producttotal").val(comma(sumPxQ_1));

        
        //상품번호 리스트 만들기
        var pnolist = ""
    	for(var i = 0 ; i < $("#productinfo > tbody > tr").length-1  ; i++) {
    		pnolist += $("#productno"+i+"").text()+",";
    	};
    	
    	$("#pnolist").val(pnolist);
    	
    	// 상품 썸네일 불러오기
    	$.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
            type: "post",
            url: "orderproductimg",
            async: false,
            data: { pnoList : pnolist },
            dataType: "json", // 전달받을 객체는 JSON 이다.
            success: function (data) {
               //alert("구매상품 이미지 불러오기 성공 : "+data);
              //  alert(data[0]);
              //  alert(data[1]);
              //  alert(data.length);
              //  $("#imgtest").html("<img src='http://woorigym.dothome.co.kr/product/CARDIO-RN-0004/01번 메인 1,990,000.jpg'>");
               //id='productinfos"+p+"'
               for(var i=0 ; i < data.length ; i++){
            	   $("#productimg"+i+"").attr("src",data[i]);
            	   $("#productimg"+i+"").attr("width","50");
            	   $("#productimg"+i+"").attr("height","50");
               }
               
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"구매상품 이미지 불러오기 실패");
                }
        });
    	
        
    }); // ready
    
    $(document).on("click", ".delproduct", function() {
      //TODO 총 결제 예상 금액 반복 계산
		   var loop = 0;
     var sumPxQ = 0;
     do{
  	   sumPxQ += 1 * minusComma($("#pXq"+loop+"").text());
  	   loop++;
     }while(loop< $("#productinfo > tbody > tr").length +10);
     $("#totalprice").val(comma(sumPxQ) + "원");
     $("#producttotal").val(comma(sumPxQ));
     
    });
    
    
   
    //콤마 제거
    function minusComma(value) {
        value = value.replace(/[^\d]+/g, "");
        return value;
    }

    //콤마 추가
    function comma(str) {
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }
    
    function delProduct(n){
    	$("#productinfos"+n+"").remove();
    	$("#cartinfos"+n+"").remove();
    	
    }

</script>

<script type="text/javascript">

    //주문자정보 불러오기
    $(document).ready(function () {
        //해당하는 상품정보 불러오기
        $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
            type: "post",
            url: "orderuserinfo",
            data: { user_id: "<%=user.getUser_id() %>" },
            dataType: "json", // 전달받을 객체는 JSON 이다.
            success: function (data) {
                console.log("주문자 정보 호출 성공");
                var userinfo = data[0];
                console.log(userinfo);
                $("#uname").text(userinfo.user_name);
                $("#uphone").text(userinfo.phone.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3"));
				var totalphone = userinfo.phone;
				var phone1 = totalphone.substring(0,3);
				var phone2 = totalphone.substring(3,7);
				var phone3 = totalphone.substring(7,11);
				$("#phone_no1").val(phone1);
				$("#phone_no2").val(phone2);
				$("#phone_no3").val(phone3);

                $("#availmile").val(userinfo.mileage);
 				$("#insertmile").on("propertychange change keyup paste input", function () {
                	
                	if(1 * userinfo.mileage > 1 * $("#insertmile").val()){
                   		 $("#availmile").val(userinfo.mileage - (1 * $("#insertmile").val()));
                   	} else if(1* $("#availmile").val() < 1 * $("#insertmile").val()){
                   		$("#insertmile").val(userinfo.mileage);
                   		$("#availmile").val(0);
                   	}else if(1* $("#availmile").val() == 1 * $("#insertmile").val()){
                   		$("#availmile").val(0);
                   		$("#insertmile").val(userinfo.mileage);
                   	}
                });
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"주문자 정보 불러오기 실패");
                }
        });
        
        
    }); // ready
</script>

<script type="text/javascript">
var fixaddr0 = "";
var fixaddr1 = "";
var fixaddr2 = "";
var fixaddrno = "";
    // 배송지 정보 불러오기
    $(document).ready(function () {
    	
        
        $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
            type: "post",
            url: "orderaddress",
            async:false,
            data: { user_id: "<%=user.getUser_id() %>" },
            dataType: "json", // 전달받을 객체는 JSON 이다.
            success: function (data) {
                console.log("주소지 정보 호출 성공");
                var addressinfo = data;
                console.log(addressinfo);
                fixaddrno = addressinfo[0].address_no;
                fixaddr0 = addressinfo[0].postcode;
                fixaddr1 = addressinfo[0].basic_address;
                fixaddr2 = addressinfo[0].detail_address;
                
                $("#addressno").val(fixaddrno);
                $("#postcode").val(fixaddr0);
                $("#basicaddr").val(fixaddr1);
                $("#detailaddr").val(fixaddr2);
                
               
                /*
                var p = 1;
                for (p in addressinfo) {
                    var seladdr = " <option>" + addressinfo[p].postcode + " // " + addressinfo[p].basic_address + " // " + addressinfo[p].detail_address + " </option>";
                    $("#selectaddress").append(seladdr);
                    p++;
                }
                */
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"주소지 정보 불러오기 실패");
                }
            
        });
        
    }); // ready
    function fixedaddr(){
    	console.log(fixaddrno);
    	$("#addressno").val(fixaddrno);
    	$("#postcode").val(fixaddr0);
        $("#basicaddr").val(fixaddr1);
        $("#detailaddr").val(fixaddr2);
        $("#ordermemo").val("");
    	
        $("#postcode").attr("readonly" ,true);
        $("#basicaddr").attr("readonly",true);
        $("#detailaddr").attr("readonly",true);
        
    }
    function clearaddr(){
    	$("#postcode").attr("readonly" ,false);
        $("#basicaddr").attr("readonly",false);
        $("#detailaddr").attr("readonly",false);
        
    	$("#addressno").val("");
    	$("#postcode").val("");
        $("#basicaddr").val("");
        $("#detailaddr").val("");
        $("#ordermemo").val("");
    	
    }
    /*
    function chageaddrSelect() {
        if ($("#selectaddress option:selected")) {
            if ($("#selectaddress option:selected").val() != "배송지 목록에서 선택") {
                var addr = $("#selectaddress option:selected").val().split(" // ");
                $("#postcode").val(addr[0]);
                $("#baiscaddr").val(addr[1]);
                $("#detailaddr").val(addr[2]);
            }
        };
    } 
    */
    


</script>

<!-- 우편번호 api 적용 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
       function findAddr(){
           new daum.Postcode({
               oncomplete: function(data) {
                    
                   console.log(data);
                    
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
                    // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var roadAddr = data.roadAddress; // 도로명 주소 변수
                    var jibunAddr = data.jibunAddress; // 지번 주소 변수
                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('postcode').value = data.zonecode;
                    if(roadAddr !== ''){
                        document.getElementById("basicaddr").value = roadAddr;
                    } 
                    else if(jibunAddr !== ''){
                        document.getElementById("basicaddr").value = jibunAddr;
                    }
                }
            }).open();
        }
</script>

<!--  배송지 목록창 띄우고 값 받아오기 -->
<script type="text/javascript">
    
        var openWin;
    
        function selectAddr()
        {
        	$("#addressno").val("");
        	$("#postcode").val("");
            $("#basicaddr").val("");
            $("#detailaddr").val("");
            $("#ordermemo").val("");
            
        	$("#postcode").attr("readonly" ,true);
            $("#basicaddr").attr("readonly",true);
            $("#detailaddr").attr("readonly",true);
            
            
            // window.name = "부모창 이름"; 
            window.name = "parentForm";
            // window.open("open할 window", "자식창 이름", "팝업창 옵션");
            openWin = window.open("useraddress",
                    "childForm", "width=700, height=350, resizable = no, scrollbars = no, left=400px , top=300px" );    
        }
 
   </script>

<script type="text/javascript">
// 결제 정보 js



    $(document).ready(function () {
    	//적립금  입력칸 클릭하면 0 지워주기 10.14 추가
    	$("#insertmile").click(function(){
    		console.log($("#insertmile").val());
    		if($("#insertmile").val()==0){
    			$("#insertmile").val('');
    		}
    	});
    	// 적립금 입력칸에 빈칸 입력시 0으로 만들어주기 10.14 추가
    	$("#insertmile").focusout(function(){
    		if($("#insertmile").val()==''){
    			$("#insertmile").val(0);
    		}
    	})
    	
    	
        //쿠폰불러오기
        $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
            type: "post",
            url: "ordercoupon",
            data: { user_id: "<%=user.getUser_id() %>" },
            dataType: "json", // 전달받을 객체는 JSON 이다.
            success: function (data) {
                console.log("쿠폰 정보 호출 성공");
                var couponinfo = data;
                // console.log(couponinfo[0].c_discount);
                var p = 0;
                var selcoun ="";
                for (p in couponinfo) {
                    selcoun = "<tr> <td id='c_name" + p + "'>" + couponinfo[p].c_name + " </td><td id='c_name" + p + "dis'>" + couponinfo[p].c_discount + " </td><td style='display:none'>" + couponinfo[p].coupon_no + "</td><td><button class='coupbtn'>적용하기</button></td></tr>";
                    var selcoup = " <span id='c_name" + p + "dis' style='display:none'>" + couponinfo[p].c_discount + " </span><span id='c_name" + p + "no' style='display:none'>" + couponinfo[p].coupon_no + " </span>";
                    $("#coupontable").append(selcoun);
                    $("#payinfo").append(selcoup);
                    p++;
                }
            },
            error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"쿠폰 정보 불러오기 실패");
                }
        });

    	/*
        var totalnum = 1 * $("#totalprice").text().replace(/[^0-9]/g, '');
        console.log("확인 : " + totalnum);
	
        setInterval(function () {
        	 if (1*minusComma($("#totalprice").val()) >= 100000) {
                 $("#shippingpay").val(0);
             } else {
                 $("#shippingpay").val(2500);
             }
        	 //$("#totalprice").val(comma(sumPxQ) + "원");
        },100);

        setInterval(function () {
           	
        	var finalpay = 1*minusComma($("#totalprice").val()) - (1 * $("#insertmile").val()) - (1 * $("#coudiscount").val()) + (1 * $("#shippingpay").val())
            if(finalpay<0) finalpay = 0;
            $("#finalpay").val(comma(finalpay)+"원");
            $("#finalpay2").val(comma(finalpay)+"원");
            $("#finalpay3").val(comma(finalpay)+"원");
 
        }, 100);
        
        */
    	 var totalnum = 1 * $("#totalprice").text().replace(/[^0-9]/g, '');
         console.log("확인 : " + totalnum);
 	
         
         	 if (1*minusComma($("#totalprice").val()) >= 100000) {
                  $("#shippingpay").val(0);
              } else {
                  $("#shippingpay").val(2500);
              }
         	 //$("#totalprice").val(comma(sumPxQ) + "원");
            	
         	var finalpay = 1*minusComma($("#totalprice").val()) - (1 * $("#insertmile").val()) - (1 * $("#coudiscount").val()) + (1 * $("#shippingpay").val())
             if(finalpay<0) finalpay = 0;
             $("#finalpay").val(comma(finalpay)+"원");
             $("#finalpay2").val(comma(finalpay)+"원");
             $("#finalpay3").val(comma(finalpay)+"원");
       
    }); //ready
    
    $(document).on("click", ".delproduct", calculation);
    //$(document).on("click", ".coupbtn", calculation);
    $(document).on("keyup", "#insertmile", calculation);
    
    function calculation() {
   	 var totalnum = 1 * $("#totalprice").text().replace(/[^0-9]/g, '');
        console.log("확인 : " + totalnum);
	
        
        	 if (1*minusComma($("#totalprice").val()) >= 100000) {
                 $("#shippingpay").val(0);
             } else {
                 $("#shippingpay").val(2500);
             }
        	 //$("#totalprice").val(comma(sumPxQ) + "원");
        	var finalpay = 1*minusComma($("#totalprice").val()) - (1 * $("#insertmile").val()) - (1 * $("#coudiscount").val()) + (1 * $("#shippingpay").val())
            if(finalpay<0) finalpay = 0;
            $("#finalpay").val(comma(finalpay)+"원");
            $("#finalpay2").val(comma(finalpay)+"원");
            $("#finalpay3").val(comma(finalpay)+"원");
   }
   
    
    
  //카드결제 선택 시
  /*
  var openPay;
  
    function cardpay() {
    	$("#paymethodno").val(0);
    	 // window.name = "부모창 이름"; 
    	 console.log("카드결제");
        window.name = "parentForm";
        // window.open("open할 window", "자식창 이름", "팝업창 옵션");
        openPay = window.open("cardpayment",
                "childForm", "width=700, height=350, resizable = no, scrollbars = no, left=400px , top=300px" );
        
    };
    */
    
    //무통장입금 선택 시
    /*
    function transferpay() {
    	$("#paymethodno").val(1);
    	 // window.name = "부모창 이름"; 
    	 console.log("무통장입금");
        window.name = "parentForm";
        // window.open("open할 window", "자식창 이름", "팝업창 옵션");
        openPay = window.open("depositpayment",
                "childForm", "width=700, height=350, resizable = no, scrollbars = no, left=400px , top=300px" );
        
    };
    var timer = setInterval(checkChild, 500);
    */
    
	// 결제창이 닫히면 db에 주문내역, 주문상세내역 생성 후 화면 넘어가기 기능 10.11추가 10.12 기능 구현
</script>


    
    </head>
<body>
		<!-- 공통헤더 템플릿 -->
 	<%@ include file="template_header.jsp"%>
<section id="ordersection">
  <div class="orderform">
        
        <h3> ⦁ 주문 상품 정보 </h3><br>
        <table id="productinfo" style=" float: left;">
            <tr>
                <th></th>
                <th>상품명</th>
                <th>가격</th>
            </tr>
        </table>
        <table id="cartinfo">
            <tr>
                <th>수량</th>
                <th>총 가격</th>
                <th>적립금</th>
                <th></th>
            </tr>
        </table>
	<br>
        <span id="totalspan">▸ 총 결제 예상 금액 : <input type="text" id="producttotal" readonly>원</span>
    </div>  
    <br>
     <div class="orderform">
          <br> <h3> ⦁ 주문자 정보</h3><br>
            <table id="userinfo">
                <tr>
                    <th> 이름 </th>
                    <td id="uname"></td>
                </tr>
                <tr>
                    <th> 연락처 </th>
                    <td id="uphone"></td>
                </tr>
            </table>
        </div>
 <br>
 <div class="orderform">
<br> <h3>⦁ 배송지 정보 입력</h3><br>
            
            <table id="addressuinfo">
                <tr>
                    <th>배송지 선택</th>
                    <td><input type="radio" name="addrtype" checked="checked" class="existaddr" onclick="fixedaddr()" id="addrid1"><label for="addrid1">기본 주소 선택</label> &nbsp&nbsp <input type="radio" name="addrtype" class="existaddr" onclick="selectAddr()" id="addrid2"><label for="addrid2">배송주소록에서 선택</label>&nbsp&nbsp 
                    <!-- <select id="selectaddress" onchange="chageaddrSelect()">
        <option>배송지 목록에서 선택</option> </select> -->
 <input type="radio" name="addrtype" id="newaddr" onclick="clearaddr()"> <label for="newaddr">새 주소 입력</label></td>
                </tr>
                <tr>
                    <th>받는 이</th>
                    <td><input type="text" id="receiver_name" value="<%=user.getUser_name() %>"></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><input type="text" class="phone_no" id="phone_no1" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"> - <input type="text" class="phone_no" id="phone_no2" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"> - <input type="text" class="phone_no" id="phone_no3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"></td>
                </tr>
                <tr>
                    <th rowspan="2">주소<br><br><br>  </th>
                    <td><input type="text" id="postcode" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" readonly> <button onclick="findAddr()">우편번호 찾기</button></td>
                </tr>
                <tr>
                    <td><input type="text" id="basicaddr" readonly></td>
                </tr>
                <tr>
                    <th>상세주소</th>
                    <td><input type="text" id="detailaddr" readonly></td>
                </tr>
               
                <tr>
                    <th>요청사항</th>
                    <td><textarea  cols="36" rows="5" style="resize: none;" id="ordermemo"></textarea></td>
                </tr>
            </table>
            
        </div>
 <div class="orderform">
 <br><h3> ⦁ 결제 정보 입력</h3><br>
          
            <table id="payinfo">
                <tr><th>총 상품 가격 </th><td><input type="text" id="totalprice" readonly></td></tr>
                <tr><th>적립금 사용 </th><td id="usemile"><input type="text" value="0" id="insertmile" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>&nbsp&nbsp현재 잔액 : <input type="text" id="availmile" readonly></td></tr>
                <tr><th>쿠폰 사용 </th><td id="usecoupon"><button id="couponmodal">쿠폰 선택</button> <input type="text" value="적용 안함" readonly id="appliedcpn">&nbsp&nbsp적용 금액 : <input id="coudiscount" value="0" readonly></td></tr>
                <tr><th>배송비 </th><td> <input type="text"  id="shippingpay" readonly> &nbsp&nbsp*총 상품 가격 10만원 이상이면 배송비 무료</td></tr>
                <tr><th>총 결제 금액</th><td><input type="text" id="finalpay" readonly> </td></tr>
                <tr><th>결제 수단</th><td> <input type="radio" name="paymethod" id="cardmodalbtn"><label for="cardmodalbtn">신용카드</label>&nbsp&nbsp&nbsp <input type="radio" name="paymethod"  id="depomodalbtn"><label for="depomodalbtn">무통장입금</label></td></tr>
            </table>
            
        </div>
          <p id="submitAll">
  <input type="submit" value="결제 완료" id="submitinfo">
        </p>
</section>

<input type="text" id="addressno" style='display:none'>
<input type="text" id="paymethodno" style='display:none'>
<input type="text" id="couponno" style='display:none'>
<input type="text" id="prono" style='display:none'>
<input type="text" id="proquan" style='display:none'>
<input type="text" id="cartnolist">
<input type="text" id="pnolist">

<!--  modal box-->
    <div id="modal_01" class="modal">
        <div class="modal-content" id="cardmodaldiv">
            <p class="close" align="right" class="xbtn">&#10006;</p>
            
            <table id="whichcard">
        <tr>
            <th>카드사 선택</th>
            <td> <select name="card" id="card1">
                <option value="none">카드사 선택</option>
                <option value="shinhan">신한카드</option>
                <option value="bccard">BC카드</option>
                <option value="hyundai">현대카드</option>
              </select></td>
        </tr>
        <tr>
            <th>카드 번호</th>
            <td><input size='2' id="card2-1"> - <input size='2' id="card2-2"> - <input size='2' id="card2-3"></td>
        </tr>
        <tr>
            <th>cvc 번호</th>
            <td><input size='2' id="card3"></td>
        </tr>
    </table><br>총 결제 금액 : <input type="text" id="finalpay2" readonly><br><br>
                <span><button class="close" name="ordersubmit">완료</button></span>
        </div>
    </div>
    <div id="modal_02" class="modal">
        <div class="modal-content" id="depomodaldiv">
            <p class="close" align="right" class="xbtn">&#10006;</p>
                <table id="whichbank">
        <tr>
            <th>입금자명</th>
            <td><input size="5" id="deponame"></td>
        </tr>
        <tr>
            <th>입금은행</th>
            <td> <select name="bank" id="bank">
                <option value="none">은행 선택</option>
                <option value="shinhan">신한은행</option>
                <option value="woori">우리은행</option>
                <option value="kookmin">국민은행</option>
              </select></td>
        </tr>
        <tr>
            <th>계좌번호</th>
            <td><input placeholder="-없이 입력해주세요." id="deponumber"></td>
        </tr>
    </table>
				<br>총 결제 금액 : <input type="text" id="finalpay3" readonly><br><br>
				<p>아래 계좌로 결제 금액 만큼 입금해주세요.</p>
				<p>입금은행 : 신한은행 <br>
				예금주 : 우리짐<br>
				계좌번호 : 123-123-123456 </p><br>
                <span><button class="close" name="ordersubmit">완료</button></span>

        </div>
    </div>
    <!-- 쿠폰 목록 modal -->
    <div id="modal_03" class="modal">
        <div class="modal-content" id="modal-coupon">
            <p class="close" align="right">&#10006;</p>
            <br>
          
            <table style="float:right">
             <tr>
            <td style='display : none'>적용 안함</td>
            <td style='display : none'>0</td>
            <td><button class="coupbtn">적용 취소</button></td>
            </tr>
            </table>
           
            <table id="coupontable">
            <tr>
            	<th>쿠폰명</th>
            	<th>적용 금액</th>
            	<th></th>
            </tr>
            </table>

        </div>
    </div>

   <%@ include file="template_footer.jsp"%>
    <script>
        $("#submitinfo").click(function(){
        	 if($("#postcode").val()==""){
        		   alert("우편번호를 입력해주세요.");
        		   $("#postcode").focus();
        	   } else if($("#basicaddr").val()==""){
        		   alert("주소를 입력해주세요.");
        		   $("#basicaddr").focus();
        	   } else if($("#detailaddr").val()==""){
        		   alert("상세주소를 입력해주세요.");
        		   $("#detailaddr").focus();
        	   } else if($("#receiver_name").val()==""){
        		   alert("받는 사람 이름을 입력해주세요.");
        		   $("#receiver_name").focus();
        	   } else if($("#phone_no1").val()==""){
        		   alert("전화번호를 정확히 입력해주세요.");
        		   $("#phone_no1").focus();
        	   }  else if($("#phone_no2").val()==""){
        		   alert("전화번호를 정확히 입력해주세요.");
        		   $("#phone_no2").focus();
        	   } else if($("#phone_no3").val()==""){
        		   alert("전화번호를 정확히 입력해주세요.");
        		   $("#phone_no3").focus();
        	   } else if($("#productinfo > tbody > tr").length < 2){
        		   alert("최소 1개 이상의 구매 상품이 있어야 합니다.");
        		   $("#productinfo").focus();
        	   } else {
        		   //카드결제
                  	if($("input[id=cardmodalbtn]:radio").is(":checked")) {
                  		$("#paymethodno").val(0);
                          $("#modal_01").show();
                  		
                  	} else if($("input[id=depomodalbtn]:radio").is(":checked")){
                  		//무통장입금
                      	$("#paymethodno").val(1);
                          $("#modal_02").show();
                  	} else{
                  		alert("결제 수단을 선택해 주세요.");
                  	}
        	   }
       
        		   
        	 
        		 //카드결제
               	/*
               	if($("input[id=cardmodalbtn]:radio").is(":checked")) {
               		$("#paymethodno").val(0);
                       $("#modal_01").show();
               		
               	} else if($("input[id=depomodalbtn]:radio").is(":checked")){
               		//무통장입금
                   	$("#paymethodno").val(1);
                       $("#modal_02").show();
               	} else{
               		alert("결제 수단을 선택해 주세요.");
               	}
        		 */
        		   
        	   
        });

        $(".close").click(function(){
            $(".modal").hide();
        });
        $("#couponmodal").click(function(){
            $("#modal_03").show();
        });
        
        $(document).on("click",".coupbtn",function(){ 
        	var coupname= $(this).parent().parent().children().eq(0).text();
        	var coupapply=$(this).parent().parent().children().eq(1).text();
        	var coupapplyno=$(this).parent().parent().children().eq(2).text();
        	console.log(coupname);
        	$("#appliedcpn").val(coupname);
        	$("#coudiscount").val(coupapply);
        	$("#couponno").val(coupapplyno);
        	
        	calculation();
        	
        	
        	if($("#couponno").val() == "적용 취소"){
        		$("#couponno").val("");
        	}
        	
        	
        	$("#modal_03").hide();
        	


        });


        
        
	
        /*
        $(window).on("click", function(e){
            var modal = document.getElementById("modal_01");
            if(e.target == modal){
                $(".modal").hide();
            }
        });
        */
    </script>
    
    <script>
    
    $("button[name=ordersubmit]").click(function(){
    	if($("input[id=cardmodalbtn]:radio").is(":checked")){
    		if($("#card1 option:selected").val()=="none"){
    			alert("카드사를 선택해 주세요");
    			$("#modal_01").show();   
    			return;
    		} else if($("#card2-1").val()==""){
    			alert("카드번호를 입력해 주세요");
    			$("#modal_01").show();
    			return;
    		} else if($("#card2-2").val()==""){
    			alert("카드번호를 입력해 주세요");    
    			$("#modal_01").show();
    			return;
    		} else if($("#card2-3").val()==""){
    			alert("카드번호를 입력해 주세요"); 
    			$("#modal_01").show();
    			return;
    		} else if($("#card3").val()==""){
    			alert("cvc번호를 입력해 주세요");   
    			$("#modal_01").show();
    			return;
    		} 
    		
    		 } else if($("input[id=depomodalbtn]:radio").is(":checked")){
    		if($("#bank option:selected").val()=="bank"){
    			alert("은행을 선택해 주세요");
    			$("#modal_02").show();
    			return;
    		} else if($("#deponame").val()==""){
    			alert("입금자명을 입력해 주세요");
    			$("#modal_02").show();
    			return;
    		} else if($("#deponumber").val()==""){
    			alert("계좌번호를 입력해 주세요");
    			$("#modal_02").show();
    			return;
    		}
    		
    		 } // if deposit 

           	 console.log("정보넘기기");  
           	 console.log($(".existaddr").is(":checked"));  
           	 
           	 // 배송지 새주소일때는 새 주소 생성후 값 넘기고
           	 // 기존 주소지 일 때는 addressno와 함께 한번에 넘기기
           	 // 1. 기존 주소지나 기본주소로 골랐을 때
           	if($(".existaddr").is(":checked")){
           	 $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                 type: "post",
                 url: "orderpayment",
                 async: false,
              // 주문내역
                 data: { user_id: "<%=user.getUser_id() %>",
                	 	 address_no : $("#addressno").val(), //String으로 넘어간거 주의
                	 	order_memo : $("#ordermemo").val()+"",
                	 	order_total : minusComma($("#totalprice").val()),
                	 	order_cost : $("#shippingpay").val()+"",
                	 	point_discount : $("#insertmile").val()+"",
                	 	coupon_discount : minusComma($("#coudiscount").val())+"",
                	 	order_payment : minusComma($("#finalpay").val()),
                	 	order_method : $("#paymethodno").val(),
                	 	add_mileage : parseInt(0.05 * minusComma($("#totalprice").val())),
                		receiver_name : $("#receiver_name").val(),
                 	 	phone_no : $("#phone_no1").val() + $("#phone_no2").val() + $("#phone_no3").val()
                	 	
                 },
                 dataType: "json", // 전달받을 객체는 JSON 이다.
                 success: function (data) {
                	 //alert($("#phone_no1").val() + $("#phone_no2").val() + $("#phone_no3").val());
                	 //alert("주문내역 기록 성공\n" + data);
                	 //TODO 마이페이지로 넘어가기
                 },
                 error : function(request,status,error) {
                     alert("code:"+request.status+"\n"+"message:"+request.responseText+
                     "\n"+"error:"+error+"주문 정보 기록 실패");
                     }
             });
           	
           	
           	} else if($("#newaddr").is(":checked")){
           		// 새 주소지 만들기
             	   $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                        type: "get",
                        url: "orderinsertaddress",
                        async: false,
                        data: { user_id: "<%=user.getUser_id() %>",
                     		   postcode : $("#postcode").val(),
                     		   basicaddr : $("#basicaddr").val(),
                     		   detailaddr : $("#detailaddr").val()
                        },
                        success: function (data) {
								// address_no 받아오기
								$("#addressno").val(minusComma(data));
								alert($("#addressno").val());

                            },
                            error : function(request,status,error) {
                                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                                "\n"+"error:"+error+"새주소지 기록 실패");
                                }
                        });
           		
             	  $.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                      type: "post",
                      url: "orderpayment",
                      async: false,
                   // 주문내역 만들기 10.12 내용추가
                      data: { user_id: "<%=user.getUser_id() %>",
                     	 	address_no : $("#addressno").val(), //String으로 넘어간거 주의
                     	 	order_memo : $("#ordermemo").val()+"",
                     	 	order_total : minusComma($("#totalprice").val()),
                     	 	order_cost : $("#shippingpay").val()+"",
                     	 	point_discount : $("#insertmile").val()+"",
                     	 	coupon_discount : minusComma($("#coudiscount").val())+"",
                     	 	order_payment : minusComma($("#finalpay").val()),
                     	 	order_method : $("#paymethodno").val(),
                     	 	add_mileage : 0.05 * minusComma($("#totalprice").val()),
                     	 	receiver_name : $("#receiver_name").val(),
                     	 	phone_no : $("#phone_no1").val() + $("#phone_no2").val() + $("#phone_no3").val()
                     	 	
                      },
                      dataType: "json", // 전달받을 객체는 JSON 이다.
                      success: function (data) {
                    	  //alert($("#phone_no1").val() + $("#phone_no2").val() + $("#phone_no3").val());
                    	  //alert("주문내역 기록 성공\n" + data);
                     	 //TODO 마이페이지로 넘어가기
                      },
                      error : function(request,status,error) {
                          alert("code:"+request.status+"\n"+"message:"+request.responseText+
                          "\n"+"error:"+error+"주문 정보 기록 실패");
                          }
                  });
           	}; // 주소지 생성 여부 if else 문 
           	
           	//TODO 1. 사용된 쿠폰 used 로 바꾸기   10.12 내용추가
           	//TODO 2. 사용된 적립금 만큼 회원 적립금 차감하기  10.12 내용추가
           	if($("#couponno").val() != ""){// 쿠폰이 선택 됐다면 조건문
           		$.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                    type: "post",
                    url: "orderusedcoupon",
                    async: false,
                    data: { user_id: "<%=user.getUser_id() %>",
                  	  coupon_no : minusComma($("#couponno").val())
                    },
                    dataType: "json", // 전달받을 객체는 JSON 이다.
                    success: function (data) {
                   	 //alert("사용된 쿠폰 기록 성공\n" + data);
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+
                        "\n"+"error:"+error+"사용된 쿠폰 수정 실패");
                        }
                });
           		
           	};
           	
           	
           	//적립금 사용액 빼기  10.12 내용추가
           	//console.log(minusComma($("#insertmile").val()));
           	if(minusComma($("#insertmile").val())){
           		$.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                    type: "post",
                    url: "orderusedmile",
                    async: false,
                    data: { user_id: "<%=user.getUser_id() %>",
                  	  used_mile : minusComma($("#insertmile").val())
                    },
                    dataType: "json", // 전달받을 객체는 JSON 이다.
                    success: function (data) {
                   	 //alert("사용된 적립금 기록 성공\n" + data);
                    },
                    error : function(request,status,error) {
                        alert("code:"+request.status+"\n"+"message:"+request.responseText+
                        "\n"+"error:"+error+"적립금 사용액 수정 실패");
                        }
                });
           		
           	}
           	
           	// 주문상세내역 생성 
           	
           	var dataArrayToSendNo = [];
           	var dataArrayToSendQuan = [];
           	
           	$("#cartinfo tr").each(function(){
           		
           		// 카트 정보 for 문 이용해서 배열에 넣기
           		dataArrayToSendNo.push($(this).find("td").eq(0).text());
           		dataArrayToSendQuan.push($(this).find("td").eq(1).text());
           		
           		
           		
           	}); 
           	
           	console.log(dataArrayToSendNo);
           	console.log(dataArrayToSendQuan);
           	var newDataArrayToSendNo = [];
           	var newDataArrayToSendQuan = [];
           	newDataArrayToSendNo = dataArrayToSendNo.filter(function(item){
           		return item !== "";
           		
           	});
           	newDataArrayToSendQuan = dataArrayToSendQuan.filter(function(item){
           		return item !== "";
           	});
           	
           	console.log(newDataArrayToSendNo);
           	console.log(newDataArrayToSendQuan);
           	$("#prono").val(newDataArrayToSendNo);
           	$("#proquan").val(newDataArrayToSendQuan);
           	
           	console.log(typeof newDataArrayToSendNo);
           	console.log(typeof newDataArrayToSendQuan);
           	
           	// ajax 넣기
           	$.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                type: "post",
                url: "orderdetailinsert",
                async: false,
                data: { user_id: "<%=user.getUser_id() %>",
                	productNo : 	$("#prono").val(),
                	ProductQuan :  $("#proquan").val()
                },
                dataType: "json", // 전달받을 객체는 JSON 이다.
                success: function (data) {
               	// alert("주문상세내역 기록 성공" + data);
               	//window.location.href = "/wooRiGym/mypage";
                },
                error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"주문상세내역 기록 실패");
                }
            });
           	
           	var cartnolist = "";
           	for(var i=2 ;  i < $("#cartinfo > tbody > tr").length + 1 ; i++){
           		cartnolist += $("#cartinfo > tbody >tr:nth-of-type("+i+") >td:nth-of-type(6)").text() +',';
           	};
           	
           	$("#cartnolist").val(cartnolist);
           	//장바구니에서 구매한 상품들 삭제하기 10.20  작업시작 // 10.21 기능 구현
           	// ajax 넣기
           	$.ajax({ // JQuery 를 통한 ajax 호출 방식 사용
                type: "post",
                url: "orderdeletecart",
                async: false,
                data: { cart_nolist: $("#cartnolist").val()
                },
                dataType: "json", // 전달받을 객체는 JSON 이다.
                success: function (data) {
               	 //alert("구매한 상품 장바구에서 삭제 성공" + data);
               	 alert("결제되었습니다.");
               	window.location.href = "/wooRiGym/mypage";
                },
                error : function(request,status,error) {
                alert("code:"+request.status+"\n"+"message:"+request.responseText+
                "\n"+"error:"+error+"구매한 상품 장바구에서 삭제 실패");
                }
            });      
           	
         
           	
    });
    </script>
</body>
</html>