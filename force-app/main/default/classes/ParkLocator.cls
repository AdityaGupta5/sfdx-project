public class ParkLocator {

    public static List<String> country(String CountryName) {
        List<String> parkingList = new List<String>();
        ParkService.ParksImplPort park = new ParkService.ParksImplPort();
        parkingList = park.byCountry(CountryName);
        return parkingList;
    }
}