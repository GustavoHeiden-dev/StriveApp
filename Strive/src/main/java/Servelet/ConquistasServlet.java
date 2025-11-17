package Servelet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import Dao.ConquistasDAO;
import Dao.ProgressoDAO;
import Modelos.Conquista;
import Modelos.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ConquistasServlet")
public class ConquistasServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Verifica se há uma nova conquista na sessão para exibir o toast.
        if (session.getAttribute("novaConquista") != null) {
            request.setAttribute("mostrarToast", "true");
            session.removeAttribute("novaConquista");
        }

        try {
            int id_usuario = usuario.getId();
            
            ProgressoDAO progressoDAO = new ProgressoDAO();
            ConquistasDAO conquistaDAO = new ConquistasDAO();

            // 1. Coleta os dados de progresso do usuário (BUSCADO APENAS UMA VEZ para eficiência)
            int totalTreinosConcluidos = progressoDAO.getTotalTreinosConcluidos(id_usuario);
            int totalDiasUnicos = progressoDAO.getTotalDiasUnicosDeTreino(id_usuario);
            // AGORA BUSCANDO OS DIAS SEGUIDOS REAIS
            int maxDiasSeguidos = progressoDAO.getMaxDiasSeguidosDeTreino(id_usuario); 

            List<Conquista> todasAsMetas = conquistaDAO.getTodasConquistas();
            
            // Coleta os IDs das conquistas que o usuário já possui
            Set<Integer> idConquistasGanhas = conquistaDAO.getConquistasPorUsuario(id_usuario)
                    .stream()
                    .map(Conquista::getId_conquista)
                    .collect(Collectors.toSet());

            List<Conquista> conquistasAtivas = new ArrayList<>();
            List<Conquista> conquistasConcluidas = new ArrayList<>();

            // 2. Itera sobre todas as conquistas para calcular o progresso
            for (Conquista meta : todasAsMetas) {
                
                if (idConquistasGanhas.contains(meta.getId_conquista())) {
                    // Conquista já ganha
                    meta.setProgresso(100.0);
                    // NOVO: Define o progresso atual como o valor da meta para ex. 5/5
                    meta.setProgressoAtual(meta.getMeta()); 
                    meta.setConcluido(true);
                    conquistasConcluidas.add(meta);
                } else {
                    // Conquista em andamento (calcula progresso)
                    double progresso = 0.0;
                    int progressoAtual = 0; // NOVO: Variável para armazenar o valor atual de progresso (ex: 2)
                    String tipoMeta = meta.getTipo_meta();
                    int metaValor = meta.getMeta();
                    
                    // Lógica para TOTAL_TREINOS
                    if ("TOTAL_TREINOS".equals(tipoMeta) && metaValor > 0) {
                        progressoAtual = Math.min(totalTreinosConcluidos, metaValor);
                        
                    // Lógica para DIAS_UNICOS (dias distintos de treino)
                    } else if ("DIAS_UNICOS".equals(tipoMeta) && metaValor > 0) {
                        progressoAtual = Math.min(totalDiasUnicos, metaValor);
                        
                    // Lógica para DIAS_SEGUIDOS (O SEU NOVO OBJETIVO)
                    } else if ("DIAS_SEGUIDOS".equals(tipoMeta) && metaValor > 0) {
                        progressoAtual = Math.min(maxDiasSeguidos, metaValor);
                    }
                    
                    // Recalcula o progresso em % com base no progressoAtual para a barra de progresso
                    progresso = ((double) progressoAtual / metaValor) * 100;
                    
                    // Lógica para CHECAR E DAR CONQUISTA (necessária para DIAS_SEGUIDOS)
                    if (progresso >= 100.0 && !idConquistasGanhas.contains(meta.getId_conquista())) {
                        conquistaDAO.darConquistaParaUsuario(id_usuario, meta.getId_conquista());
                        session.setAttribute("novaConquista", true);
                        
                        // Atualiza a lista de IDs ganhas para que ela não seja colocada em "ativas"
                        idConquistasGanhas.add(meta.getId_conquista());
                        
                        // Marca como concluída e adiciona à lista de concluídas
                        meta.setProgresso(100.0);
                        meta.setProgressoAtual(metaValor); // Concluído é o valor da meta
                        meta.setConcluido(true);
                        conquistasConcluidas.add(meta);
                        continue; // Passa para a próxima meta
                    }
                    
                    // Se não concluiu
                    meta.setProgressoAtual(progressoAtual); // NOVO: Define o valor atual no objeto
                    meta.setProgresso(progresso);
                    meta.setConcluido(false);
                    conquistasAtivas.add(meta);
                }
            }
            
            request.setAttribute("conquistasAtivas", conquistasAtivas);
            request.setAttribute("conquistasConcluidas", conquistasConcluidas);

            request.getRequestDispatcher("conquistas.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
    
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}