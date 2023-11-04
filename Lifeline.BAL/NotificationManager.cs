using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.Entity;
using Lifeline.DAL;

namespace Lifeline.BAL
{
    public class NotificationManager
    {
        NotificationData nd = new NotificationData();
        public List<NotificationEntity> GetNotificationList(Int64 mid)
        {
            return nd.GetNotificationList(mid);
        }
        public StatusResponse UpdateNotificationView(Int64 id)
        {
            return nd.UpdateNotificationView(id);
        }
        public StatusResponse InsertNotificationResponse(Int64 id,string res)
        {
            return nd.InsertNotificationResponse(id, res);
        }
        public List<NotificationEntity> GetCoordinatorNotificationList(paggingEntity es, Int64 coid, Int64 aid)
        {
            return nd.GetCoordinatorNotificationList(es, coid, aid);
        }
        public StatusResponse AddNotification(NotificationEntity nEntity)
        {
            return nd.AddNotification(nEntity);
        }
    }
}
