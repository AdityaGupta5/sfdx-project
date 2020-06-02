@RestResource(UrlMapping='/project/*')
global class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Opportunity oppty;
        String msg;
        If(String.isNotBlank(OpportunityId)) {
        	oppty = new Opportunity(Id = OpportunityId, DeliveryInstallationStatus__c = 'In progress');
            
            Project__c project = createOrUpdateProject(ProjectRef, OpportunityId);
            project.Name = ProjectName;
            //project.Opportunity__c = OpportunityId;
            project.Start_Date__c = StartDate;
            project.End_Date__c = EndDate;
            project.Billable_Amount__c = Amount;
            project.Status__c = Status;
            
            SavePoint sp = Database.setSavepoint();
            try {
            	Update oppty;
                Upsert project;
                msg = 'OK';
            } catch(Exception ex) {
                Database.rollback(sp);
                System.debug('Exception ===> ' + ex.getMessage());
                msg = ex.getMessage();
            }
        }
        return msg;
    }
    
    private static Project__c createOrUpdateProject(String ProjectRef, String OppId) {
        Project__c project; 
        If(String.isNotBlank(ProjectRef)) {
            List<Project__c> projectList = [Select Id, Name From Project__c Where ProjectRef__c =: ProjectRef AND Opportunity__c =: OppId];
            System.debug('projectList ====> ' + projectList);
            If(projectList == Null || projectList.isEmpty()) {
                project = new Project__c(); 
                project.Opportunity__c = OppId;
                project.ProjectRef__c = ProjectRef;
            } else {
                project = projectList[0];
            }      
        }    
        return project;
    }
}