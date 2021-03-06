package woorigym.user.model.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import woorigym.product.model.vo.ProductTable;
import woorigym.shoppingbag.model.vo.CartTable;
import woorigym.user.model.dao.OrderDao;
import woorigym.user.model.vo.AddressTable;
import woorigym.user.model.vo.CouponTable;
import woorigym.user.model.vo.UserTable;

import static woorigym.common.jdbcTemplate.*;

public class OrderService {

	public OrderService() {
	}

	public ArrayList<UserTable> getUserInfo(String userid) {
		ArrayList<UserTable> volist;

		Connection conn = getConnection();

		volist = new OrderDao().getUserInfo(userid, conn);

		close(conn);
		return volist;
	}

	public ArrayList<AddressTable> getAddress(String userid) {
		ArrayList<AddressTable> volist;

		Connection conn = getConnection();

		volist = new OrderDao().getAddress(userid, conn);

		close(conn);
		return volist;
	}

	public ArrayList<CartTable> getCart(String userid) {
		ArrayList<CartTable> volist;

		Connection conn = getConnection();

		volist = new OrderDao().getCart(userid, conn);

		close(conn);
		return volist;
	}

	public ArrayList<ProductTable> getProductinfo(String userid) {
		ArrayList<ProductTable> volist;

		Connection conn = getConnection();

		volist = new OrderDao().getProductinfo(userid, conn);

		return volist;
	}

	public ArrayList<CouponTable> getCoupon(String userid) {
		ArrayList<CouponTable> volist;

		Connection conn = getConnection();

		volist = new OrderDao().getCoupon(userid, conn);

		close(conn);
		return volist;
	}
	
	public int addressInsert(String user_id,String postcode,String basic_address,String detail_address){
		int result = -1;
		
		Connection conn = getConnection();
		result = new OrderDao().addressInsert(user_id, postcode, basic_address, detail_address, conn);
		close(conn);
		
		return result;
	}
	public int deleteInsert(String user_id,String postcode,String basic_address,String detail_address,int address_no){
		int result = -1;
		
		Connection conn = getConnection();
		result = new OrderDao().deleteInsert(user_id, postcode, basic_address, detail_address,address_no, conn);
		close(conn);
		
		return result;
	}
	
	public int insertOrderinfo(String user_id,int address_no,String order_memo,int order_total,int order_cost,int point_discount,int coupon_discount,int order_payment,int order_method,String pay_state,int add_mileage, String receiver_name, String phone_no ) {
		int result=-1;
		
		Connection conn = getConnection();
		result = new OrderDao().insertOrderinfo(user_id, address_no, order_memo, order_total, order_cost, point_discount, coupon_discount, order_payment, order_method,pay_state, add_mileage, receiver_name, phone_no, conn);
		close(conn);
		return result; 
		
	}
	public int UpdateCoupon(String coupon_no, String user_id) {
		int result=-1;
		
		Connection conn = getConnection();
		result = new OrderDao().UpdateCoupon(coupon_no, user_id, conn);
		close(conn);
		return result; 
		
	}
	
	public int usedMileage(String user_id,int used_mile) {
		int result=-1;
		
		Connection conn = getConnection();
		result = new OrderDao().usedMileage(user_id, used_mile, conn);
		close(conn);
		return result; 
		
	}
	
	public int orderDeatilInsert(String user_id,String[] proNoArr,String[] proQuanArr) {
		int result=-1;
	
		Connection conn = getConnection();
		result = new OrderDao().orderDeatilInsert(user_id, proNoArr, proQuanArr, conn);
		close(conn);
		return result; 
	}
	public int deleteCartList(int[] list) {
		int result=-1;
		
		Connection conn = getConnection();
		result = new OrderDao().deleteCartList(list, conn);
		close(conn);
		return result; 
	}
	

} // class
