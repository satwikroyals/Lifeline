using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lifeline.Entity
{
    public class CountryEntity
    {
        public Int32 CountryId { get; set; }
        public string Country { get; set; }
        public string CountryCode { get; set; }
        public string Countryflag { get; set; }
        public string Countryflagpath { get { return Settings.GetCountryflagImage(this.Countryflag); } }
        public string CountryInfo { get; set; }
    }
    public class Stateddl
    {
        public Int64 StateId { get; set; }
        public string StateName { get; set; }
    }
    public class Regionddl
    {
        public Int64 RegionId { get; set; }
        public string Region { get; set; }
    }
    public class Townddl
    {
        public Int64 TownId { get; set; }
        public string Town { get; set; }
    }
    public class LocationEntity
    {
        public Int32 LocationId { get; set; }
        public string Location { get; set; }
        public Int32 TownId { get; set; }
        public string Town { get; set; }
        public string LocationInfo { get; set; }
    }
    public class MemberddlEntity
    {
        public Int64 MemberId { get; set; }
        public string Name { get; set; }
    }
    public class paggingEntity
    {
        public int pgsize { get; set; }
        public int pgindex { get; set; }
        public string str { get; set; }
        public int sortby { get; set; }
    }
    public class Campaignddl
    {
        public Int32 CampaignId { get; set; }
        public string CampaignTitle { get; set; }
    }

    public class ApiCrudResponse
    {
        public bool IsSuccess { get; set; }
        public string ResultMessage { get; set; }        
    }

    public class DdlEntity
    {
        public long Id { get; set; }
        public string Text { get; set; }
    }

}
