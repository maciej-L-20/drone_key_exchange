public class Drone {
    private Data droneData;
    private int droneID;

    public Drone(Data droneData) {
        this.droneData = droneData;
    }

    public Data getDroneData() {
        return droneData;
    }

    public int getDroneID() {
        return droneID;
    }

    public void setDroneData(Data droneData) {
        this.droneData = droneData;
    }

    public void setDroneID(int droneID) {
        this.droneID = droneID;
    }
}
