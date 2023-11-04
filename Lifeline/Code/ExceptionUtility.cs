///  Information
///  -----------------------------------------------------------------
///   Namespace:      SolutionsEmpowerment.Code
///   Class:          ExceptionUtility
///   Description:    ExceptionUtility class used to log error information.            
///   Created Date:   20th june, 2017
/// -----------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace Lifeline.Code
{
    /// <summary>
    /// Log Exceptions  Class
    /// </summary>
    public sealed class ExceptionUtility
    {

        // All methods are static, so this can be private 
        private ExceptionUtility()
        { }

        // Log an Exception in App_Data Folder
        public static void LogException(Exception exc, string page, string source)
        {
            string logFilePath = HttpContext.Current.Server.MapPath("~/ErrorLogs/");
            logFilePath = logFilePath + "Errorlog" + "-" + DateTime.Today.ToString("ddMMyyyy") + "." + "txt";
            //Create the Log file directory if it does not exists  
            if (!File.Exists(logFilePath))
            {
                File.Create(logFilePath).Dispose();
            }
            // Open the log file for append and write the log
            using (System.IO.StreamWriter sw = new System.IO.StreamWriter(logFilePath, true))
            {
                sw.WriteLine("********** {0} **********", DateTime.Now);
                if (exc.InnerException != null)
                {
                    sw.Write("Inner Exception Type: ");
                    sw.WriteLine(exc.InnerException.GetType().ToString());
                    sw.Write("Inner Exception: ");
                    sw.WriteLine(exc.InnerException.Message);
                    sw.Write("Inner Source: ");
                    sw.WriteLine(exc.InnerException.Source);
                    if (exc.InnerException.StackTrace != null)
                    {
                        sw.WriteLine("Inner Stack Trace: ");
                        sw.WriteLine(exc.InnerException.StackTrace);
                    }
                }
                sw.Write("Exception Type: ");
                sw.WriteLine(exc.GetType().ToString());
                sw.WriteLine("Exception: " + exc.Message);
                sw.WriteLine("Page: " + page);
                sw.WriteLine("Source: " + source);
                sw.WriteLine("Stack Trace: ");
                if (exc.StackTrace != null)
                {
                    sw.WriteLine(exc.StackTrace);
                    sw.WriteLine();
                }
                sw.Close();
            }
            //NotifySystemOps(exc);
        }

        // Notify System Operators about an exception 
        public static void NotifySystemOps(Exception exc)
        {
            // Include code for notifying IT system operators
        }


    }
}