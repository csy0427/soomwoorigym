package woorigym.shoppingbag.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import woorigym.shoppingbag.model.service.ShoppingBagService;
import woorigym.shoppingbag.model.vo.CartTable;
import woorigym.user.model.vo.UserTable;

/**
 * Servlet implementation class ShoppingBagDeleteServlet
 */
@WebServlet("/sbdelete.ajax")
public class ShoppingBagDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShoppingBagDeleteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		execute(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		execute(request, response);
	}
	
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		String userId = request.getParameter("userId");
		
		ArrayList<CartTable> allDeleteCartList = new ShoppingBagService().allDeleteCartList(userId);
		System.out.println("아이디"+allDeleteCartList);
		Gson gson = new GsonBuilder().create();
		String jsonListVo = gson.toJson(allDeleteCartList);
		out.print(jsonListVo);
		out.flush();
		out.close();
	}

}
