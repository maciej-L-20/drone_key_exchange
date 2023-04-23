public class ControlCenter {
    private int numberOfDrones;
    private Data[] dronesCommonData;

    public ControlCenter(int numberOfDrones) {
        this.numberOfDrones = numberOfDrones;
        this.dronesCommonData = new Data[this.numberOfDrones];
    }

    public void addDrone(Drone drone) {
        for (int i = 0; i < numberOfDrones; i++) {
            if (dronesCommonData[i] == null) {
                dronesCommonData[i] = drone.getDroneData();
                drone.setDroneID((byte) i);
                return;
            }
        }
    }

    public Data[] getDronesCommonData() {
        return dronesCommonData;
    }
}
