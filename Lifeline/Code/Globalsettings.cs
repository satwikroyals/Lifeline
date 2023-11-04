using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Lifeline.Entity;
using System.Web.Security;
using System.Net;
using System.Web.Script.Serialization;
using System.Text;
using System.IO;
using Lifeline.BAL;
using System.Configuration;
using System.Security.Cryptography;
using System.Collections.Specialized;
using System.Net.Mail;
namespace Lifeline.Code
{
    public class Globalsettings
    {
        //private static string _websiteurl = Settings.WebsiteUrl;
        public static string _websiteurl
        {
            get
            {
                string url = HttpContext.Current.Request.Url.Authority + "/";
                //if (url.IndexOf("https") == -1)
                //{                  
                //        url = "https://" + url;                    
                //}
                string urlhost = HttpContext.Current.Request.Url.Host.ToLower();
                if (urlhost == "localhost")
                {
                    return "http://" + url;
                }
                else
                {
                    return "http://" + url;
                }
            }
        }

        public static string AppStorePage
        {
            get
            {

                return _websiteurl + "AppStore/";
            }
        }

        public static string GetErrorMessagePrefix()
        {
            return "Some Problem while ";
        }
      
        public static string GetWebSiteUrlApi()
        {
            return ConfigurationManager.AppSettings["AppurlApi"].ToString();
        }
        public static string MobileAppUrl
        {
            get { return ConfigurationManager.AppSettings["MobileAppUrl"]; }

        }
        public static string GetGoogleMapsApi
        {
            get { return ConfigurationManager.AppSettings["GeoAddressApi"]; }
        }


        public static string appcsspath(string file)
        {
            return _websiteurl + "content/css/" + file;
        }
    
        public static string appjspath(string file)
        {
            return _websiteurl + "content/js/" + file;
        }

        public static string appimagespath(string file)
        {
            return _websiteurl + "content/images/" + file;
        }

        public static string SetFont(string text)
        {
            return string.IsNullOrEmpty(text) == true ? "" : System.Globalization.CultureInfo.CurrentUICulture.TextInfo.ToTitleCase(text);
        }

        /// <summary>
        /// To set dateformat.
        /// </summary>
        /// <param name="dt"></param>
        /// <returns>Dateformat(mmm d, yyyy)</returns>
        public static string SetDateFormat(DateTime? dt)
        {
            if (dt != null)
            {
                return String.Format("{0:d MMM, yyyy}", Convert.ToDateTime(dt));
            }
            else { return ""; }
        }

        /// <summary>
        /// To set datetimeformat.
        /// </summary>
        /// <param name="dt"></param>
        /// <returns>Datetimeformat(mmm d, yyyy HH:mm)</returns>
        public static string SetDateTimeFormat(DateTime? dt)
        {
            if (dt != null)
            {
                return String.Format("{0:d MMM, yyyy h:mm:ss tt}", Convert.ToDateTime(dt));
            }
            else { return ""; }
        }

        public static string AdminCookiename
        {
            get { return "adm"; }
        }
        public static string CookieAdminId
        {
            get { return "admid"; }
        }

        public static string CookieAdminun
        {
            get { return "admun"; }
        }

        public static string ReadCookie(string cookieName, string keyName)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[cookieName];
            if (cookie != null)
            {
                string val = (!String.IsNullOrEmpty(keyName)) ? cookie[keyName] : cookie.Value;
                if (!String.IsNullOrEmpty(val)) return Uri.UnescapeDataString(val);
            }
            return null;
        }

        public bool IsAdminLoggedin()
        {
            if (HttpContext.Current.Request.IsAuthenticated)
            {
                if (HttpContext.Current.Request.Cookies[Globalsettings.AdminCookiename] != null)
                {
                    return true;
                }
                else
                {
                    DoAdminLogOut();
                    return false;
                }
            }
            else
            {
                if (HttpContext.Current.Request.Cookies[Globalsettings.AdminCookiename] != null)
                {
                    DoAdminLogOut();
                }
                return false;
            }
        }

        /// <summary>
        /// Logout customer.
        /// </summary>
        internal void DoAdminLogOut()
        {
            try
            {
                if (HttpContext.Current.Request.Cookies[Globalsettings.AdminCookiename] != null)
                {
                    HttpCookie oCookie = (HttpCookie)HttpContext.Current.Request.Cookies[Globalsettings.AdminCookiename];
                    oCookie.Expires = DateTime.Now.AddDays(-1);
                    HttpContext.Current.Response.Cookies.Add(oCookie);

                }
                FormsAuthentication.SignOut();
            }
            catch { }
        }

