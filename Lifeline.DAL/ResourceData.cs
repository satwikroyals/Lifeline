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
    public class ResourceData
    {
        public List<ResourceEntity> GetResourceDocuments(paggingEntity ps)
        {
            try
            {
                DapperRepositry<ResourceEntity> _repo = new DapperRepositry<ResourceEntity>(Settings.ProviederName, Settings.DbConnection);
                DynamicParameters param = new DynamicParameters();
                param.Add("PageIndex", ps.pgindex, DbType.Int32, ParameterDirection.Input);
                param.Add("PageSize", ps.pgsize, DbType.Int32, ParameterDirection.Input);
                param.Add("Searchstr", ps.str, DbType.String, ParameterDirection.Input);
                param.Add("SortBy", ps.sortby, DbType.Int16, ParameterDirection.Input);
                return _repo.GetList("AdminGetResources", param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public StatusResponse AddResourceDocuments(ResourceEntity be)
        {
            try
            {
                DapperRepositry<StatusResponse> _repo = new DapperRepositry<StatusResponse>(Settings.ProviederName, Settings.DbConnection);
                DynamicParameters param = new DynamicParameters();
                param.Add("@ResourceId", be.ResourceId, DbType.Int64, ParameterDirection.Input);
                param.Add("@CaseStudyId", be.CaseStudyId, DbType.String, ParameterDirection.Input);
                param.Add("@DocTitle", be.DocTitle, DbType.String, ParameterDirection.Input);
                param.Add("@ResourceDoc", be.ResourceDoc, DbType.String, ParameterDirection.Input);
                param.Add("@ResourceBrief", be.ResourceBrief, DbType.String, ParameterDirection.Input);
                param.Add("@VideoUrl", be.VideoUrl, DbType.String, ParameterDirection.Input);
                return _repo.GetResult("AddResourceDocument", param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public ResourceEntity GetResourceDocumentById(Int64 did)
        {
            try
            {
                DapperRepositry<ResourceEntity> _repo = new DapperRepositry<ResourceEntity>(Settings.ProviederName, Settings.DbConnection);
                DynamicParameters param = new DynamicParameters();
                param.Add("@ResourceId", did, DbType.Int64, ParameterDirection.Input);

                return _repo.GetResult("GetResourceById", param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public ResourceEntity DeleteDocument(Int64 did)
        {
            try
            {
                DapperRepositry<ResourceEntity> _repo = new DapperRepositry<ResourceEntity>(Settings.ProviederName, Settings.DbConnection);
                DynamicParameters param = new DynamicParameters();
                param.Add("@ResourceId", did, DbType.Int64, ParameterDirection.Input);

                return _repo.GetResult("DeleteDocument", param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<ResourceEntity> GetResourceDocuments()
        {
            try
            {
                DapperRepositry<ResourceEntity> _repo = new DapperRepositry<ResourceEntity>(Settings.ProviederName, Settings.DbConnection);
                DynamicParameters param = new DynamicParameters();

                return _repo.GetList("GetResourceDocuments", param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
