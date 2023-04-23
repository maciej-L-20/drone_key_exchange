public class DataOperations {
    public static long keyToBeExchanged(Data data, int selected) {
        int P = data.getP();
        int G = data.getG();
        long key = (long) (Math.pow(G, selected) % P);
        return key;
    }

    public static long SecretKey(long x, int b, int P) {
        long secretKey = (long) (Math.pow(x, b) % P);
        return secretKey;
    }

    public static int modPower(int base, int exponent, int modulus) {
        int res = 1; // Initialize result

        base = base % modulus; // Update x if it is more than or
        // equal to p

        if (base == 0)
            return 0; // In case x is divisible by p;

        while (exponent > 0) {

            // If y is odd, multiply x with result
            if ((exponent & 1) != 0)
                res = (res * base) % modulus;

            // y must be even now
            exponent = exponent >> 1; // y = y/2
            base = (base * base) % modulus;
        }
        return res;
    }
}