        public static string GetProjectName()
        {
            return "Solutions Empowerment";
        }

        public static string GetCompanyName()
        {
            return "Solutions Empowerment";
        }

        public static string GetCopyRight()
        {
            return "Copyright ©2020 " + Globalsettings.GetCompanyName() + ". All Rights Reserved";
        }

        /// <summary>
        /// Generate a random string with a given size with datetime milleseconds..
        /// </summary>
        /// <param name="append"></param>
        /// <returns></returns>
        public static string RandomString(string append)
        {
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            char ch;

            for (int i = 0; i < 2; i++)
            {
                ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
                builder.Append(ch);
            }
            append += builder.ToString().ToLower();
            string unixTimestamp = Convert.ToString((DateTime.Now.Subtract(new DateTime(1970, 1, 1))).TotalSeconds).Replace(".", "");
            return append + unixTimestamp;
        }
        /// <summary>
        /// generate 4 digit random number
        /// </summary>
        /// <returns></returns>
        public static string RandomNumber()
        {
            Random r = new Random();
            string s = Convert.ToString(r.Next(1000, 10000));
            return s;
        }
        public static string GetCountryTeleCode()
        {
            return ConfigurationManager.AppSettings["TeleCode"].ToString();
        }
        public static string GetSMSServer()
        {
            return ConfigurationManager.AppSettings["SMSServer"].ToString();
        }

        public static string GetSMSApiServer()
        {
            return ConfigurationManager.AppSettings["SMSApiServer"].ToString();
        }

        public static string GetSMSUsername()
        {
            return ConfigurationManager.AppSettings["SMSUsername"].ToString();
        }

        public static string GetSMSPassword()
        {
            return ConfigurationManager.AppSettings["SMSPassword"].ToString();
        }

        public static string GetSMSHeader()
        {
            return ConfigurationManager.AppSettings["SMSHeader"].ToString();
        }

        public static Dictionary<string, string> SendGridEmailCredentials()
        {
            Dictionary<string, string> cred = new Dictionary<string, string>();

            cred.Add("uname", ConfigurationManager.AppSettings["SendGridEmailUname"].ToString());
            cred.Add("pwd", ConfigurationManager.AppSettings["SendGridEmailPassword"].ToString());
            cred.Add("key", ConfigurationManager.AppSettings["SendGridApiKey"].ToString());

            return cred;
        }
        
        public static string sendbulksms(string fpath, string fname, string smsheader)
        {
            string result = "";
            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");
            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");
            NameValueCollection nvc = new NameValueCollection();
            nvc.Add("ACTION", "send");
            nvc.Add("USERNAME", GetSMSUsername());
            nvc.Add("PASSWORD", GetSMSPassword());
            nvc.Add("ORIGINATOR", smsheader);
            nvc.Add("FILE_LIST", fname);
            nvc.Add("FILE_HASH", GetFileMD5(fpath));
            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(GetSMSApiServer());
            wr.ContentType = "multipart/form-data; boundary=" + boundary;
            wr.Method = "POST";
            wr.KeepAlive = true;
            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;
            Stream rs = wr.GetRequestStream();
            string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
            foreach (string key in nvc.Keys)
            {
                rs.Write(boundarybytes, 0, boundarybytes.Length);
                string formitem = string.Format(formdataTemplate, key, nvc[key]);
                byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                rs.Write(formitembytes, 0, formitembytes.Length);
            }
            string file = fpath;
            rs.Write(boundarybytes, 0, boundarybytes.Length);
            string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n";
            string header = string.Format(headerTemplate, "FILE_LIST", fname, "application/zip");
            byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
            rs.Write(headerbytes, 0, headerbytes.Length);
            FileStream fileStream = new FileStream(file, FileMode.Open, FileAccess.Read);
            byte[] buffer = new byte[100000000];
            int bytesRead = 0;
            while ((bytesRead = fileStream.Read(buffer, 0, buffer.Length)) != 0)
            {
                rs.Write(buffer, 0, bytesRead);
            }
            fileStream.Close();
            byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
            rs.Write(trailer, 0, trailer.Length);
            rs.Close();
            WebResponse wresp = null;
            try
            {
                wresp = wr.GetResponse();
                Stream stream2 = wresp.GetResponseStream();
                StreamReader reader2 = new StreamReader(stream2);
                result = reader2.ReadToEnd();
            }
            catch
            {


                if (wresp != null)
                {
                    wresp.Close();
                    wresp = null;
                }
            }
            finally
            {
                wr = null;
            }
            return result;
        }
        protected static string GetFileMD5(string fileName)
        {
            FileStream file = new FileStream(fileName, FileMode.Open);
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(file);
            file.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }

