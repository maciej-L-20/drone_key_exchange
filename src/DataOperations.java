public class DataOperations {

    public static int modPower(int base, int exponent, int modulus) {
        int result = 1; // Initialize resultult

        base = base % modulus; // Update x if it is more than or
        // equal to p

        if (base == 0)
            return 0; // In case x is divisible by p;

        while (exponent > 0) {

            // If y is odd, multiply x with resultult
            if ((exponent & 1) != 0)
                result = (result * base) % modulus;

            // y must be even now
            exponent = exponent >> 1; // y = y/2
            base = (base * base) % modulus;
        }
        return result;
    }
}
