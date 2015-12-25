global without sharing class customAttachmentCtrl {

	global String parentId{get;set;}
		//this edit is done using atom id   e for salesforce development 
	public List<attachment> attachments;
	public Account parent;
	public List<Attachment> attachmentsToBeUploaded{get;set;}
	public List<blob> attachmentBodyList{get;set;}
	public static customAttachmentCtrl ctrl1 = new customAttachmentCtrl();
	public static customAttachmentCtrl ctrl2 = new customAttachmentCtrl();
	public CustomFIle__c customFIle{get;set;}
	public customFile__c sample{get;set;}
	global customAttachmentCtrl(){
		parent = [SELECT Id,Name FROM Account LIMIT 1];

		attachmentsToBeUploaded = new List<Attachment>{new Attachment()};
		customFIle = new CustomFIle__c();
	}

	@RemoteAction
	global static void createCustomFileWithoutAttachment(String jsonForCustomFileWrapper,String parentObjectId){
		customFileWrapperWithoutAttachments customFileWrapper =(customFileWrapperWithoutAttachments)JSON.deserialize(jsonForCustomFileWrapper, customFileWrapperWithoutAttachments.class);
		ctrl2.createCustomFileWithoutAttachment(customFileWrapper,parentObjectId);
	}

	public void createCustomFileWithoutAttachment(customFileWrapperWithoutAttachments customFileWrapper,String parentObjectId ){
		CustomFIle__c customFile = new CustomFIle__c();
		customFIle.ParentId__c = parentObjectId;
		customFile.Description__c = customFileWrapper.attachmentDescription;
		insert customFile;
	}

	@RemoteAction
	global static void saveAttachment(String jsonForFileWrapper,String parentObjectId){
		system.debug('jsonForFileWrapper--->>>'+jsonForFileWrapper);
	    fileWrapper fileWrapperList =(fileWrapper)JSON.deserialize(jsonForFileWrapper, fileWrapper.class);
	    system.debug('cparentObjectId--->>>'+parentObjectId);
	    //system.debug('ctrl.parentId--->>>'+ctrl.parentId);
	    ctrl1.createAttachments(fileWrapperList,parentObjectId);

	}

	public void createAttachments(fileWrapper fileWrapperList,String parentObjectId){
			attachment a = new Attachment();
			//system.debug('parentObjectId--------->>>'+parentObjectId);
			a.parentId = parentObjectId;
			a.Name = fileWrapperList.fileName;
			a.Description = fileWrapperList.attachmentDescription;
			a.Body = fileWrapperList.attachmentBody;
			system.debug('a.Body----->>>'+a.Body);
			insert a;
			createCustomFile(a,fileWrapperList);
	}


	public void createCustomFile(Attachment a,fileWrapper fileWrapperList){

		//CustomFile__c customFile = new CustomFile__c();
		customFIle.Name__c = a.Name;
		customFIle.ParentId__c = a.ParentId;
		customFIle.AttachmentId__c = a.Id;
		customFIle.Description__c = a.Description;
		customFile.Account__c = a.ParentId;
		system.debug('customFIle------>>>>'+customFIle);
		insert customFIle;
	}

	private List<fileWrapper> getFiles(){
		List<fileWrapper> newList = new List<fileWrapper>();
		system.debug('parentId in getFiles--->>>'+parentId);
		return newList;
	}

	public class customFileWrapperWithoutAttachments{
		public String attachmentDescription;
		public customFileWrapperWithoutAttachments(String attachmentDescription){

			this.attachmentDescription = attachmentDescription;
		}
	}

	public class fileWrapper{
		public String fileName;
		public String fileSize;
		public String fileType;
		public blob attachmentBody;
		public String attachmentDescription;
		public fileWrapper(String fileName,String fileSize,String fileType,blob attachmentBody,String attachmentDescription){
			this.fileName=fileName;
			this.fileSize=fileSize;
			this.fileType=fileType;
			this.attachmentBody = attachmentBody;
			this.attachmentDescription = attachmentDescription;
		}
	}
}