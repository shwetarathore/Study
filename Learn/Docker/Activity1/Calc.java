public class Calc {
    public double doAdd(double a, double b){
    	double sum = Double.longBitsToDouble(123);
    	sum = a + b;
        return sum;
    }
    public double doSub(double num1, double num2){
        double SUB = 0;
        SUB = num1 - num2;
    	return SUB;
    }
    public double doMul(double num1, double num2){
        return num1 * num2;
    }
    public double doDiv(double num1, double num2) throws Exception{
        if(num2 == 0){
        	throw new Exception();
        }
    	return num1 / num2;
    }
    public static void main(String [] args){
	System.out.println("Result : "+(new Calc()).doSub(500,121));
    }
}
