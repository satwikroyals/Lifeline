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
    public class ResourceController : ApiController
    {
        ResourceManager objrm = new ResourceManager();
        [Route("api/GetAdminResourceDocuments")]
        [HttpGet]
        public List<ResourceEntity> GetAdminResourceDocuments([FromUri]paggingEntity ps)
        {
            try
            {
                return objrm.GetResourceDocuments(ps);
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "ResourceController", "GetAdminResourceDocuments-Services");
                return new List<ResourceEntity>();
            }
        }
        [Route("api/DeleteDocument")]
        [HttpPost]
        public ResourceEntity DeleteDocument(Int64 did)
        {
            return objrm.DeleteDocument(did);
        }
        [Route("api/GetResourceDocuments")]
        [HttpGet]
        public List<ResourceEntity> GetResourceDocuments()
        {
            try
            {
                return objrm.GetResourceDocuments();
            }
            catch (Exception ex)
            {
                ExceptionUtility.LogException(ex, "ResourceController", "GetResourceDocuments-Services");
                return new List<ResourceEntity>();
            }
        }
    }
}
