package common.template;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/OpenView") //jsp 확인용! url수정XX 크롬에서 새로고침 
public class OpenView extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public OpenView() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String viewPage = "/WEB-INF/qna_write.jsp";
		//확인하고 싶은 jsp 경로만 수정하고 Ctrl+F11(실행)
		request.getRequestDispatcher(viewPage).forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
