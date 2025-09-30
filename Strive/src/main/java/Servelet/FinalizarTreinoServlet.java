package Servelet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Dao.TreinoSessaoDAO;

@WebServlet("/FinalizarTreinoServlet")
public class FinalizarTreinoServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {

			int idSessao = Integer.parseInt(request.getParameter("idSessao"));

			TreinoSessaoDAO dao = new TreinoSessaoDAO();
			dao.finalizarSessao(idSessao);

			HttpSession session = request.getSession();
			session.setAttribute("treinoFinalizado", "true");

			response.sendRedirect("TreinoServlet");

		} catch (Exception e) {

			e.printStackTrace();

			response.sendRedirect("TreinoServlet");
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		doPost(req, resp);
	}
}