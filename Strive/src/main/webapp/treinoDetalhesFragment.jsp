<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Modelos.DetalheExercicioSerie, java.util.List" %>
<%
    // Importante: A lista precisa ser do tipo correto (DetalheExercicioSerie)
    List<DetalheExercicioSerie> detalhes = (List<DetalheExercicioSerie>) request.getAttribute("detalhesExercicios");
    
    // Variáveis de controle para agrupar as séries pelo nome do exercício
    String currentExercicio = "";
    int serieCounter = 0;
%>

<%
    if (detalhes != null && !detalhes.isEmpty()) {
        for (DetalheExercicioSerie detalhe : detalhes) {
            
            String nomeExercicio = detalhe.getNomeExercicio(); 
            int repeticoes = detalhe.getRepeticoes(); 
            float peso = detalhe.getPeso(); 
            
            // Verifica se o exercício mudou para iniciar um novo bloco
            if (!nomeExercicio.equals(currentExercicio)) {
                if (!currentExercicio.isEmpty()) {
                    out.println("</ul></div>"); // Fecha o bloco anterior, se existir
                }
                currentExercicio = nomeExercicio;
                serieCounter = 0; // Zera o contador de séries para o novo exercício
%>
    <div class="exercicio-detalhe-bloco" style="margin-bottom: 1.5rem; border-top: 1px solid var(--border-color); padding-top: 1rem;">
        <h3 style="color: var(--secondary-color); font-size: 1.2rem; margin-bottom: 0.5rem;"><%= currentExercicio %></h3>
        <ul class="list-group" style="list-style: none; padding-left: 0;">
<% 
            }
            serieCounter++;
%>
            <li class="modal-list-group-item">
                <div style="color: var(--text-muted);">Série <%= serieCounter %></div>
                <div style="text-align: right; font-size: 0.95rem;">
                    <span style="margin-right: 15px;"><i class="fas fa-sync-alt"></i> Repetições: <strong><%= repeticoes %></strong></span>
                    <span><i class="fas fa-weight-hanging"></i> Peso: <strong><%= String.format("%.1f kg", peso) %></strong></span>
                </div>
            </li>
<%
        }
        // Garante que o último bloco seja fechado
        if (!currentExercicio.isEmpty()) {
            out.println("</ul></div>");
        }
    } else {
%>
    <p style='text-align: center; color: #777;'>Nenhum detalhe de série encontrado para esta sessão.</p>
<%
    }
%>