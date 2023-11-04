using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lifeline.Entity
{
    public class MessageEntity
    {
        public Int32 GMSGId { get; set; }
        public Int32 OrgId { get; set; }
        public Int32 MemberId { get; set; }
        public string Message { get; set; }
        public string MemberImage { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.MemberId, this.MemberImage); } }
        public DateTime PostedDate { get; set; }
        public string FormatedPostedDate { get { return Settings.SetDateTimeFormat(this.PostedDate); } }
        public DateTime ApprovedDate { get; set; }
        public string FosmatedApprovedDate { get { return Settings.SetDateTimeFormat(this.ApprovedDate); } }
        public int Status { get; set; }
        public string SenderName { get; set; }
        public int Sender { get; set; }
        public string PostImage { get; set; }
        public string Imagepath { get { return Settings.getChattingImages(this.PostImage); } }
        public string PostVideo { get; set; }
        public string Videopath { get { return Settings.getChattingImages(this.PostVideo); } }
    }
    public class MessageRequestEntity
    {
        public Int32 CSubId { get; set; }
        public Int32 OrgId { get; set; }
        public Int32 CustomerId { get; set; }
        public string FullName { get; set; }
        public string PImage { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.CustomerId, this.PImage); } }
        public string Mobile { get; set; }
        public string EmailId { get; set; }
        public int CountryId { get; set; }
        public string CountryName { get; set; }
        public int PostMessage { get; set; }
        public int TotalRecords { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedDateString { get { return Settings.SetDateTimeFormat(this.CreatedDate); } }
        public DateTime ModifiedDate { get; set; }
        public string ModifiedDateString { get { return Settings.SetDateFormat(this.ModifiedDate); } }
    }
    public class PostMessage
    {
        public Int32 groupid { get; set; }
        public Int32 mid { get; set; }
        public string msg { get; set; }
        public string Pimage { get; set; }
        public string Pvideo { get; set; }
        public string imgextension { get; set; }
        public string vidextension { get; set; }
    }
    public class ChatPostMessage
    {
        public Int64 frmid { get; set; }
        public Int64 toid { get; set; }
        public string toids { get; set; }
        public int ismultiple { get; set; }
        public int isgroup { get; set; }
        public string msg { get; set; }
        public string Pimage { get; set; }
        public string Pvideo { get; set; }
        public string imgextension { get; set; }
        public string vidextension { get; set; }
        public Int64 chatid { get; set; }
    }
    public class ChatList
    {
        public Int64 ChatId { get; set; }
        public Int64 MemberId { get; set; }
        public int IsGroup { get; set; }
        public Int64 LastMessageId { get; set; }
        public string MessageText { get; set; }
        public string Image { get; set; }
        public string ImagePath { get { return Settings.getChattingImages(Image); } }
        public string Video { get; set; }
        public string VideoPath { get { return Settings.getChattingImages(Video); } }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Name { get { return this.FirstName + " " + this.LastName; } }
        public string ProfilePic { get; set; }
        public string ProfileImage { get { return Settings.GetCustomerProfileImage(MemberId, ProfilePic); } }

        public DateTime LastMessageDate { get; set; }
        public string LastMessageDatestring { get { return Settings.SetDateTimeFormat(this.LastMessageDate); } }
        public DateTime CreatedDate { get; set; }
        public string CreatedDateString { get { return Settings.SetDateTimeFormat(this.CreatedDate); } }

    }
    public class ChatMessages
    {
        public Int64 SenderId { get; set; }
        public string SenderName { get; set; }
        public string SenderImage { get; set; }
        public string SenderImagePath { get { return Settings.GetCustomerProfileImage(SenderId, SenderImage); } }
        public Int64 ReceiverId { get; set; }
        public string ReceiverName { get; set; }
        public string ReceiverImage { get; set; }
        public string ReceiverImagePath { get { return Settings.GetCustomerProfileImage(ReceiverId, ReceiverImage); } }
        public Int64 ChatId { get; set; }
        public Int64 MessageId { get; set; }
        public string MessageText { get; set; }
        public string Image { get; set; }
        public string ImagePath { get { return Settings.getChattingImages(Image); } }
        public string Video { get; set; }
        public string VideoPath { get { return Settings.getChattingImages(Video); } }
        public int IsSender { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string CreatedDateString { get { return Settings.SetDateTimeFormat(this.CreatedDate); } }
    }
    public class MessagePostEntity
    {
        public Int32 GMSGId { get; set; }
        public Int32 OrgId { get; set; }
        public Int32 MemberId { get; set; }
        public string Message { get; set; }
        public string MemberImage { get; set; }
        public string CustomerImagePath { get { return Settings.GetCustomerProfileImage(this.MemberId, this.MemberImage); } }
        public DateTime PostedDate { get; set; }
        public string FormatedPostedDate { get { return Settings.SetDateTimeFormat(this.PostedDate); } }
        public DateTime ApprovedDate { get; set; }
        public string FosmatedApprovedDate { get { return Settings.SetDateTimeFormat(this.ApprovedDate); } }
        public int Status { get; set; }
        public string SenderName { get; set; }
        public int Sender { get; set; }
        public string PostImage { get; set; }
        public string Imagepath { get { return Settings.getpostgroupImages(this.PostImage); } }
        public string PostVideo { get; set; }
        public string Videopath { get { return Settings.getpostgroupImages(this.PostVideo); } }
    }
    public class CustomerGroupsEntity
    {
        public Int32 CGId { get; set; }
        public Int32 MemberId { get; set; }
        public string GroupName { get; set; }
        public string GroupMembers { get; set; }
    }
}
