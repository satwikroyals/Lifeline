using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SendGrid;
using SendGrid.SmtpApi;
using System.Net.Mail;
using System.Net;
using System.Configuration;

namespace Lifeline
{
    public class sendmail
    {
        public string SendEmail(string to, string subject, string bodyText, string bodyHtml, string from, string fromName)
        {

            string uname = SendGridEmailCredentials()["uname"].ToString();
            string pwd = SendGridEmailCredentials()["pwd"].ToString();
            string key = SendGridEmailCredentials()["key"].ToString();

            var message = new SendGridMessage();

            message.Subject = subject;
            message.From = new MailAddress(from, fromName);
            if (bodyHtml != null)
            {
                message.Html = bodyHtml;
            }
            if (bodyText != null)
            {
                message.Text = bodyText;
            }
            if (string.IsNullOrEmpty(to))
            {
                return "";
            }

            message.AddTo(to);
            var transportInstance = new Web(key);
            message.EnableBypassListManagement();
            transportInstance.DeliverAsync(message);
            return "";

        }
        public Dictionary<string, string> SendGridEmailCredentials()
        {
            Dictionary<string, string> cred = new Dictionary<string, string>();

            cred.Add("uname", ConfigurationManager.AppSettings["SendGridEmailUname"].ToString());
            cred.Add("pwd", ConfigurationManager.AppSettings["SendGridEmailPassword"].ToString());
            cred.Add("key", ConfigurationManager.AppSettings["SendGridKey"].ToString());
            return cred;
        }
    }
}