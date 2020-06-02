public class AnimalLocator {
    
    public static String getAnimalNameById(Integer id) {
        string finalStr;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Map results ' + resultMap);
            //List<Object> animal = (List<Object>)resResults.get('animal');
            Map<String, Object> animalMap = (Map<String, Object>)resultMap.get('animal');
            System.debug('animalMap ' + animalMap);
            finalStr = String.valueOf(animalMap.get('name'));
            System.debug('finalStr : ' + finalStr);
        }
        return finalStr;
    }

}