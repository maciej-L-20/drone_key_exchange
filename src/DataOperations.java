import java.util.ArrayList;
import java.util.List;

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

    public static int findPrimitiveRoot(int p) {

        // Find the totient of p
        int phi = p - 1;

        // Find the prime factors of phi
        List<Integer> factors = primeFactors(phi);

        // Check every integer from 2 to p-1
        for (int g = 2; g <= p-1; g++) {
            boolean isPrimitiveRoot = true;

            // Check if g is a generator of the multiplicative group of integers modulo p
            for (int factor : factors) {
                int exp = phi / factor;
                int result = modPower(g, exp, p);

                if (result == 1) {
                    isPrimitiveRoot = false;
                    break;
                }
            }

            // If g is a primitive root, return it
            if (isPrimitiveRoot) {
                return g;
            }
        }

        // No primitive root found
        throw new IllegalArgumentException("No primitive root found for p");
    }

    public static List<Integer> primeFactors(int n) {
        List<Integer> factors = new ArrayList<>();

        for (int i = 2; i <= n/i; i++) {
            while (n % i == 0) {
                factors.add(i);
                n /= i;
            }
        }

        if (n > 1) {
            factors.add(n);
        }

        return factors;
    }

    public static int getRandomFromRange(int min, int max) {
        return (int) ((Math.random() * (max - min)) + min);
    }
}
