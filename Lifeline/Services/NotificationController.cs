using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Lifeline.Entity;
using Lifeline.BAL;
using Lifeline.Code;
using System.IO;
using System.Text.RegularExpressions;

namespace Lifeline.Services
{
    public class NotificationController : ApiController
    {
        NotificationManager objcm = new NotificationManager();
        /// <summary>
        /// Get All Member Notifications
        /// </summary>
        /// <param name="mid">Member Id</param>
        /// <returns>List of notifications</returns>
        [Route("api/GetNotificationList")]
        [HttpGet]
        public List<NotificationEntity> GetNotificationList(Int64 mid)
        {
            try
            {
                return objcm.GetNotificationList(mid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Notification", "GetNotificationList-Services");
                return new List<NotificationEntity>();
            }
        }
        /// <summary>
        /// Update Notification After Member see notification to viewed
        /// </summary>
        /// <param name="id">id from list</param>
        /// <returns></returns>
        [Route("api/UpdateNotificationView")]
        [HttpGet]
        public StatusResponse UpdateNotificationView(Int64 id)
        {
            try
            {
                return objcm.UpdateNotificationView(id);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Notification", "UpdateNotificationView-Services");
                return new StatusResponse();
            }
        }
        /// <summary>
        /// Send Member Response to notification
        /// </summary>
        /// <param name="id">id from list</param>
        /// <param name="res">Response from member</param>
        /// <returns></returns>
        [Route("api/InsertNotificationResponse")]
        [HttpGet]
        public StatusResponse InsertNotificationResponse(Int64 id,string res)
        {
            try
            {
                return objcm.InsertNotificationResponse(id, res);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Notification", "InsertNotificationResponse-Services");
                return new StatusResponse();
            }
        }
        /// <summary>
        /// Get Admin Notification List
        /// </summary>
        /// <param name="coid">CoordinatorId</param>
        /// <param name="aid">AdminId</param>
        /// <returns></returns>
        [Route("api/GetCoordinatorNotificationList")]
        [HttpGet]
        public List<NotificationEntity> GetCoordinatorNotificationList(Int64 coid, Int64 aid,[FromUri]paggingEntity es)
        {
            try
            {
                return objcm.GetCoordinatorNotificationList(es,coid, aid);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "Notification", "GetCoordinatorNotificationList-Services");
                return new List<NotificationEntity>();
            }
        }
    }
}
