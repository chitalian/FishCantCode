
public class SigmaTest {

	public static int slowSigma(int n) {
		int retVal = 0;
		for(int i = 1; i <= n; i++) {
			retVal += i;
		}
		return retVal;
	}
	
	public static int printTest(int n) {
		int fSumNum = n * (n+1);
		int fSum = fSumNum / 2;
		int slowSum = slowSigma(n);
		System.out.println("n = " + n + " n*(n+1) = " + fSumNum + " sum= " + fSum + " Slow Sum=" + slowSum);
		return fSum;
	}
	
	public static void main(String[] args) {
		int n = 1000;
		int  printTestResult = 0;
		while(printTestResult >= 0 && printTestResult < 1000000000l) {
			// TODO Auto-generated method stub
			printTestResult = printTest(n);
			n = n * 10;
		}
		System.exit(1);
	}

}
