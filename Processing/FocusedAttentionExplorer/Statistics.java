import java.util.Arrays;

public class Statistics {
    double[] data;
    int size;   

    public Statistics(double[] data) {
        this.data = data;
        size = data.length;
    }
    
    double getMin()
    {
      double minValue = data[0];
      for(double a : data)
        if(a < minValue) minValue = a;
      
      return minValue;
    }
    
    double getMax()
    {
      double maxValue = data[0];
      for(double a : data)
        if(a > maxValue) maxValue = a;
      
      return maxValue;
    }

    double getMean() {
        double sum = 0.0;
        for(double a : data)
            sum += a;
        return sum/size;
    }

    double getVariance() {
        double mean = getMean();
        double temp = 0;
        for(double a :data)
            temp += (a-mean)*(a-mean);
        return temp/(size-1);
    }

    double getStdDev() {
        return Math.sqrt(getVariance());
    }

    public double median() {
       Arrays.sort(data);

       if (data.length % 2 == 0) {
          return (data[(data.length / 2) - 1] + data[data.length / 2]) / 2.0;
       } 
       return data[data.length / 2];
    }
}