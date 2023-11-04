using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.ModelBinding;
using System.Data;


namespace Lifeline.Entity
{
    public class Settings
    {


        private static string noimage = WebsiteUrl + "content/images/no_image.jpg";

        public static string DbConnection
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["dbconn"].ConnectionString;
            }
        }

        /// <summary>
        /// WebsiteUrl
        /// </summary>
        public static string WebsiteUrl
        {
            get
            {
                string url = HttpContext.Current.Request.Url.Authority + "/";
                if (url.IndexOf("http") == -1)
                {
                    url = "http://" + url;
                }
                return url;
            }

        }

        /// Gets content path from web.config file.
        /// </summary>      
        /// <returns>Returns admin conent path</returns>
        public static string GetContentPath()
        {
            // return ConfigurationManager.AppSettings["Appurl"] ?? "";
            string url = HttpContext.Current.Request.Url.Authority + "/";
            if (url.IndexOf("http") == -1)
            {
                url = "http://" + url;
            }
            return url;

        }

        /// <summary>
        /// WebsiteUrlAdmin
        /// </summary>
        public static string WebsiteUrlAdmin
        {
            get
            {
                return WebsiteUrl + "/Admin/";
            }
        }

        /// <summary>
        /// WebsiteUrlApi
        /// </summary>
        public static string WebsiteUrlApi
        {
            get
            {
                return WebsiteUrl + "/api/";
            }

        }
        /// <summary>
        /// Database provider
        /// </summary>
        public static string ProviederName
        {
            get { return "MsSql"; }
        }


        public static string DisplayAgeGroup(string a)
        {
            return (!string.IsNullOrEmpty(a) ? a : "N/A");
        }

        public static string YesOrNo(int a)
        {
            return (a == 1 ? "Yes" : "No");
        }
        /// <summary>
        /// To set font in Title case.
        /// </summary>
        /// <param name="text"></param>
        /// <returns>Title Case Text</returns>
        public static string SetFont(string text)
        {
            return string.IsNullOrEmpty(text) == true ? "" : System.Globalization.CultureInfo.CurrentUICulture.TextInfo.ToTitleCase(text);
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
                return String.Format("{0:d MMM, yyyy h:mm tt}", Convert.ToDateTime(dt));
            }
            else { return ""; }
        }
        /// <summary>
        /// To set Time Formate as in 12 hrs.
        /// </summary>
        /// <param name="dt">datetime</param>
        /// <returns>return 12hrs formate .if you want in 24 hrs formate remove tt.</returns>
        public static string SetTimeFormat(DateTime? dt)
        {
            if (dt != null)
            {
                return String.Format("{0:h:mm:ss tt}", Convert.ToDateTime(dt));
            }
            else { return ""; }
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
                return String.Format("{0:d/MMM/yyyy}", Convert.ToDateTime(dt));
            }
            else { return ""; }
        }
        /// <summary>
        /// To get customerprofile image.
        /// </summary>
        public static string GetCustomerProfileImage(Int64 cid,string image)
        {
            try
            {
                string imgfile = HttpContext.Current.Server.MapPath("~/content/customers/" + cid.ToString() + "/" + image);
                if (File.Exists(imgfile))
                {
                    return WebsiteUrl + "/content/customers/" + cid.ToString() + "/" + image;
                }
                else
                {
                    return WebsiteUrl + "/customercontent/images/Noprofileimage.png";
                }
            }
            catch {
                return WebsiteUrl + "/customercontent/images/Noprofileimage.png";
            }
        }
        public static string GetSocialMediaLogo(Int32 MediaTypeId, string Logo)
        {
            string image = HttpContext.Current.Server.MapPath("~/content/eventmediaicons/" + MediaTypeId.ToString() + "/" + Logo);
            try
            {
                if (File.Exists(image))
                {
                    return WebsiteUrl + "/content/eventmediaicons/" + MediaTypeId.ToString() + "/" + Logo;
                }
                else
                {
                    return noimage;
                }
            }
            catch
            {

                return noimage;
            }
        }
        public static string GetEventImage(Int64 evid, string imgname)
        {
            if (string.IsNullOrEmpty(imgname))
            {
                return noimage;
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/events/" + evid.ToString() + "/" + imgname);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/events/" + evid.ToString() + "/" + imgname;
                    }
                    else
                    {
                        return noimage;
                    }
                }
                catch
                {

                    return noimage;
                }

            }
        }
        public static string GetCampaignImage(Int64 evid, string imgname)
        {
            if (string.IsNullOrEmpty(imgname))
            {
                return noimage;
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/Campaigns/" + evid.ToString() + "/" + imgname);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/Campaigns/" + evid.ToString() + "/" + imgname;
                    }
                    else
                    {
                        return noimage;
                    }
                }
                catch
                {

                    return noimage;
                }

            }
        }

        public static string GetVideoThumbnailImage(string image)
        {
            try
            {
                string imgfile = HttpContext.Current.Server.MapPath("~/content/videothumbnails/" + image);
                if (File.Exists(imgfile))
                {
                    return WebsiteUrl + "/content/videothumbnails/" + image;
                }
                else
                {
                    return WebsiteUrl + "/content/images/nothumbnail.png";
                }
            }
            catch
            {
                return WebsiteUrl + "/content/images/nothumbnail.png";
            }
        }

        public static string GetOrganisationLogo(int orgid, string logo)
        {
            if (string.IsNullOrEmpty(logo))
            {
                return noimage;
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/organisation/" + orgid.ToString() + "/" + logo);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/organisation/" + orgid.ToString() + "/" + logo;
                    }
                    else
                    {
                        return noimage;
                    }
                }
                catch
                {

                    return noimage;
                }

            }
        }

        public static string GetHelpImages(long imageId, long helpId, string imagename)
        {
            if (string.IsNullOrEmpty(imagename))
            {
                return "";
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/memberhelpimages/" + helpId.ToString() + "/" + imagename);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/memberhelpimages/" + helpId.ToString() + "/" + imagename;
                    }
                    else
                    {
                        return "";
                    }
                }
                catch
                {

                    return "";
                }

            }
        }

        public static string GetHelpVideos(long videoId,long helpId, string videoname)
        {
            if (string.IsNullOrEmpty(videoname))
            {
                return "";
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/memberhelpvideos/" + helpId.ToString() + "/" + videoname);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/memberhelpvideos/" + helpId.ToString() + "/" + videoname;
                    }
                    else
                    {
                        return "";
                    }
                }
                catch
                {

                    return "";
                }

            }
        }

        public static string GetCountryflagImage(string pimage)
        {
            if (string.IsNullOrEmpty(pimage))
            {
                return noimage;
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/Countryflags/" + pimage);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/Countryflags/" + pimage;
                    }
                    else
                    {
                        return noimage;
                    }
                }
                catch
                {

                    return noimage;
                }

            }
        }
        public static string GetResourceDocFile(Int64 ResourceId, string Doc)
        {
            string image = HttpContext.Current.Server.MapPath("~/content/Resource/" + ResourceId.ToString() + "/" + Doc);
            try
            {
                if (File.Exists(image))
                {
                    return WebsiteUrl + "/content/Resource/" + ResourceId.ToString() + "/" + Doc;
                }
                else
                {
                    return noimage;
                }
            }
            catch
            {

                return noimage;
            }
        }
        public static string SetPriceFormat(string price)
        {
            if (price != null && price != "")
            {
                return "$" + string.Format("{0:0.00}", Convert.ToDouble(price));
            }
            else { return "$" + "0.00"; }
        }
        public static string getpostgroupImages(string fname)
        {
            if (string.IsNullOrEmpty(fname))
            {
                return "";
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/postmessages/" + fname);
                try
                {
                    if (File.Exists(image))
                    {
                return WebsiteUrl + "/content/postmessages/" + fname;
                }
                    else
                    {
                        return "";
                    }
                }
                catch
                {

                    return "";
                }

            }
        }
        public static string getChattingImages(string fname)
        {
            if (string.IsNullOrEmpty(fname))
            {
                return "";
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/messages/" + fname);
                try
                {
                if (File.Exists(image))
                {
                return WebsiteUrl + "/content/messages/" + fname;
                }
                else
                {
                    return "";
                }
                }
                catch
                {

                    return "";
                }

            }

        }
        public static string GetHelpImage(Int64 mid, string img)
        {
            if (string.IsNullOrEmpty(img))
            {
                return noimage;
            }
            else
            {
                string image = HttpContext.Current.Server.MapPath("~/content/MemberHelpimages/" + mid.ToString() + "/" + img);
                try
                {
                    if (File.Exists(image))
                    {
                        return WebsiteUrl + "/content/MemberHelpimages/" + mid.ToString() + "/" + img;
                    }
                    else
                    {
                        return noimage;
                    }
                }
                catch
                {

                    return noimage;
                }

            }
        }


        public static string AndroidAppUrl = Convert.ToString(ConfigurationManager.AppSettings["AndroidAppUrl"]);
        public static string IphoneAppUrl = Convert.ToString(ConfigurationManager.AppSettings["IphoneAppUrl"]);

    }

    public class BaseResponse
    {
        public long Id { get; set; }
        public string Message { get; set; }
    }

    public class BaseSearchParams
    {
        public string Search { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
    }

}
