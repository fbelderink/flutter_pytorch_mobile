package io.fynn.pytorch_mobile;

public class Convert {

    public static String dtypeAsPrimitive(String dtype){
        switch (dtype.toLowerCase()){
            case "float32":
                return "Float";
            case "float64":
                return "Double";
            case "int32":
                return "Integer";
            case "int64":
                return "Long";
            case "int8":
                return "Byte";
            case "uint8":
                return "Byte";
            default:
                return null;
        }
    }

    public static long[] toPrimitives(Integer[] objects){
        long[] primitives = new long[objects.length];
        for(int i = 0; i < objects.length; i++){
            primitives[i] = objects[i].longValue();
        }
        return primitives;
    }

    public static byte[] toBytePrimitives(Double[] objects){
        byte[] primitives = new byte[objects.length];
        for(int i = 0; i < objects.length; i++){
            primitives[i] = objects[i].byteValue();
        }
        return primitives;
    }

    public static float[] toFloatPrimitives(Double[] objects){
        float[] primitives = new float[objects.length];
        for(int i = 0; i < objects.length; i++){
            primitives[i] = objects[i].floatValue();
        }
        return primitives;
    }

    public static double[] toDoublePrimitives(Double[] objects){
        double[] primitives = new double[objects.length];
        for(int i = 0; i < objects.length; i++){
            primitives[i] = objects[i].doubleValue();
        }
        return primitives;
    }

    public static long[] toLongPrimitives(Double[] objects){
        long[] primitives = new long[objects.length];
        for(int i = 0; i < objects.length; i++){
            primitives[i] = objects[i].longValue();
        }
        return primitives;
    }

    public static int[] toIntegerPrimitives(Double[] objects){
        int[] primitives = new int[objects.length];
        for(int i = 0; i < objects.length; i++){
            primitives[i] = objects[i].intValue();
        }
        return primitives;
    }
}
