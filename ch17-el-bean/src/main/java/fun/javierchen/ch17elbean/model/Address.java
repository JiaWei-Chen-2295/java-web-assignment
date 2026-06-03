package fun.javierchen.ch17elbean.model;

public class Address {
    private String province;
    private String city;
    private String street;

    public Address() {}

    public Address(String province, String city, String street) {
        this.province = province;
        this.city = city;
        this.street = street;
    }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }

    public String getFullAddress() {
        return province + " " + city + " " + street;
    }
}
