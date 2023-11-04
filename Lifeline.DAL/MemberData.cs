using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using DbFactory.Repositories;
using Lifeline.Entity;
using DbFactory;
using System.Data;
using System.Data.SqlClient;

namespace Lifeline.DAL
{
    public class MemberData
    {
        public MemberEntity MemberLogin(string userid, string pin, string deviceid, int devicetype)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@UserId", userid, DbType.String, ParameterDirection.Input);
            param.Add("@Pin", pin, DbType.String, ParameterDirection.Input);
            param.Add("@DeviceId", deviceid, DbType.String, ParameterDirection.Input);
            param.Add("@AppType", devicetype, DbType.Int16, ParameterDirection.Input);

            return _repo.GetResult("GetMemberLogin", param);
        }
        public StatusResponse MemberRegister(MemberEntity cEntity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", cEntity.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@CoordinatorId", cEntity.CoordinatorId, DbType.Int32, ParameterDirection.Input);
            param.Add("@FirstName", cEntity.FirstName, DbType.String, ParameterDirection.Input);
            param.Add("@LastName", cEntity.LastName, DbType.String, ParameterDirection.Input);
            param.Add("@UserId", cEntity.UserId, DbType.String, ParameterDirection.Input);
            param.Add("@Pin", cEntity.Pin, DbType.String, ParameterDirection.Input);
            param.Add("@LocationId", cEntity.LocationId, DbType.Int64, ParameterDirection.Input);
            param.Add("@CountryId", cEntity.CountryId, DbType.Int16, ParameterDirection.Input);
            param.Add("@StateId", cEntity.StateId, DbType.Int32, ParameterDirection.Input);
            param.Add("@CommunityBelong", cEntity.CommunityBelong, DbType.String , ParameterDirection.Input);
            param.Add("@Gender", cEntity.Gender, DbType.Int16, ParameterDirection.Input);
            param.Add("@ReferredById", cEntity.ReferredById, DbType.Int32, ParameterDirection.Input);
            param.Add("@GeoAddress", cEntity.GeoAddress, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", cEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", cEntity.Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@MemberInfo", cEntity.MemberInfo, DbType.String, ParameterDirection.Input);
            param.Add("@EmailId", cEntity.EmailId, DbType.String, ParameterDirection.Input);
            param.Add("@Mobile", cEntity.Mobile, DbType.String, ParameterDirection.Input);
            param.Add("@PostCode", cEntity.PostCode, DbType.String, ParameterDirection.Input);
            param.Add("@ProfilePic", cEntity.ProfilePic, DbType.String, ParameterDirection.Input);
            param.Add("@OrganisationName", cEntity.OrganisationName, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("MemberRegister", param);
        }
        public MemberEntity GetMemberProfile(Int64 mid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetResult("GetMemberProfile", param);
        }
        public StatusResponse UpdateMemberProfileMobileApp(MemberEntity cEntity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", cEntity.MemberId, DbType.Int32, ParameterDirection.Input);          
            param.Add("@FirstName", cEntity.FirstName, DbType.String, ParameterDirection.Input);
            param.Add("@LastName", cEntity.LastName, DbType.String, ParameterDirection.Input);   
            param.Add("@GeoAddress", cEntity.GeoAddress, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", cEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", cEntity.Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@EmailId", cEntity.EmailId, DbType.String, ParameterDirection.Input);
            param.Add("@Mobile", cEntity.Mobile, DbType.String, ParameterDirection.Input);
            param.Add("@PostCode", cEntity.PostCode, DbType.String, ParameterDirection.Input);
            param.Add("@Street", cEntity.Street, DbType.String, ParameterDirection.Input);
            param.Add("@Suburb", cEntity.Suburb, DbType.String, ParameterDirection.Input);
            param.Add("@City", cEntity.City, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("UpdateMemberProfileMobileApp", param);
        }

        public StatusResponse AddMemberSOS(MemberSOSContactEntity cEntity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", cEntity.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@Name", cEntity.Name, DbType.String, ParameterDirection.Input);
            param.Add("@EmailId", cEntity.EmailId, DbType.String, ParameterDirection.Input);
            param.Add("@Mobile", cEntity.Mobile, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AddMemberSOS", param);
        }
        public LoginResponse CheckMemberRegister(string Mobile, string deviceid, int devicetype)
        {
            DapperRepositry<LoginResponse> _repo = new DapperRepositry<LoginResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Mobile", Mobile, DbType.String, ParameterDirection.Input);
            param.Add("@DeviceId", deviceid, DbType.String, ParameterDirection.Input);
            param.Add("@AppType", devicetype, DbType.Int16, ParameterDirection.Input);


            return _repo.GetResult("CheckMemberRegister", param);
        }

        public StatusResponse InsertAllSOScontacts(MemberSOSContacts cs)
        {
            string connection = Settings.DbConnection;
            StatusResponse sb = new StatusResponse();
            try
            {
                DataTable custanswers = getdatatblofcustspcanswers(cs.Contacts);
                SqlConnection con = new SqlConnection(connection);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlCommand cmd = new SqlCommand("AddAllMemberSOScontacts", con);

                cmd.Parameters.Add(new SqlParameter
                {
                    ParameterName = "@Members",
                    SqlDbType = SqlDbType.Structured,
                    Value = custanswers
                });
                cmd.Parameters.AddWithValue("@MemberId", cs.MemberId);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    if (dr.Read())
                    {

                        sb.StatusCode = Convert.ToInt16(dr["StatusCode"]);
                        sb.StatusMessage = Convert.ToString(dr["StatusMessage"]);

                    }
                }
                cmd.Dispose();
                dr.Close();
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                }

                return sb;
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public DataTable getdatatblofcustspcanswers(List<MemberSOSContactEntity> sbc)
        {
            DataTable custspcanswers = new DataTable();
            custspcanswers.Columns.Add("Name");
            custspcanswers.Columns.Add("EmailId");
            custspcanswers.Columns.Add("Mobile");
            foreach (MemberSOSContactEntity t in sbc)
            {
                var values = new object[3];
                //inserting property values to datatable rows
                values[0] = t.Name;
                values[1] = t.EmailId;
                values[2] = t.Mobile;
                custspcanswers.Rows.Add(values);
            }
            return custspcanswers;
        }

        public MemberCoordinators GetMemberCoordinators(Int32 mid)
        {
            DbFactory.DbSettings _db = new DbFactory.DbSettings(Settings.ProviederName, Settings.DbConnection);
            MemberCoordinators _repo = new MemberCoordinators();
            List<MemberSOSContactEntity> sos = new List<MemberSOSContactEntity>();
            List<MemberEntity> tc = new List<MemberEntity>();
            List<MemberEntity> ac = new List<MemberEntity>();
            List<MemberEntity> av = new List<MemberEntity>();
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            using (IDbConnection db = (IDbConnection)_db.ConnectionString)
            {
                var result = db.QueryMultiple("GetMemberSOSContact", commandType: CommandType.StoredProcedure, param: param);
                sos = result.Read<MemberSOSContactEntity>().ToList();
                tc = result.Read<MemberEntity>().ToList();
                ac = result.Read<MemberEntity>().ToList();
                _repo.SOScontacts = sos;
                _repo.TownCoordinators = tc;
                _repo.AreaCoordinators = ac;
                _repo.AreaVolunteers = av;
            }
            return _repo;
        }
        public InsertMemberHelpEntity CoordinatorSeekHelp(MemberHelpEntity mEntity)
        {
            DapperRepositry<InsertMemberHelpEntity> _repo = new DapperRepositry<InsertMemberHelpEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mEntity.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@HelpText", mEntity.Message, DbType.String, ParameterDirection.Input);
            param.Add("@Image", mEntity.Image, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", mEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", mEntity.Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Postcode", mEntity.Postcode, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("InsertCoordinatorHelp", param);
        }
        public InsertMemberHelpEntity SeekHelp(MemberHelpEntity mEntity)
        {
            DapperRepositry<InsertMemberHelpEntity> _repo = new DapperRepositry<InsertMemberHelpEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mEntity.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@HelpText", mEntity.Message, DbType.String, ParameterDirection.Input);
            param.Add("@Image", mEntity.Image, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", mEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", mEntity.Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Postcode", mEntity.Postcode, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("InsertMemberHelp", param);
        }
        public AddHelpVideosResponseEntity AddMemberHelpVideos(AddHelpVideosEntity ent)
        {
            DapperRepositry<AddHelpVideosResponseEntity> _repo = new DapperRepositry<AddHelpVideosResponseEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", ent.HelpId, DbType.Int32, ParameterDirection.Input);
            param.Add("@MemberId", ent.MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@VideoName", ent.VideoName, DbType.String, ParameterDirection.Input);
            return _repo.GetResult("AddMemberHelpVideos", param);
        }

        public List<HelpVideosEntity> GetMemberHelpVideos(GetMemberHelpVideosParams helpParams)
        {
            DapperRepositry<HelpVideosEntity> _repo = new DapperRepositry<HelpVideosEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", helpParams.MemberId, DbType.Int64, ParameterDirection.Input);
            param.Add("@HelpId", helpParams.HelpId, DbType.Int64, ParameterDirection.Input);
            return _repo.GetList("GetMemberHelpVideos", param);
        }

        public StatusResponse AddMemberCampaign(Int32 MemberId, string CampaignTitle, string Image, int LocationId, DateTime? StartTime, DateTime? EndTime, string GeoLocation, decimal Latitude, decimal Longitude, string CampaignInfo, string SpecialInstructions)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId",MemberId, DbType.Int32, ParameterDirection.Input);
            param.Add("@CampaignTitle", CampaignTitle, DbType.String, ParameterDirection.Input);
            param.Add("@Image",Image, DbType.String, ParameterDirection.Input);
            param.Add("@LocationId", LocationId, DbType.Int16, ParameterDirection.Input);
            param.Add("@StartTime", StartTime, DbType.DateTime, ParameterDirection.Input);
            param.Add("@EndTime", EndTime, DbType.DateTime, ParameterDirection.Input);
            param.Add("@GeoLocation", GeoLocation, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@CampaignInfo", CampaignInfo, DbType.String, ParameterDirection.Input);
            param.Add("@SpecialInstructions", SpecialInstructions, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AddMemberCampaign", param);
        }
        public StatusResponse MemberSignToCampaign(Int32 mid,Int32 campid,string msg)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CampaignId", campid, DbType.Int32, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            param.Add("@Message", msg, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("InsertCampaignMember", param);
        }
        public Campaigns GetMemberCampaigns(Int32 mid)
        {
            DbFactory.DbSettings _db = new DbFactory.DbSettings(Settings.ProviederName, Settings.DbConnection);
            Campaigns _repo = new Campaigns();
            List<CampaignEntity> tc = new List<CampaignEntity>();
            List<CampaignEntity> ac = new List<CampaignEntity>();
            List<CampaignEntity> av = new List<CampaignEntity>();
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            using (IDbConnection db = (IDbConnection)_db.ConnectionString)
            {
                var result = db.QueryMultiple("GetCampaigns", commandType: CommandType.StoredProcedure, param: param);
                tc = result.Read<CampaignEntity>().ToList();
                ac = result.Read<CampaignEntity>().ToList();
                av = result.Read<CampaignEntity>().ToList();
                _repo.NewCampaigns = tc;
                _repo.signed = ac;
                _repo.Completed = av;
            }
            return _repo;
        }
        public StatusResponse UpdateCampignNotificationView(Int64 id)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Id", id, DbType.Int64, ParameterDirection.Input);
            return _repo.GetResult("UpdateCampaignNotificationCustomerView", param);
        }
        public StatusResponse StartCampaign(Int32 mid, Int32 campid, decimal Latitude,decimal Longitude)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CampaignId", campid, DbType.Int32, ParameterDirection.Input);
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);
            param.Add("@Latitude", Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", Longitude, DbType.Decimal, ParameterDirection.Input);

            return _repo.GetResult("StartCampaignTracking", param);
        }
        public HelpSeekingMemberProfile GetHelpSeekingMember(long mid)
        {
            DapperRepositry<HelpSeekingMemberProfile> _repo = new DapperRepositry<HelpSeekingMemberProfile>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetResult("GetHelpSeekingMember", param);
        }


        public List<MemberDevices> GetCoordinatorMemberDevices(Int64 mid)
        {
            DapperRepositry<MemberDevices> _repo = new DapperRepositry<MemberDevices>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);

            return _repo.GetList("GetMemberDevices", param);
        }

        public List<MemberDevices> GetCoordinatorDevicesByMemberId(Int64 mid)
        {
            DapperRepositry<MemberDevices> _repo = new DapperRepositry<MemberDevices>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int32, ParameterDirection.Input);

            return _repo.GetList("GetCoordinatorDevicesByMemberId", param);
        }

        public CoordinatorSOS GetCoordinatorSOSMembers(Int64 mid)
        {
            DbFactory.DbSettings _db = new DbFactory.DbSettings(Settings.ProviederName, Settings.DbConnection);
            CoordinatorSOS _repo = new CoordinatorSOS();
            List<HelpSeekingMemberProfile> sos = new List<HelpSeekingMemberProfile>();
            List<HelpSeekingMemberProfile> tc = new List<HelpSeekingMemberProfile>();
            DynamicParameters param = new DynamicParameters();
            param.Add("@CoordinatorId", mid, DbType.Int32, ParameterDirection.Input);
            using (IDbConnection db = (IDbConnection)_db.ConnectionString)
            {
                var result = db.QueryMultiple("GetCoordinatorSOSMemebers", commandType: CommandType.StoredProcedure, param: param);
                sos = result.Read<HelpSeekingMemberProfile>().ToList();
                tc = result.Read<HelpSeekingMemberProfile>().ToList();
                _repo.Latest = sos;
                _repo.Noticed = tc;
            }
            return _repo;
        }
        public GetHelpSeekingMemberDetailsModel GetHelpSeekingMemberDetails(long helpid)
        {
            DbFactory.DbSettings _db = new DbFactory.DbSettings(Settings.ProviederName, Settings.DbConnection);
            GetHelpSeekingMemberDetailsModel _repo = new GetHelpSeekingMemberDetailsModel();            
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", helpid, DbType.Int64, ParameterDirection.Input);
            using (IDbConnection db = (IDbConnection)_db.ConnectionString)
            {
                var result = db.QueryMultiple("GetHelpSeekingMemberDetails", commandType: CommandType.StoredProcedure, param: param);              
                _repo.Member = result.Read<HelpSeekingMemberProfile>().FirstOrDefault();
                _repo.Images = result.Read<HelpImagesEntity>().ToList();
                _repo.Videos = result.Read<HelpVideosEntity>().ToList();
            }
            return _repo;
        }
        public HelpStatusResponse RescueActionBtn(Int64 helpid, int action)
        {
            DapperRepositry<HelpStatusResponse> _repo = new DapperRepositry<HelpStatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", helpid, DbType.Int64, ParameterDirection.Input);
            param.Add("@Action", action, DbType.Int16, ParameterDirection.Input);

            return _repo.GetResult("RescueActionbtn", param);
        }
        public List<MemberEntity> SendNearestCoordinatorNotification(double Latitude, double Longitude,string Postcode)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Latitude", Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Postcode", Postcode, DbType.String, ParameterDirection.Input);

            return _repo.GetList("SendtoNearestCoordinator", param);
        }
        public List<MemberEntity> GetIncidentNearestVolunteers(double Latitude, double Longitude, string Postcode)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@Latitude", Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", Longitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Postcode", Postcode, DbType.String, ParameterDirection.Input);