        public static string Iospushfile(string folder)
        {
            return Convert.ToString(ConfigurationManager.AppSettings["IosPushRoot"]) + (folder == "" ? "lifeline" : folder) + "/simplepush.php";
        }
        public static string UserIospushfile(string folder)
        {
            return Convert.ToString(ConfigurationManager.AppSettings["IosPushRoot"]) + (folder == "" ? "lifeline" : folder) + "/usersimplepush.php";
        }

        public static void AndroidPushNotifications(string[] deviceid,string apptype, string message, string title, string navurl, string appkey = "")
        {
            if (apptype == "1")
            {
                appkey = appkey == "" ? ConfigurationManager.AppSettings["customerAndroidPushKey"] : appkey;
            }
            else
            {
                appkey = appkey == "" ? ConfigurationManager.AppSettings["coordinatorAndroidPushKey"] : appkey;
            }

            WebRequest tRequest;
            tRequest = WebRequest.Create("https://fcm.googleapis.com/fcm/send");
            tRequest.Method = "post";
            tRequest.ContentType = "application/json";
            //tRequest.ContentType = "application/x-www-form-urlencoded";
            tRequest.Headers.Add(string.Format("Authorization: key={0}", appkey));
            String collaspeKey = Guid.NewGuid().ToString("n");

            var result = string.Join("\",\"", deviceid);
            try
            {
                var postmsg = new
                {
                    registration_ids = deviceid,
                    priority = "high",
                    content_available = true,
                    notification = new
                    {
                        body = message+"~"+(string.IsNullOrEmpty(navurl) ? "" : navurl),
                        title = title.Replace(":", ""),
                        navurl = string.IsNullOrEmpty(navurl) ? "" : navurl
                    },
                    //notification = new
                    //{
                    //},
                    //data = new
                    //{                      
                    //    body = message,
                    //    title = title.Replace(":", ""),
                    //    navurl = string.IsNullOrEmpty(navurl) ? "" : navurl		
                    //},
                };

                var serializer = new JavaScriptSerializer();
                var json = serializer.Serialize(postmsg);
                //string testdata = string.Format("registration_id={0}&data.contentTitle={1}&data.message={2}&data.collapse_Key={3}", deviceid[0], title, message, collaspeKey);
                //string jsonNotificationFormat = Newtonsoft.Json.JsonConvert.SerializeObject(postData);
                Byte[] byteArray = Encoding.UTF8.GetBytes(json);

                tRequest.ContentLength = byteArray.Length;
                Stream dataStream = tRequest.GetRequestStream();
                dataStream.Write(byteArray, 0, byteArray.Length);
                dataStream.Close();
                WebResponse tResponse = tRequest.GetResponse();
                Stream dataStreamResponce = tResponse.GetResponseStream();

                //dataStream = tResponse.GetResponseStream();
                StreamReader tReader = new StreamReader(dataStreamResponce);
                String sResponseFromFirebaseServer = tReader.ReadToEnd();
                tReader.Close();
                dataStream.Close();
                tResponse.Close();
            }
            catch
            {
            }
        }

        public static void IPhonePushNotifications(string[] deviceids,string apptype, string message, string title, string navurl, string pushfolder = "")
        {
            try
            {
                foreach (string deviceid in deviceids)
                {
                    WebRequest request = null;
                    if (apptype == "2")
                    {
                        if (navurl == "")
                        {
                            request = WebRequest.Create(Iospushfile(pushfolder) + "?did=" + deviceid + "&mess=" + message);
                        }
                        else
                        {
                            request = WebRequest.Create(Iospushfile(pushfolder) + "?did=" + deviceid + "&mess=" + message + "&url=" + navurl);
                        }
                    }
                    else
                    {
                        if (navurl == "")
                        {
                            request = WebRequest.Create(UserIospushfile(pushfolder) + "?did=" + deviceid + "&mess=" + message);
                        }
                        else
                        {
                            request = WebRequest.Create(UserIospushfile(pushfolder) + "?did=" + deviceid + "&mess=" + message + "&url=" + navurl);
                        }
                    }
                    WebResponse response = request.GetResponse();
                    Stream dataStream = response.GetResponseStream();
                    StreamReader reader = new StreamReader(dataStream);
                    string responseFromServer = reader.ReadToEnd();
                    reader.Close();
                    dataStream.Close();
                    response.Close();
                }
            }
            catch { }
        }

