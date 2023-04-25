public class SimulationOfDH {
    public static void main(String[] args) {
        //Creating control center and a drone.
        ControlCenter controlCenter = new ControlCenter(3);
        Drone drone1 = new Drone(new Data(0b11011111, 0b00000101));
        controlCenter.addDrone(drone1);

        //Setting drone and control center private keys.
        int privateKeyDrone = (int) (Math.random() * 255);
        Data drone1Data = drone1.getDroneData();
        int keyToSendByDrone = DataOperations.modPower(drone1Data.getG(), privateKeyDrone, drone1Data.getP());

        //Message 1 - drone sends its ID and generated key.
        String keyInMes1 = (String.format("%8s", Integer.toBinaryString(keyToSendByDrone))).replaceAll(" ", "0");
        String drone1ID = (String.format("%8s", Integer.toBinaryString(drone1.getDroneID()))).replaceAll(" ", "0");
        String message1 = drone1ID + keyInMes1;
        System.out.println("Message 1 - from drone to CC: " + message1);

        //Control center generates its key to send it to the drone and computes the final key.
        int receivedDroneID = Integer.parseInt(message1.substring(0, 8), 2);
        int receivedKeyByCC = Integer.parseInt(message1.substring(8, 16), 2);
        Data currentDrone = controlCenter.getDronesCommonData()[receivedDroneID];
        int privateKeyCC = (int) (Math.random() * 255);
        int keyToBeSendByCC = DataOperations.modPower(drone1Data.getG(), privateKeyCC, currentDrone.getP());
        int finalKeyCC = DataOperations.modPower(receivedKeyByCC, privateKeyCC, currentDrone.getP());
        String finalKeyCCtoString = (String.format("%8s", Integer.toBinaryString(finalKeyCC))).replaceAll(" ", "0");
        System.out.println("Final key computed by CC: "+ finalKeyCCtoString);

        //Message 2 - control center sends to drone its key;
        String message2 = (String.format("%8s", Integer.toBinaryString(keyToBeSendByCC))).replaceAll(" ", "0");
        System.out.println("Message 2 - from CC to the Drone: "+ message2);

        //Drone calculates its finalKey
        int receivedKeyByDrone = Integer.parseInt(message2, 2);
        int finalKeyDrone = DataOperations.modPower(receivedKeyByDrone, privateKeyDrone, drone1Data.getP());
        System.out.println("Final key computed by the Drone: "+ (String.format("%8s", Integer.toBinaryString(finalKeyDrone))).replaceAll(" ", "0"));
        System.out.println("Final keys of both sides are the same: "+ (finalKeyCC==finalKeyDrone));
    }
}
