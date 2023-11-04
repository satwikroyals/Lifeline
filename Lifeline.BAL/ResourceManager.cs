using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Lifeline.Entity;
using Lifeline.DAL;

namespace Lifeline.BAL
{
    public class ResourceManager
    {
        ResourceData objrd=new ResourceData();
        public List<ResourceEntity> GetResourceDocuments(paggingEntity ps)
        {
            return objrd.GetResourceDocuments(ps);
        }
        public StatusResponse AddResourceDocuments(ResourceEntity be)
        {
            return objrd.AddResourceDocuments(be);
        }
        public ResourceEntity GetResourceDocumentById(Int64 did)
        {
            return objrd.GetResourceDocumentById(did);
        }
        public ResourceEntity DeleteDocument(Int64 did)
        {
            return objrd.DeleteDocument(did);
        }
        public List<ResourceEntity> GetResourceDocuments()
        {
            return objrd.GetResourceDocuments();
        }
    }
}
