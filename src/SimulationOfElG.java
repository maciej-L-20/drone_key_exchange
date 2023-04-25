public class SimulationOfElG {
    public static void main(String[] args) {
        //Creating control center and a drone.
        ControlCenter controlCenter = new ControlCenter(3);
        Drone drone1 = new Drone(new Data(0b11011111, 0b00000101));
        controlCenter.addDrone(drone1);

        //Setting drone and control center private keys.
        int p = drone1.getDroneData().getP(); // prime number p (encryption key part)
        int e1 = DataOperations.findPrimitiveRoot(p); // encryption key part e1
        int d = DataOperations.getRandomFromRange(1,p-2); // decryption key d
        int e2 = DataOperations.modPower(e1, d, p); // encryption key part e2
        int[] publicKey = {e1, e2, p}; // public key
        int privateKey = d; // private key

        //Printing Keys
        System.out.println("Public key components: " + Integer.toBinaryString(e1) + " " + Integer.toBinaryString(e2) + " "  + Integer.toBinaryString(p) + " ");
        System.out.println("Private key: " + Integer.toBinaryString(d));

        //Message 1 - drone sends its ID and generated key.
        int r = (int) (Math.random() * (p - 2)) + 1; // random number r
        int c1 = DataOperations.modPower(e1, r, p); // first part of ciphertext
        int plaintext = drone1.getDroneID(); // plaintext message
        int c2 = (DataOperations.modPower(e2, r, p) * plaintext) % p; // second part of ciphertext
        String message1 = String.format("%8s", Integer.toBinaryString(c1)).replaceAll(" ", "0") + String.format("%8s", Integer.toBinaryString(c2)).replaceAll(" ", "0");
        System.out.println("Message 1 from drone to CC: " + message1);

        //Control center decrypts the message and sends a response.
        int receivedC1 = Integer.parseInt(message1.substring(0, 8), 2);
        int receivedC2 = Integer.parseInt(message1.substring(8, 16), 2);
        int receivedPlaintext = DataOperations.modPower(receivedC1, p - 1 - privateKey, p) * receivedC2 % p; // decryption of plaintext
        int response = receivedPlaintext; // response message
        int r2 = (int) (Math.random() * (p - 2)) + 1; // random number r2
        int c1Response = DataOperations.modPower(e1, r2, p); // first part of response ciphertext
        int c2Response = (DataOperations.modPower(publicKey[1], r2, publicKey[2]) * response) % publicKey[2]; // second part of response ciphertext
        String message2 = String.format("%8s", Integer.toBinaryString(c1Response)).replaceAll(" ", "0") + String.format("%8s", Integer.toBinaryString(c2Response)).replaceAll(" ", "0");
        System.out.println("Message 2 - from CC to the Drone: " + message2);

        //Drone decrypts the response.
        int receivedC1Response = Integer.parseInt(message2.substring(0, 8), 2);
        int receivedC2Response = Integer.parseInt(message2.substring(8, 16), 2);
        int receivedResponse = DataOperations.modPower(receivedC1Response, p - 1 - privateKey, p) * receivedC2Response % p; // decryption of response
        System.out.println("Received response: " + receivedResponse);
    }

}