            return _repo.GetList("GetIncidentNearestVolunteers", param);
        }
        public List<MemberEntity> GetHelpSentVolunteers(long helpid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", helpid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetList("GetHelpSentVolunteers", param);
        }
        public List<CampaignMemberEntity> GetCampaignMembers(Int32 mid,Int32 cmid)
        {
            DapperRepositry<CampaignMemberEntity> _repo = new DapperRepositry<CampaignMemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CoordinatorId", mid, DbType.Decimal, ParameterDirection.Input);
            param.Add("@CampaignId", cmid, DbType.Decimal, ParameterDirection.Input);

            return _repo.GetList("GetCoordinatorCampaignMembers", param);
        }
        public List<MemberTracking> GetMemberTracking(Int32 mid, Int32 cmid)
        {
            DapperRepositry<MemberTracking> _repo = new DapperRepositry<MemberTracking>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Decimal, ParameterDirection.Input);
            param.Add("@CampaignId", cmid, DbType.Decimal, ParameterDirection.Input);

            return _repo.GetList("GetMemberTracking", param);
        }
        public List<MemberEntity> GetCoordinatorVolunteers(Int32 mid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CoordinatorId", mid, DbType.Decimal, ParameterDirection.Input);

            return _repo.GetList("GetCoordinatorVolunteers", param);
        }
        public StatusResponse AssignToVolunteer(Int64 helpid, string MemberIds)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", helpid, DbType.Int64, ParameterDirection.Input);
            param.Add("@VolunteerIds", MemberIds, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("AssignVolunteerTask", param);
        }
        public List<HelpSeekingMemberProfile> GetVolunteerTasks(Int64 volunteerid)
        {
            DapperRepositry<HelpSeekingMemberProfile> _repo = new DapperRepositry<HelpSeekingMemberProfile>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", volunteerid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetList("GetVolunteerTask", param);
        }
        public StatusResponse VolunteerRescueActionBtn(Int64 helpid, Int64 volunteerid)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", helpid, DbType.Int64, ParameterDirection.Input);
            param.Add("@VolunteerId", volunteerid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetResult("VolunteerRescueActionbtn", param);
        }
        public RespondHelpByVolunteerResponse RespondHelpByVolunteer(RespondHelpByVolunteerParams p)
        {
            DapperRepositry<RespondHelpByVolunteerResponse> _repo = new DapperRepositry<RespondHelpByVolunteerResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", p.HelpId, DbType.Int64, ParameterDirection.Input);
            param.Add("@MemberId", p.MemberId, DbType.Int64, ParameterDirection.Input);
            param.Add("@IsAccepted", p.IsAccepted, DbType.Boolean, ParameterDirection.Input);
            return _repo.GetResult("RespondHelpByVolunteer", param);
        }
        public HelpRespondedVolunteerDetailsResponse GetHelpRespondedVolunteerDetails(HelpRespondedVolunteerDetailsParams p)
        {
            DapperRepositry<HelpRespondedVolunteerDetailsResponse> _repo = new DapperRepositry<HelpRespondedVolunteerDetailsResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", p.HelpId, DbType.Int64, ParameterDirection.Input);
            param.Add("@MemberId", p.MemberId, DbType.Int64, ParameterDirection.Input);

            return _repo.GetResult("GetHelpRespondedVolunteerDetails", param);
        }

        public HelpSeekingMemberProfile GetHelpbyId(Int64 helpid)
        {
            DapperRepositry<HelpSeekingMemberProfile> _repo = new DapperRepositry<HelpSeekingMemberProfile>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@HelpId", helpid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetResult("GetHelpById", param);
        }

        public StatusResponse InsertSupportMessage(MemberSupportEntity Sentity)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@SupportId", Sentity.SupportId, DbType.Int64, ParameterDirection.Input);
            param.Add("@MemberId", Sentity.MemberId, DbType.Int64, ParameterDirection.Input);
            param.Add("@Subject", Sentity.Subject, DbType.String, ParameterDirection.Input);
            param.Add("@Message", Sentity.Message, DbType.String, ParameterDirection.Input);

            return _repo.GetResult("InsertMemberSupport", param);
        }
        public StatusResponse DeleteSOScontact(Int64 contactid)
        {
            DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@ContactId", contactid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetResult("DeleteSOScontact", param);
        }
        public List<MemberEntity> GetCoordinatorLocationMembers(Int64 mid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetList("GetCoordinatorLocationMembers", param);
        }
        public List<MemberEntity> GetCoordinatorMembers(long mid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);

            return _repo.GetList("GetCoordinatorMembers", param);
        }

        public MemberEntity CheckUserLogin(string userid, string pin, string deviceid, int devicetype)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@UserId", userid, DbType.String, ParameterDirection.Input);
            param.Add("@Pin", pin, DbType.String, ParameterDirection.Input);
            param.Add("@DeviceId", deviceid, DbType.String, ParameterDirection.Input);
            param.Add("@AppType", devicetype, DbType.Int16, ParameterDirection.Input);

            return _repo.GetResult("GetUserLogin", param);
        }

        public int InactiveMemberFromMobileApp(long mid)
        {
            DapperRepositry<MemberEntity> _repo = new DapperRepositry<MemberEntity>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@MemberId", mid, DbType.Int64, ParameterDirection.Input);
            var result=_repo.GetResult("InactiveMemberFromMobileApp", param);
            return 1;
        }

        public MemberRegisterMobileAppResponse MemberRegisterMobileApp(MemberRegisterMobileAppEntity cEntity)
        {
            DapperRepositry<MemberRegisterMobileAppResponse> _repo = new DapperRepositry<MemberRegisterMobileAppResponse>(Settings.ProviederName, Settings.DbConnection);
            DynamicParameters param = new DynamicParameters();
            param.Add("@CoordinatorId", cEntity.CoordinatorId, DbType.Int32, ParameterDirection.Input);
            param.Add("@FirstName", cEntity.FirstName, DbType.String, ParameterDirection.Input);
            param.Add("@LastName", cEntity.LastName, DbType.String, ParameterDirection.Input);
            param.Add("@UserId", cEntity.UserId, DbType.String, ParameterDirection.Input);
            param.Add("@Pin", cEntity.Pin, DbType.String, ParameterDirection.Input);       
            param.Add("@GeoAddress", cEntity.GeoAddress, DbType.String, ParameterDirection.Input);
            param.Add("@Latitude", cEntity.Latitude, DbType.Decimal, ParameterDirection.Input);
            param.Add("@Longitude", cEntity.Longitude, DbType.Decimal, ParameterDirection.Input);           
            param.Add("@Mobile", cEntity.Mobile, DbType.String, ParameterDirection.Input);
            param.Add("@EmailId", cEntity.EmailId, DbType.String, ParameterDirection.Input);
            param.Add("@PostCode", cEntity.PostCode, DbType.String, ParameterDirection.Input);
            param.Add("@MemberType", cEntity.MemberType, DbType.Int32, ParameterDirection.Input);
            return _repo.GetResult("MemberRegisterMobileApp", param);
        }

    }
}
