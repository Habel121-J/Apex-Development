@IsTest
private class AccountTriggerHandlerTest {
    
    @IsTest
    static void testCheckIfFieldIsConcatinated(){
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
          insert new Account(
            Name = 'test_Account',
            BillingCity = 'test_city',
            BillingCountry = 'test_country'
          );
        }
        Test.stopTest();

        Account result = [SELECT Concat__c FROM Account];
        Assert.isTrue(String.isNotBlank(result.Concat__c));
    }

    

    @IsTest
    static void testCheckIfFieldIsConcatinatedWhenUpdated(){
        Account acc = new Account(
            Name = 'test_Account',
            BillingCity = 'test_city',
            BillingCountry = 'test_country'
          );
          insert acc;
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
            acc.BillingCity = 'test_city_other';
            acc.BillingCountry = 'test_country';
            update acc;
        }
        Test.stopTest();
        Assert.areEqual('test_city', [SELECT BillingCity FROM Account].BillingCity);
        Assert.isTrue(String.isNotBlank([SELECT Concat__c FROM Account LIMIT 1].Concat__c));
        Assert.areEqual('test_city_other : test_country', [SELECT Concat__c FROM Account LIMIT 1].Concat__c);
    }

    @IsTest
    static void testShouldThrowAnExceptionWhenClassIsInvokedOutsideTriger(){
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())){
            try {
                new AccountTriggerHandler().execute();
            } catch (Exception ex) {
                Assert.isTrue(String.isNotBlank(ex.getMessage()));
                Assert.areEqual('Please execute this class from a trigger.', ex.getMessage());
                Assert.isTrue(ex instanceof AccountTriggerHandler.AccountTriggerHandlerException);
            }
        }
        Test.stopTest();
        
    }
}