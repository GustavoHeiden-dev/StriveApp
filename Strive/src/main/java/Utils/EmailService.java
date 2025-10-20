package Utils;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    public boolean enviarEmailRedefinicao(String emailDestinatario, String token) {
        
        final String seuEmail = "striveappacademy@gmail.com";
        final String suaSenhaDeApp = "ymzs mvez drnt iyad";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(seuEmail, suaSenhaDeApp);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(seuEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailDestinatario));
            message.setSubject("💜 [Strive] Redefinição de Senha Solicitada");

            String link = "http://localhost:8080/StriveApp/redefinirSenha.jsp?token=" + token;
            
            String corpoDoEmail = 
                "<!DOCTYPE html>" +
                "<html lang='pt-BR'>" +
                "<head>" +
                "  <meta charset='UTF-8'>" +
                "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "  <link href='https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap' rel='stylesheet'>" +
                "  <style>" +
                "    body {" +
                "      font-family: 'Poppins', sans-serif;" +
                "      margin: 0;" +
                "      padding: 0;" +
                "      background-color: #f0f0f5;" +
                "    }" +
                "    .container {" +
                "      width: 90%;" +
                "      max-width: 600px;" +
                "      margin: 30px auto;" +
                "      background-color: #ffffff;" +
                "      border-radius: 12px;" +
                "      box-shadow: 0 10px 30px rgba(0,0,0,0.07);" +
                "      overflow: hidden;" +
                "    }" +
                "    .header {" +
                "      background-color: #6a0dad;" +
                "      padding: 30px 40px;" +
                "      text-align: center;" +
                "    }" +
                "    .header h1 {" +
                "      color: #ffffff;" +
                "      font-size: 2.5rem;" +
                "      font-weight: 700;" +
                "      margin: 0;" +
                "    }" +
                "    .content {" +
                "      padding: 40px;" +
                "      color: #333;" +
                "      line-height: 1.7;" +
                "    }" +
                "    .content h2 {" +
                "      color: #1a1a1a;" +
                "      font-size: 1.6rem;" +
                "      margin-top: 0;" +
                "      font-weight: 600;" +
                "    }" +
                "    .content p {" +
                "      margin-bottom: 25px;" +
                "      font-size: 1rem;" +
                "      color: #555;" +
                "    }" +
                "    .btn-container {" +
                "      text-align: center;" +
                "      margin: 30px 0;" +
                "    }" +
                "    .btn {" +
                "      background-color: #6a0dad;" +
                "      color: #ffffff;" +
                "      padding: 15px 30px;" +
                "      text-decoration: none;" +
                "      border-radius: 8px;" +
                "      font-weight: 600;" +
                "      font-size: 1rem;" +
                "      transition: all 0.3s ease;" +
                "    }" +
                "    .btn:hover {" +
                "      background-color: #550a8a;" +
                "      transform: translateY(-2px);" +
                "    }" +
                "    .footer {" +
                "      background-color: #f9f9fb;" +
                "      padding: 30px;" +
                "      text-align: center;" +
                "      color: #aaa;" +
                "      font-size: 0.85rem;" +
                "      border-top: 1px solid #e0e0e0;" +
                "    }" +
                "    .footer p { margin: 5px 0; }" +
                "  </style>" +
                "</head>" +
                "<body>" +
                "  <div class='container'>" +
                "    <div class='header'>" +
                "      <h1>STRIVE</h1>" +
                "    </div>" +
                "    <div class='content'>" +
                "      <h2>Esqueceu sua senha?</h2>" +
                "      <p>Olá,</p>" +
                "      <p>Recebemos uma solicitação para redefinir a senha da sua conta Strive. Sabemos o quanto seu progresso é importante e estamos aqui para ajudar você a voltar ao caminho certo.</p>" +
                "      <p>Para criar uma nova senha, por favor, clique no botão abaixo. Este link é seguro e válido por tempo limitado.</p>" +
                "      <div class='btn-container'>" +
                "        <a href='" + link + "' class='btn'>CRIAR NOVA SENHA</a>" +
                "      </div>" +
                "      <p style='font-size: 0.9rem; color: #777;'>" +
                "        Se você não solicitou esta mudança, nenhuma ação é necessária. Sua conta permanece segura. Apenas ignore este e-mail." +
                "      </p>" +
                "      <p>Continue firme na sua jornada,<br><strong>Equipe Strive</strong></p>" +
                "    </div>" +
                "    <div class='footer'>" +
                "      <p>&copy; 2025 StriveApp</p>" +
                "    </div>" +
                "  </div>" +
                "</body>" +
                "</html>";
            
            message.setContent(corpoDoEmail, "text/html; charset=utf-8");

            Transport.send(message);
            
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}