        public static void SendSMSMessage(string SMSTo, string ReplyMessage, string Header = "LifeLine")
        {
            if (!string.IsNullOrEmpty(SMSTo))
            {
                WebRequest WebRequest;
                // object for WebRequest
                WebResponse WebResonse;
                string Server = GetSMSServer();
                //string Port = "";
                string UserName = GetSMSUsername();
                string Password = GetSMSPassword();

                string sourceto = Header == "" ? GetSMSHeader() : Header;
                string Source = sourceto;
                //int telecodelen = GetCountryTeleCode().Length;
                string Destination = SMSTo[0] == '0' ? SMSTo.Substring(1) : SMSTo;
                //Destination = Destination.Substring(0, telecodelen) == GetCountryTeleCode() ? Destination : GetCountryTeleCode() + Destination;
                string WebResponseString = "";
                string URL = (
                             (Server + ("?USERNAME="
                            + (UserName + ("&PASSWORD="
                            + (Password + ("&ACTION="
                            + ("send" + ("&RECIPIENT="
                            + (Destination + ("&ORIGINATOR="
                            + (Source + ("&MESSAGE_TEXT="
                            + (ReplyMessage + ""))))))))))))));

                WebRequest = HttpWebRequest.Create(URL);
                // Hit URL Link
                WebRequest.Timeout = 25000;
                try
                {
                    WebResonse = WebRequest.GetResponse();
                    // Get Response
                    StreamReader reader = new StreamReader(WebResonse.GetResponseStream());
                    WebResponseString = reader.ReadToEnd();
                    WebResonse.Close();
                }
                catch
                {
                    WebResponseString = "Request Timeout";
                }
            }
        }
        public static int SaveFile(string filedata, string filename, string servermappath)
        {
            int res = 1;
            byte[] imagedata = Convert.FromBase64String(filedata);
            string generatefilename = filename; //surveyimg.SurveyId.ToString() + "_" + surveyimg.ImageTypeId.ToString();
            //  string fileextence = ".jpg";
            if (imagedata != null && imagedata.Length > 0)
            {
                try
                {

                    //  ImageName = joborderid + joballotmentid + "box.jpeg";
                    string strFilePath = System.Web.Hosting.HostingEnvironment.MapPath(servermappath) + generatefilename;
                    // string strFilePath = "D:\\APSSAAT\\Content\\images\\Beneficiary\\" + surveyimg.SurveyId.ToString() + "//" + generatefilename + fileextence;
                    FileStream targetStream = null;
                    MemoryStream ms = new MemoryStream(imagedata);
                    Stream sourceStream = ms;
                    string uploadFolder = System.Web.Hosting.HostingEnvironment.MapPath(servermappath);
                    //   string uploadFolder = "D:\\APSSAAT\\Content\\images\\Beneficiary\\" + surveyimg.SurveyId.ToString();
                    // string uploadFolder = "C:\\Inetpub\\wwwroot\\Content\\Agents\\" + Agent.AgentId + "\\";
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }
                    //  string filename = generatefilename + fileextence;

                    string filePath = Path.Combine(uploadFolder) + filename;
                    // write file using stream.
                    using (targetStream = new FileStream(filePath, FileMode.Create, FileAccess.Write, FileShare.None))
                    {

                        const int bufferLen = 4096;
                        byte[] buffer = new byte[bufferLen];
                        int count = 0;
                        int totalBytes = 0;
                        while ((count = sourceStream.Read(buffer, 0, bufferLen)) > 0)
                        {

                            totalBytes += count;
                            targetStream.Write(buffer, 0, count);

                        }

                        targetStream.Close();

                        sourceStream.Close();

                    }


                }

                catch (Exception ex)
                {
                    res = -1;
                    return res;
                    // ExceptionUtility.LogException(ex, "Agent Business logo Uploaded-Agentserevices", "Agent");

                }

            }
            return res;
        }

        /// <summary>
        /// Gets Google maps api key.
        /// </summary>      
        /// <returns>Google maps api key</returns>
        public static string GetGoogleMapsApiKey()
        {
            //  return "AIzaSyBf1cgIlwE7ywZS1afASVyxO6n0t5erGKc";
            return ConfigurationManager.AppSettings["GooglemapApiKey"].ToString();
        }

        public static string GetProductsQrCodeUrl(Int32 pid)
        {
            return _websiteurl + "QR/Products/" + pid.ToString();
        }





        //public static void IPhonePushNotifications(string[] deviceids, string apptype, string message, string title, string navurl, string msgtype)
        //{
        //    try
        //    {

        //        foreach (string deviceid in deviceids)
        //        {
        //            WebRequest request = null;
        //            //if (navurl == "")
        //            //{
        //            //    request = WebRequest.Create("https://gmilink.com/payrpush/customer/simplepush.php?did=" + deviceid + "&mess=" + message);
        //            //}
        //            //else
        //            //{
        //            //    request = WebRequest.Create("https://gmilink.com/payrpush/customer/simplepush.php?did=" + deviceid + "&mess=" + message + "&url=" + navurl);
        //            //}
        //            if (apptype == "1")
        //            {
        //                request = WebRequest.Create(ConfigurationManager.AppSettings["customeriosappkey"] + "?did=" + deviceid + "&mess=" + message + "&messtype=" + msgtype);
        //            }
        //            else
        //            {
        //                request = WebRequest.Create(ConfigurationManager.AppSettings["merchantiosappkey"] + "?did=" + deviceid + "&mess=" + message + "&messtype=" + msgtype);
        //            }
        //            WebResponse response = request.GetResponse();
        //            Stream dataStream = response.GetResponseStream();
        //            StreamReader reader = new StreamReader(dataStream);
        //            string responseFromServer = reader.ReadToEnd();
        //            reader.Close();
        //            dataStream.Close();
        //            response.Close();
        //        }
        //    }
        //    catch { }
        //}

        //public static void AndroidPushNotifications(string[] deviceid, string apptype, string message, string title, string navurl, string msgtype)
        //{
        //    WebRequest tRequest;
        //    string appkey = "";
        //    if (apptype == "1")
        //    {
        //        appkey = Convert.ToString(ConfigurationManager.AppSettings["customerandroidappkey"]);
        //    }
        //    else
        //    {
        //        appkey = Convert.ToString(ConfigurationManager.AppSettings["merchantandroidappkey"]);
        //    }

        //    tRequest = WebRequest.Create("https://fcm.googleapis.com/fcm/send");
        //    tRequest.Method = "post";
        //    tRequest.ContentType = "application/json";
        //    //tRequest.ContentType = "application/x-www-form-urlencoded";
        //    tRequest.Headers.Add(string.Format("Authorization: key={0}", appkey));
        //    String collaspeKey = Guid.NewGuid().ToString("n");

        //    var result = string.Join("\",\"", deviceid);
        //    try
        //    {
        //        var postmsg = new
        //        {
        //            registration_ids = deviceid,
        //            priority = "high",
        //            content_available = true,
        //            data = new
        //            {
        //                body = message,
        //                title = title.Replace(":", ""),
        //                type = msgtype
        //            },
        //        };

        //        var serializer = new JavaScriptSerializer();
        //        var json = serializer.Serialize(postmsg);
        //        //string testdata = string.Format("registration_id={0}&data.contentTitle={1}&data.message={2}&data.collapse_Key={3}", deviceid[0], title, message, collaspeKey);
        //        //string jsonNotificationFormat = Newtonsoft.Json.JsonConvert.SerializeObject(postData);
        //        Byte[] byteArray = Encoding.UTF8.GetBytes(json);

        //        tRequest.ContentLength = byteArray.Length;
        //        Stream dataStream = tRequest.GetRequestStream();
        //        dataStream.Write(byteArray, 0, byteArray.Length);
        //        dataStream.Close();
        //        WebResponse tResponse = tRequest.GetResponse();
        //        Stream dataStreamResponce = tResponse.GetResponseStream();

        //        //dataStream = tResponse.GetResponseStream();
        //        StreamReader tReader = new StreamReader(dataStreamResponce);
        //        String sResponseFromFirebaseServer = tReader.ReadToEnd();
        //        tReader.Close();
        //        dataStream.Close();
        //        tResponse.Close();
        //    }
        //    catch
        //    {
        //    }
        //}
    }
}