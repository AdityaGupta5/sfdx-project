public class BillingCalloutService {
    
    public static List<Project__c> getProjectDetails(List<Project__c> projectList, Map<Id, Project__c> oldProjectMap) {
        List<Project__c> projects = new List<Project__c>();
        if(projectList != null & !projectList.isEmpty()) {
        	//callBillingService(projectList[0].Id); 
            For(Project__c proj : projectList) {
                if(proj.Status__c == 'Billable' && oldProjectMap.get(proj.Id).Status__c != 'Billable') {
                	projects.add(proj);    
                }
            }   
        } 
        return projects;
    }
    
    @future(callout=true)
    public static void callBillingService(String ProjectId) {
        If(String.isNotBlank(ProjectId)) {
            List<Project__c> projects = [Select Id, Name, Billable_Amount__c, ProjectRef__c, Status__c 
                                         From Project__c
                                         Where Id =: ProjectId]; 
            
            BillingServiceProxy.project billingServiceProject = createProxyProject(projects[0]);
            
            BillingServiceProxy.billProjectRequest_element billProjReqElement = new BillingServiceProxy.billProjectRequest_element();
            billProjReqElement.project = billingServiceProject;
            
            BillingServiceProxy.InvoicesPortSoap11 service = new BillingServiceProxy.InvoicesPortSoap11(); 
            String response = service.billProject(billingServiceProject);
            System.debug('response ====> ' + response);
            if(String.isNotBlank(response) && response == 'OK') {
                Project__c project = new Project__c(Id = ProjectId, Status__c = 'Billed'); 
                Update project;
            }       
        }  
    }
    
    private static BillingServiceProxy.project createProxyProject(Project__c project) {
        BillingServiceProxy.project billingProject = new BillingServiceProxy.project();
        billingProject.username = ServiceCredentials__c.getValues('BillingServiceCredential').Username__c;
        billingProject.password = ServiceCredentials__c.getValues('BillingServiceCredential').Password__c;
        if(project != null) {
            billingProject.projectid = project.ProjectRef__c;
            billingProject.projectRef = project.ProjectRef__c;
            billingProject.billAmount = project.Billable_Amount__c;    
        } 
        return billingProject;
    }
}